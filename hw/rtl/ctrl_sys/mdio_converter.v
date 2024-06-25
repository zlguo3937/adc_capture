// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name : Zhiling Guo
//                     Email: zlguo@jlsemi.com
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2023-10-08    zlguo         1.0         mdio_converter
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module mdio_converter
(
    input   wire            clk,
    input   wire            rstn,

    /* -----------------------------
     mdio req interface 22_45
     ---------------------------- */
    input   wire    [20:0]  req_paddr,
    input   wire            req_pwrite,
    input   wire            req_psel,
    input   wire            req_penable,
    input   wire    [15:0]  req_pwdata,
    output  reg             req_pready,
    output  reg     [15:0]  req_prdata,
    output  wire            req_pslverr,

    /* -----------------------------
     to apbmapper mdio interface
     ---------------------------- */
    output  reg     [31:0]  out_paddr,
    output  reg             out_pwrite,
    output  reg             out_psel,
    output  reg             out_penable,
    output  reg     [15:0]  out_pwdata,
    input   wire            out_pready,
    input   wire    [15:0]  out_prdata,
    input   wire            out_pslverr
);

    /* -----------------------------
     802.3 Clause45 MDIO Proxy 
	 Register Mapping
     ---------------------------- */
    localparam      DATA        = 21'h1F_FFFC,
                    ADDR_H      = 21'h1F_FFFD,
                    ADDR_L      = 21'h1F_FFFE,
                    WRITE_CTRL  = 21'h1F_FFFF;


    /* -----------------------------
     FSM localparam
     ---------------------------- */
    localparam      READY       = 6'b00_0001,
                    READ        = 6'b00_0010,
                    BYPASS      = 6'b00_0100,
                    WRITE       = 6'b00_1000,
                    WAIT_BYPASS = 6'b01_0000,
                    WAIT_WRITE  = 6'b10_0000;

    wire            timer_en;
    wire            timer_clr;
    wire            timer_done;

    wire            in_mdio_valid;
    wire            proxy_valid_ctrl;
    wire            proxy_valid_addr_l;
    wire            proxy_valid_addr_h;
    wire            proxy_valid_data;
    wire            proxy_valid;

    reg     [5 :0]  n_state;
    reg     [5 :0]  state;

    reg     [15:0]  proxy_req_addr_l_pwdata;
    reg     [15:0]  proxy_req_addr_h_pwdata;
    reg     [15:0]  proxy_req_data_pwdata;
    reg     [15:0]  proxy_req_ctrl_pwdata;

    reg     [15:0]  prdata;
    reg     [31:0]  paddr;
    reg             pwrite;
    reg             psel;
    reg             penable;
    reg     [15:0]  pwdata;
    
    assign  in_mdio_valid         = req_psel & req_penable;
    assign  proxy_valid_ctrl      = req_paddr == 21'h1f_ffff & in_mdio_valid;
    assign  proxy_valid_addr_l    = req_paddr == 21'h1f_fffe & in_mdio_valid;
    assign  proxy_valid_addr_h    = req_paddr == 21'h1f_fffd & in_mdio_valid;
    assign  proxy_valid_data      = req_paddr == 21'h1f_fffc & in_mdio_valid;
    assign  proxy_valid           = proxy_valid_ctrl | proxy_valid_addr_l | proxy_valid_addr_h | proxy_valid_data;

    // 802.3 Clause45 MDIO ADDR_L
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            proxy_req_addr_l_pwdata <= 16'h0;
        else if (req_paddr == ADDR_L & req_pwrite)
            proxy_req_addr_l_pwdata <= req_pwdata;
    end

    // 802.3 Clause45 MDIO ADDR_H
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            proxy_req_addr_h_pwdata <= 16'h0;
        else if (req_paddr == ADDR_H & req_pwrite)
            proxy_req_addr_h_pwdata <= req_pwdata;
    end

    // 802.3 Clause45 MDIO DATA
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            proxy_req_data_pwdata <= 16'h0;
        else if (state == WAIT_WRITE)
            begin
                if (out_pready)
                    proxy_req_data_pwdata <= out_prdata;
                else if (req_paddr == DATA & req_pwrite)
                    proxy_req_data_pwdata <= req_pwdata;
            end
        else
            begin 
                if (req_paddr == DATA & req_pwrite)
                    proxy_req_data_pwdata <= req_pwdata;
            end
    end

    // 802.3 Clause45 MDIO Proxy CTRL data
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            proxy_req_ctrl_pwdata <= 16'h0;
        else if (state == WAIT_WRITE)
            begin
                if (out_pready)
                    proxy_req_ctrl_pwdata <= {proxy_req_ctrl_pwdata[15:1],1'b0};
                else if (req_paddr == WRITE_CTRL & req_pwrite)
                    proxy_req_ctrl_pwdata <= req_pwdata;
            end
        else
            begin
                if (req_paddr == WRITE_CTRL & req_pwrite)
                    proxy_req_ctrl_pwdata <= req_pwdata;
            end
    end

    // paddr, pwrite, psel, penable, pwdata
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            begin
                paddr   <= 32'h0;
                pwrite  <= 1'b0;
                psel    <= 1'b0;
                penable <= 1'b0;
                pwdata  <= 16'h0;
            end
        else if (state == READY)
            begin
                if (in_mdio_valid & ~proxy_valid)
                    begin
                        paddr   <= {11'b1, req_paddr};
                        pwrite  <= req_pwrite;
                        psel    <= in_mdio_valid & ~proxy_valid;
                        penable <= in_mdio_valid & ~proxy_valid;
                        pwdata  <= req_pwdata;
                    end
            end
    end

    // prdata
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            prdata <= 16'h0;
        else if (state == READY)
            begin
                if (~req_pwrite & proxy_valid)
                    begin
                        case(req_paddr)
                            WRITE_CTRL:
                                prdata <= proxy_req_ctrl_pwdata;

                            ADDR_L    :
                                prdata <= proxy_req_addr_l_pwdata;

                            ADDR_H    :
                                prdata <= proxy_req_addr_h_pwdata;

                            DATA      :
                                prdata <= proxy_req_data_pwdata;

                            default: prdata <= 16'hffff;
                        endcase
                    end
            end
    end

    /* -----------------------------
     Converter FSM
     ---------------------------- */
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            state <= READY;
        else
            state <= n_state;
    end

    always @(*)
    begin
        begin
            req_pready     = 1'b0;
            out_paddr     = 32'h0;
            out_pwrite    = 1'b0;
            out_psel      = 1'b0;
            out_penable   = 1'b0;
            out_pwdata    = 16'h0;

            if (timer_done)
                begin
                    n_state    = READY;
                    req_prdata = 16'hffff;
                end
            else
                begin
                    n_state    = state;
                    req_prdata = 16'h0;
                end
        end

        case(state)
            READY:
                begin
                    req_prdata     = 16'h0;
                    out_paddr     = 32'h0;
                    out_pwrite    = 1'b0;
                    out_psel      = 1'b0;
                    out_penable   = 1'b0;
                    out_pwdata    = 16'h0;
                    if (proxy_valid_ctrl & req_pwrite & req_pwdata[0])
                        n_state = WRITE;
                    else if (proxy_valid)
                        n_state = READ;
                    else if (in_mdio_valid & ~proxy_valid)
                        n_state = BYPASS;
                end

            READ:
                begin
                    n_state       = READY;
                    req_prdata    = prdata;
                    req_pready    = 1'b1;
                    out_paddr     = 32'h0;
                    out_pwrite    = 1'b0;
                    out_psel      = 1'b0;
                    out_penable   = 1'b0;
                    out_pwdata    = 16'h0;
                end

            BYPASS:
                begin
                    n_state       = WAIT_BYPASS;
                    req_prdata    = 16'h0;
                    req_pready    = out_pready;
                    out_paddr     = paddr;
                    out_pwrite    = pwrite;
                    out_psel      = psel;
                    out_psel      = penable;
                    out_pwdata    = pwdata;
                end

            WRITE:
                begin
                    n_state       = WAIT_WRITE;
                    req_prdata    = 16'h0;
                    out_paddr     = {proxy_req_addr_h_pwdata, proxy_req_addr_l_pwdata};
                    out_pwrite    = proxy_req_ctrl_pwdata[1];
                    out_psel      = proxy_req_ctrl_pwdata[0];
                    out_penable   = proxy_req_ctrl_pwdata[0];
                    out_pwdata    = proxy_req_data_pwdata;
                end

            WAIT_BYPASS:
                begin
                    if (out_pready)
                        n_state       = READY;
                        out_paddr     = 32'h0;
                        out_pwrite    = 1'b0;
                        out_psel      = 1'b0;
                        out_penable   = 1'b0;
                        out_pwdata    = 16'h0;
                        n_state       = READY;
                    if (out_pready)
                        begin
                            n_state = READY;
                            req_prdata = out_prdata;
                        end
                    else if (in_mdio_valid)
                        req_prdata = 16'hffff;
                    else
                        req_prdata = 16'h0;
                end

            WAIT_WRITE:
                begin
                    out_paddr     = 32'h0;
                    out_pwrite    = 1'b0;
                    out_psel      = 1'b0;
                    out_penable   = 1'b0;
                    out_pwdata    = 16'h0;

                    if (out_pready)
                        n_state = READY;
                    if (in_mdio_valid)
                        req_prdata = 16'hffff;
                    else
                        req_prdata = 16'h0;
                end
            default: n_state = state;
        endcase
    end

    mdio_converter_timer
    u_mdio_converter_timer
    (
    .clk        (clk        ),
    .rstn       (rstn       ),
    .timer_en   (timer_en   ),
    .timer_clr  (timer_clr  ),
    .timer_done (timer_done )
    );

endmodule
