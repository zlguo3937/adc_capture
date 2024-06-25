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
//  2024-01-30    zlguo         1.0         apb_handshake
//  2024-06-20    zlguo         2.0         handshake
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`timescale 1ns/1ns

module handshake
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 19
)
(
    input   wire                        clk_a,
    input   wire                        rstn_a,
    input   wire                        in_valid_a,
    input   wire                        in_ready_a,
    output  reg                         out_ready_a,
    input   wire                        write_a,
    input   wire    [ADDR_WIDTH-1:0]    addr_a,
    input   wire    [DATA_WIDTH-1:0]    wdata_a,
    output  reg     [DATA_WIDTH-1:0]    rdata_a,

    input   wire                        clk_b,
    input   wire                        rstn_b,
    output  reg                         write_b,
    output  reg     [ADDR_WIDTH-1:0]    addr_b,
    input   wire    [DATA_WIDTH-1:0]    rdata_b,
    output  reg     [DATA_WIDTH-1:0]    wdata_b,
    output  reg                         out_valid_b

);
    reg [1:0]               in_valid_a_dly;
    wire                    in_valid_a_pos;
    reg [ADDR_WIDTH-1:0]    reg_addr_a;
    reg [DATA_WIDTH-1:0]    reg_wdata_a;
    reg                     reg_write_a;

    reg                     req;
    reg [1:0]               req_sync;
    wire                    req_sync_pos;
    wire                    req_sync_neg;
    reg [DATA_WIDTH-1:0]    reg_rdata;

    reg                     rsp;
    reg [1:0]               rsp_sync;
    wire                    rsp_sync_pos;
    
    /* ---------------------------------------
     generate in_valid_a posedge in clock a
     ---------------------------------------- */
    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
            in_valid_a_dly <= 2'b0;
        else
            in_valid_a_dly <= { in_valid_a_dly[0], in_valid_a };
    end

    assign in_valid_a_pos = ~in_valid_a_dly[1] & in_valid_a_dly[0];

    /* ---------------------------------------
     reg paddr, pwdata, pwrite in clock a
     ---------------------------------------- */
    reg write_a_dly;
    reg [DATA_WIDTH-1:0] wdata_a_dly;
    reg [ADDR_WIDTH-1:0] addr_a_dly;

    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
        begin
            addr_a_dly  <= {(ADDR_WIDTH){1'b0}};
            wdata_a_dly <= {(DATA_WIDTH){1'b0}};
            write_a_dly <= 1'b0;
        end
        //else if (in_valid_a_pos)
        else if (in_valid_a)
        begin
            addr_a_dly  <= addr_a;
            wdata_a_dly <= wdata_a;
            write_a_dly <= write_a;
        end
    end

    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
        begin
            reg_addr_a  <= {(ADDR_WIDTH){1'b0}};
            reg_wdata_a <= {(DATA_WIDTH){1'b0}};
            reg_write_a <= 1'b0;
        end
        else if (in_valid_a_pos)
        begin
            reg_addr_a  <= addr_a_dly;
            reg_wdata_a <= wdata_a_dly;
            reg_write_a <= write_a_dly;
        end
    end
    
    /* ---------------------------------------
     generate req in clock a
     ---------------------------------------- */
    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
            req <= 1'b0;
        else if (in_valid_a_pos)
            req <= 1'b1;
        else if (rsp_sync_pos)
            req <= 1'b0;
    end
    
    /* ----------------------------------------------------------
     req sync in clock b, generate req_sync posedge and negedge
     ----------------------------------------------------------- */
    always @(posedge clk_b or negedge rstn_b)
    begin
        if (~rstn_b)
            req_sync <= 2'b0;
        else
            req_sync <= { req_sync[0], req };
    end
    
    assign req_sync_pos = ~req_sync[1] & req_sync[0];
    assign req_sync_neg = req_sync[1] & ~req_sync[0];

    /* ---------------------------------------
     reg rdata in clock b
     ---------------------------------------- */
    reg rsp_valid;
    always @(posedge clk_b or negedge rstn_b)
    begin
        if (~rstn_b)
            rsp_valid <= 1'b0;
        else if (req_sync_pos)
            rsp_valid <= 1'b1;
        else
            rsp_valid <= 1'b0;
    end

    always @(posedge clk_b or negedge rstn_b)
    begin
        if (~rstn_b)
            reg_rdata <={(DATA_WIDTH){1'b0}};
        else if (rsp_valid)
            reg_rdata <= rdata_b;
    end

    /* ---------------------------------------
     generate rsp in clock b
     ---------------------------------------- */
    always @(posedge clk_b or negedge rstn_b)
    begin
        if (~rstn_b)
            rsp <= 1'b0;
        else if (req_sync_pos) begin
            //if(in_ready_a)
            rsp <= 1'b1;
        end
        else if (req_sync_neg)
            rsp <= 1'b0;
    end

    /* ---------------------------------------
     rsp sync in clock a
     ---------------------------------------- */
    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
            rsp_sync <= 2'b0;
        else
            rsp_sync <= { rsp_sync[0], rsp };
    end

    assign rsp_sync_pos = ~rsp_sync[1] & rsp_sync[0];

    /* ---------------------------------------
     output rdata in clock a
     ---------------------------------------- */
    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
            rdata_a <= 2'b0;
        else if (rsp_sync_pos)
            rdata_a <= reg_rdata;
    end

    /* ---------------------------------------
     generate out_valid_b in clock b
     ---------------------------------------- */
    always @(posedge clk_b or negedge rstn_b)
    begin
        if (~rstn_b)
            out_valid_b <= 1'b0;
        else if (req_sync_pos)
            out_valid_b <= 1'b1;
        else
            out_valid_b <= 1'b0;
    end

    /* ---------------------------------------
     generate out_valid_a in clock a
     ---------------------------------------- */
    always @(posedge clk_a or negedge rstn_a)
    begin
        if (~rstn_a)
            out_ready_a <= 1'b0;
        else if (rsp_sync_pos)
            out_ready_a <= 1'b1;
        else
            out_ready_a <= 1'b0;
    end

    /* ---------------------------------------
     out paddr, pwdata, pwrite in clock b
     ---------------------------------------- */
    always @(posedge clk_b or negedge rstn_b)
    begin
        if (~rstn_b)
        begin
            addr_b  <= {(ADDR_WIDTH){1'b0}};
            wdata_b <= {(DATA_WIDTH){1'b0}};
            write_b <= 1'b0;
        end
        else if (req_sync_pos)
        begin
            addr_b  <= reg_addr_a;
            wdata_b <= reg_wdata_a;
            write_b <= reg_write_a;
        end
        //else if (req_sync_neg)
        else
        begin
            addr_b  <= {(ADDR_WIDTH){1'b0}};
            wdata_b <= {(DATA_WIDTH){1'b0}};
            write_b <= 1'b0;
        end
    end

endmodule
