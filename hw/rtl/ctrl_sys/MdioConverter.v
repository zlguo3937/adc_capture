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
//  2023-10-08    zlguo         1.0         MdioConverter
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module MdioConverter
(
    input   wire            clk,
    input   wire            rstn,

    /* -----------------------------
     mdio req interface 22_45
     ---------------------------- */
    input   wire    [20:0]  mdio_req_paddr,
    input   wire            mdio_req_pwrite,
    input   wire            mdio_req_psel,
    input   wire            mdio_req_penable,
    input   wire    [15:0]  mdio_req_pwdata,
    output  reg             mdio_req_pready,
    output  reg     [15:0]  mdio_req_prdata,
    output  wire            mdio_req_pslverr,

    /* -----------------------------
     to apbmapper mdio interface
     ---------------------------- */
    output  reg     [31:0]  apbmapper_paddr,
    output  reg             apbmapper_pwrite,
    output  reg             apbmapper_psel,
    output  reg             apbmapper_penable,
    output  reg     [15:0]  apbmapper_pwdata,
    input   wire            apbmapper_pready,
    input   wire    [15:0]  apbmapper_prdata,
    input   wire            apbmapper_pslverr
);

    /* -----------------------------
     RegMapper
     ---------------------------- */
    localparam  DATA        = 21'h1F_FFFC,
                ADDR_H      = 21'h1F_FFFD,
                ADDR_L      = 21'h1F_FFFE,
                WRITE_CTRL  = 21'h1F_FFFF;


    localparam  READY       = 6'b00_0001,
                READ        = 6'b00_0010,
                BYPASS      = 6'b00_0100,
                WRITE       = 6'b00_1000,
                WAIT_BYPASS = 6'b01_0000,
                WAIT_WRITE  = 6'b10_0000;

    wire            timer_en;
    wire            timer_clr;
    wire            timer_done;
    
    reg     [5 :0]  n_state;
    reg     [5 :0]  state;

    reg     [15:0]  reg1_mdio_req_pwdata;
    reg     [15:0]  reg2_mdio_req_pwdata;
    reg     [15:0]  reg3_mdio_req_pwdata;
    reg     [15:0]  reg_ctrl_data;
    reg     [15:0]  prdata;
    reg     [31:0]  paddr;
    reg             pwrite;
    reg             psel;
    reg             penable;
    reg     [15:0]  pwdata;

    assign  timer_en    = state != READY;
    assign  timer_clr   = state == READY;

    assign  mdio_req_pslverr        = apbmapper_pslverr;

    assign  in_valid                = mdio_req_psel & mdio_req_penable;
    assign  in_reg_valid_valid      = mdio_req_paddr == 21'h1f_ffff & mdio_req_psel & mdio_req_penable;
    assign  in_reg_valid_valid_1    = mdio_req_paddr == 21'h1f_fffe & mdio_req_psel & mdio_req_penable;
    assign  in_reg_valid_valid_2    = mdio_req_paddr == 21'h1f_fffd & mdio_req_psel & mdio_req_penable;
    assign  in_reg_valid_valid_3    = mdio_req_paddr == 21'h1f_fffc & mdio_req_psel & mdio_req_penable;
    assign  in_reg_valid            = in_reg_valid_valid | in_reg_valid_valid_1 | in_reg_valid_valid_2 | in_reg_valid_valid_3;
    assign  in_reg_valid_we         = in_reg_valid & mdio_req_pwrite;
    
    // MDIO-45 ADDR_L
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            reg1_mdio_req_pwdata <= 16'h0;
        else if (mdio_req_paddr == ADDR_L & in_reg_valid_we)
            reg1_mdio_req_pwdata <= mdio_req_pwdata;
    end

    // MDIO-45 ADDR_H
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            reg2_mdio_req_pwdata <= 16'h0;
        else if (mdio_req_paddr == ADDR_H & in_reg_valid_we)
            reg2_mdio_req_pwdata <= mdio_req_pwdata;
    end

    // MDIO-45 DATA
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            reg3_mdio_req_pwdata <= 16'h0;
        else if (state == WAIT_WRITE) begin
            if (apbmapper_pready)
                reg3_mdio_req_pwdata <= apbmapper_prdata;
            else if (mdio_req_paddr == DATA & in_reg_valid_we)
                reg3_mdio_req_pwdata <= mdio_req_pwdata;
        end
        else begin 
            if (mdio_req_paddr == DATA & in_reg_valid_we)
                reg3_mdio_req_pwdata <= mdio_req_pwdata;
        end
    end

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            reg_ctrl_data <= 16'h0;
        else if (state == WAIT_WRITE) begin
            if (apbmapper_pready)
                reg_ctrl_data <= {reg_ctrl_data[15:1],1'b0};
            else if (mdio_req_paddr == WRITE_CTRL & in_reg_valid_we)
                reg_ctrl_data <= mdio_req_pwdata;
        end
        else begin
            if (mdio_req_paddr == WRITE_CTRL & in_reg_valid_we)
                reg_ctrl_data <= mdio_req_pwdata;
        end
    end

    // prdata
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            prdata <= 16'h0;
        else if (state == READY) begin
            if (~mdio_req_pwrite & in_reg_valid) begin
                case(mdio_req_paddr)
                    WRITE_CTRL:
                        prdata <= reg_ctrl_data;

                    ADDR_L    :
                        prdata <= reg1_mdio_req_pwdata;

                    ADDR_H    :
                        prdata <= reg2_mdio_req_pwdata;

                    DATA      :
                        prdata <= reg3_mdio_req_pwdata;

                    default: prdata <= 16'hffff;
                endcase
            end
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
                if (in_valid & ~in_reg_valid)
                    begin
                        paddr   <= {11'b1, mdio_req_paddr};
                        pwrite  <= mdio_req_pwrite;
                        psel    <= in_valid & ~in_reg_valid;
                        penable <= in_valid & ~in_reg_valid;
                        pwdata  <= mdio_req_pwdata;
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
            mdio_req_pready     = 1'b0;
            apbmapper_paddr     = 32'h0;
            apbmapper_pwrite    = 1'b0;
            apbmapper_psel      = 1'b0;
            apbmapper_penable   = 1'b0;
            apbmapper_pwdata    = 16'h0;

            if (timer_done) begin
                n_state         = READY;
                mdio_req_prdata = 16'hffff;
            end
            else begin
                n_state         = state;
                mdio_req_prdata = 16'h0;
            end
        end
        case(state)
            READY:
                begin
                    mdio_req_prdata     = 16'h0;
                    apbmapper_paddr     = 32'h0;
                    apbmapper_pwrite    = 1'b0;
                    apbmapper_psel      = 1'b0;
                    apbmapper_penable   = 1'b0;
                    apbmapper_pwdata    = 16'h0;

                    if (in_reg_valid_valid & mdio_req_pwrite & mdio_req_pwdata[0])
                        n_state = WRITE;
                    else if (in_reg_valid)
                        n_state = READ;
                    else if (in_valid & ~in_reg_valid)
                        n_state = BYPASS;
                end

            READ:
                begin
                    n_state             = READY;
                    mdio_req_prdata     = prdata;
                    mdio_req_pready     = 1'b1;
                    apbmapper_paddr     = 32'h0;
                    apbmapper_pwrite    = 1'b0;
                    apbmapper_psel      = 1'b0;
                    apbmapper_penable   = 1'b0;
                    apbmapper_pwdata    = 16'h0;
                end

            BYPASS:
                begin
                    n_state             = WAIT_BYPASS;
                    mdio_req_prdata     = 16'h0;
                    mdio_req_pready     = apbmapper_pready;
                    apbmapper_paddr     = paddr;
                    apbmapper_pwrite    = pwrite;
                    apbmapper_psel      = psel;
                    apbmapper_psel      = penable;
                    apbmapper_pwdata    = pwdata;
                end

            WRITE:
                begin
                    n_state             = WAIT_WRITE;
                    mdio_req_prdata     = 16'h0;
                    apbmapper_paddr     = {reg2_mdio_req_pwdata,reg1_mdio_req_pwdata};
                    apbmapper_pwrite    = reg_ctrl_data[1];
                    apbmapper_psel      = reg_ctrl_data[0];
                    apbmapper_penable   = reg_ctrl_data[0];
                    apbmapper_pwdata    = reg3_mdio_req_pwdata;
                end

            WAIT_BYPASS:
                begin
                    apbmapper_paddr     = 32'h0;
                    apbmapper_pwrite    = 1'b0;
                    apbmapper_psel      = 1'b0;
                    apbmapper_penable   = 1'b0;
                    apbmapper_pwdata    = 16'h0;

                    if (apbmapper_pready) begin
                        n_state = READY;
                        mdio_req_prdata = apbmapper_prdata;
                    end
                    else if (in_valid)
                        mdio_req_prdata = 16'hffff;
                    else
                        mdio_req_prdata = 16'h0;
                end

            WAIT_WRITE:
                begin
                    apbmapper_paddr     = 32'h0;
                    apbmapper_pwrite    = 1'b0;
                    apbmapper_psel      = 1'b0;
                    apbmapper_penable   = 1'b0;
                    apbmapper_pwdata    = 16'h0;

                    if (apbmapper_pready) begin
                        n_state = READY;
                    end
                    if (in_valid)
                        mdio_req_prdata = 16'hffff;
                    else
                        mdio_req_prdata = 16'h0;
                end
            default: n_state = state;
        endcase
    end

    MdioConverTimer
    MdioConverterTimer
    (
    .clk        (clk        ),
    .rstn       (rstn       ),
    .timer_en   (timer_en   ),
    .timer_clr  (timer_clr  ),
    .timer_done (timer_done )
    );

endmodule
