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
//  2023-10-06    zlguo         1.0         apb_arbiter_handsk
//  2024-06-20    zlguo         2.0         arbiter_handshake
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`timescale 1ns/1ns

module arbiter_handshake
#(
    parameter ADDR_WIDTH    = 21,
    parameter DATA_WIDTH    = 16,
    parameter CFG_TIMEOUT   = 16
)
(
    input   wire                        clk,
    input   wire                        rstn,
    input   wire                        dev_clk,
    input   wire                        dev_rstn,
    input   wire    [CFG_TIMEOUT-1:0]   cfg_timeout,

    /* -----------------------------
     mdio interface
     ---------------------------- */
    input   wire    [ADDR_WIDTH-1:0]    mdio_paddr,
    input   wire                        mdio_penable,
    input   wire                        mdio_psel,
    input   wire                        mdio_pwrite,
    input   wire    [DATA_WIDTH-1:0]    mdio_pwdata,
    output  wire    [DATA_WIDTH-1:0]    mdio_prdata,
    output  reg                         mdio_pready,
    output  reg                         mdio_pslverr,

    /* -----------------------------
     cpu interface
     ---------------------------- */
    input   wire    [ADDR_WIDTH-1:0]    cpu_paddr,
    input   wire                        cpu_penable,
    input   wire                        cpu_psel,
    input   wire                        cpu_pwrite,
    input   wire    [DATA_WIDTH-1:0]    cpu_pwdata,
    output  wire    [DATA_WIDTH-1:0]    cpu_prdata,
    output  reg                         cpu_pready,
    output  reg                         cpu_pslverr,

    /* -----------------------------
     apb3 interface
     ---------------------------- */
    input   wire    [ADDR_WIDTH-1:0]    apb_paddr,
    input   wire                        apb_penable,
    input   wire                        apb_psel,
    input   wire                        apb_pwrite,
    input   wire    [DATA_WIDTH-1:0]    apb_pwdata,
    output  wire    [DATA_WIDTH-1:0]    apb_prdata,
    output  reg                         apb_pready,
    output  reg                         apb_pslverr,

    /* -----------------------------------------------------------------------
     group interface: req_addr, req_rdata ...
     ----------------------------------------------------------------------- */
    output  wire    [ADDR_WIDTH-1:0]    req_addr,
    output  wire                        req_write,
    output  wire                        req_sel,
    output  wire    [DATA_WIDTH-1:0]    req_wdata,
    input   wire                        req_ready,
    input   wire    [DATA_WIDTH-1:0]    req_rdata
);

    localparam  IDLE            =   7'b000_0001,
                INPUT_MDIO      =   7'b000_0010,
                INPUT_CPU       =   7'b000_0100,
                INPUT_APB       =   7'b000_1000,
                TIMEOUT_MDIO    =   7'b001_0000,
                TIMEOUT_CPU     =   7'b010_0000,
                TIMEOUT_APB     =   7'b100_0000;

    reg [ADDR_WIDTH-1:0]    mdio_paddr_r;
    reg                     mdio_pwrite_r;
    reg [DATA_WIDTH-1:0]    mdio_pwdata_r;
    reg [ADDR_WIDTH-1:0]    cpu_paddr_r;
    reg                     cpu_pwrite_r;
    reg [DATA_WIDTH-1:0]    cpu_pwdata_r;
    reg [ADDR_WIDTH-1:0]    apb_paddr_r;
    reg                     apb_pwrite_r;
    reg [DATA_WIDTH-1:0]    apb_pwdata_r;

    wire                    mdio_valid;
    wire                    cpu_valid;
    wire                    apb_valid;
    wire                    mdio_timeout;
    wire                    cpu_timeout;
    wire                    apb_timeout;

    reg [6:0]               curr_sta;
    reg [6:0]               next_sta;

    reg [CFG_TIMEOUT-1:0]   mdio_timeout_cnt;
    reg [CFG_TIMEOUT-1:0]   cpu_timeout_cnt;
    reg [CFG_TIMEOUT-1:0]   apb_timeout_cnt;

    reg                     handsk_in_valid;
    reg     [31:0]          handsk_in_pwdata;

    wire                    handsk_in_pready;
    reg                     handsk_in_pwrite;
    reg     [31:0]          handsk_in_paddr;
    wire    [31:0]          handsk_in_prdata;

    wire                    handsk_out_valid;
    wire                    handsk_out_pready;
    wire                    handsk_out_pwrite;
    wire    [31:0]          handsk_out_pwdata;
    wire    [31:0]          handsk_out_paddr;
    wire    [31:0]          handsk_out_prdata;

    /* -----------------------------------------
     apb handshake
     ---------------------------------------- */
    assign  handsk_in_prdata = req_rdata;
    assign  handsk_in_pready = req_ready;

    assign  req_wdata  = handsk_out_pwdata;
    assign  req_write  = handsk_out_pwrite;
    assign  req_addr   = handsk_out_paddr;
    assign  req_sel    = handsk_out_valid;

    handshake #(32,32)
    u_handsk
    (
    .clk_a              (clk                ),
    .rstn_a             (rstn               ),
    .in_valid_a         (handsk_in_valid    ),
    .in_ready_a         (handsk_in_pready   ),
    .out_ready_a        (handsk_out_pready  ),
    .write_a            (handsk_in_pwrite   ),
    .addr_a             (handsk_in_paddr    ),
    .wdata_a            (handsk_in_pwdata   ),
    .rdata_a            (handsk_out_prdata  ),

    .clk_b              (dev_clk            ),
    .rstn_b             (dev_rstn           ),
    .write_b            (handsk_out_pwrite  ),
    .addr_b             (handsk_out_paddr   ),
    .rdata_b            (handsk_in_prdata   ),
    .wdata_b            (handsk_out_pwdata  ),
    .out_valid_b        (handsk_out_valid   )
    );


    /* -----------------------------------------
     Arbitor FSM
     ---------------------------------------- */


    assign mdio_valid   =   mdio_psel & mdio_penable;
    assign cpu_valid    =   cpu_psel  & cpu_penable;
    assign apb_valid    =   apb_psel  & apb_penable;

    assign mdio_timeout =   mdio_timeout_cnt == {{(CFG_TIMEOUT-3){1'b0}},4'h4};
    assign cpu_timeout  =   cpu_timeout_cnt == cfg_timeout;
    assign apb_timeout  =   apb_timeout_cnt == cfg_timeout;

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn) begin
            mdio_pwrite_r <= 1'b0;
            mdio_paddr_r  <= {ADDR_WIDTH{1'b0}};
            mdio_pwdata_r <= {DATA_WIDTH{1'b0}};
            cpu_pwrite_r  <= 1'b0;
            cpu_paddr_r   <= {ADDR_WIDTH{1'b0}};
            cpu_pwdata_r  <= {DATA_WIDTH{1'b0}};
            apb_pwrite_r  <= 1'b0;
            apb_paddr_r   <= {ADDR_WIDTH{1'b0}};
            apb_pwdata_r  <= {DATA_WIDTH{1'b0}};
        end
        else begin
            mdio_pwrite_r <= mdio_pwrite;
            mdio_paddr_r  <= mdio_paddr;
            mdio_pwdata_r <= mdio_pwdata;
            cpu_pwrite_r  <= cpu_pwrite;
            cpu_paddr_r   <= cpu_paddr;
            cpu_pwdata_r  <= cpu_pwdata;
            apb_pwrite_r  <= apb_pwrite;
            apb_paddr_r   <= apb_paddr;
            apb_pwdata_r  <= apb_pwdata;
        end
    end

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            curr_sta <= IDLE;
        else
            curr_sta <= next_sta;
    end

    always @(*)
    begin
        begin
            mdio_timeout_cnt    = {CFG_TIMEOUT{1'b0}};
            cpu_timeout_cnt     = {CFG_TIMEOUT{1'b0}};

            handsk_in_paddr     = {ADDR_WIDTH{1'b0}};
            handsk_in_pwrite    = 1'b0;
            handsk_in_valid     = 1'b0;
            handsk_in_pwdata    = {DATA_WIDTH{1'b0}};
            
            mdio_pready         = 1'b0;
            cpu_pready          = 1'b0;
            apb_pready          = 1'b0;

            mdio_pslverr        = 1'b0;
            cpu_pslverr         = 1'b0;

            next_sta = curr_sta;
        end

        case (curr_sta)
            IDLE:
                begin
                    if (mdio_valid)
                        next_sta = INPUT_MDIO;
                    else if (cpu_valid)
                        next_sta = INPUT_CPU;
                    else if (apb_valid)
                        next_sta = INPUT_APB;
                end

            INPUT_MDIO:
                begin
                    mdio_timeout_cnt    = mdio_timeout_cnt + 1'b1;;
                    handsk_in_paddr     = mdio_paddr_r;
                    handsk_in_pwrite    = mdio_pwrite_r;
                    handsk_in_valid     = 1'b1;
                    handsk_in_pwdata    = mdio_pwdata_r;

                    if (mdio_timeout)
                        next_sta = TIMEOUT_MDIO;
                    else if (handsk_out_pready) 
                        begin
                            mdio_pready = 1'b1;
                            next_sta = IDLE;
                        end
                end

            INPUT_CPU:
                begin
                    cpu_timeout_cnt     = cpu_timeout_cnt + 1'b1;;
                    handsk_in_paddr     = cpu_paddr_r;
                    handsk_in_pwrite    = cpu_pwrite_r;
                    handsk_in_valid     = 1'b1;
                    handsk_in_pwdata    = cpu_pwdata_r;

                    if (cpu_timeout)
                        next_sta = TIMEOUT_CPU;
                    else if (handsk_out_pready) 
                        begin
                            cpu_pready = 1'b1;
                            next_sta = IDLE;
                        end
                end

            INPUT_APB:
                begin
                    apb_timeout_cnt     = apb_timeout_cnt + 1'b1;;
                    handsk_in_paddr     = apb_paddr_r;
                    handsk_in_pwrite    = apb_pwrite_r;
                    handsk_in_valid     = 1'b1;
                    handsk_in_pwdata    = apb_pwdata_r;

                    if (apb_timeout)
                        next_sta = TIMEOUT_APB;
                    else if (handsk_out_pready) 
                        begin
                            cpu_pready = 1'b1;
                            next_sta = IDLE;
                        end
                end

            TIMEOUT_MDIO:
                begin
                    mdio_pready  = 1'b1;
                    mdio_pslverr = 1'b1;
                end

            TIMEOUT_CPU:
                begin
                    cpu_pready  = 1'b1;
                    cpu_pslverr = 1'b1;
                end

            TIMEOUT_APB:
                begin
                    apb_pready  = 1'b1;
                    apb_pslverr = 1'b1;
                end

            default: begin
                mdio_timeout_cnt    = {CFG_TIMEOUT{1'b0}};
                cpu_timeout_cnt     = {CFG_TIMEOUT{1'b0}};
                apb_timeout_cnt     = {CFG_TIMEOUT{1'b0}};

                handsk_in_paddr     = {ADDR_WIDTH{1'b0}};
                handsk_in_pwrite    = 1'b0;
                handsk_in_valid     = 1'b0;
                handsk_in_pwdata    = {DATA_WIDTH{1'b0}};
                
                mdio_pready         = 1'b0;
                cpu_pready          = 1'b0;
                apb_pready          = 1'b0;

                mdio_pslverr        = 1'b0;
                cpu_pslverr         = 1'b0;
                apb_pslverr         = 1'b0;

                next_sta = IDLE;
            end
        endcase
    end


    // mdio_prdata and cpu_prdata generate
    assign mdio_prdata  = handsk_out_prdata;
    assign cpu_prdata   = handsk_out_prdata;
    assign apb_prdata   = handsk_out_prdata;

endmodule
