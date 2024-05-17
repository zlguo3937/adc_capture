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
//  2024-05-14    zlguo         1.0         multi_handshake
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module multi_handshake
#(
    parameter DATA_WIDTH = 16
)
(
    // Source clock domain
    input   wire                        src_clk,
    input   wire                        src_rstn,
    input   wire                        vld_in,
    input   wire    [DATA_WIDTH-1:0]    din,
    output  reg                         rdy_out,

    // Dst clock domain
    input   wire                        dst_clk,
    input   wire                        dst_rstn,
    output  reg                         vld_out,
    output  reg     [DATA_WIDTH-1:0]    dout

);

    reg                         src_req;
    reg                         dst_rsp;

    reg     [DATA_WIDTH-1:0]    reg_src_din;
    wire    [DATA_WIDTH-1:0]    reg_din_dst_sync;

    wire                        rsp_src_sync;
    wire                        req_dst_sync;

    // Source clock domain
    always @(posedge src_clk or negedge src_rstn) begin
        if (!src_rstn)
            src_req <= 1'b0;
        else if (vld_in)
            src_req <= 1'b1;
        else if (rsp_src_sync)
            src_req <= 1'b0;
    end

    always @(posedge src_clk or negedge src_rstn) begin
        if (!src_rstn)
            reg_src_din <= {DATA_WIDTH{1'b0}};
        else if (vld_in)
            reg_src_din <= din;
    end

    jlsemi_util_sync_pos_with_rst_low
    u_sync_dst_rsp_to_src
    (
    .clk    (src_clk            ),
    .rst_n  (src_rstn           ),
    .din    (dst_rsp            ),
    .dout   (rsp_src_sync       )
    );

    always @(posedge src_clk or negedge src_rstn) begin
        if (!src_rstn)
            rdy_out <= 1'b0;
        else if (src_req & rsp_src_sync)
            rdy_out <= 1'b1;
        else
            rdy_out <= 1'b0;
    end

    // Source clock domain
    always @(posedge dst_clk or negedge dst_rstn) begin
        if (!dst_rstn)
            dst_rsp <= 1'b0;
        else if (req_dst_sync)
            dst_rsp <= 1'b1;
        else
            dst_rsp <= 1'b0;
    end

    jlsemi_util_sync_pos_with_rst_low
    u_sync_src_req_to_dst
    (
    .clk    (src_clk            ),
    .rst_n  (src_rstn           ),
    .din    (src_req            ),
    .dout   (req_dst_sync       )
    );

    always @(posedge dst_clk or negedge dst_rstn) begin
        if (!dst_rstn)
            vld_out <= 1'b0;
        else if (req_dst_sync)
            vld_out <= 1'b1;
        else
            vld_out <= 1'b0;
    end

    synchronizer#(
        .DATA_WIDTH (DATA_WIDTH ),
        .INIT_VALUE (0          ))
    u_sync_reg_src_din_to_dst
    (
    .clk    (dst_clk            ),
    .rstn   (dst_rstn           ),
    .din    (reg_src_din        ),
    .dout   (reg_din_dst_sync   )
    );

    always @(posedge dst_clk or negedge dst_rstn) begin
        if (!dst_rstn)
            dout <= {DATA_WIDTH{1'b0}};
        else if (req_dst_sync)
            dout <= reg_din_dst_sync;
    end

endmodule
