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
//  2024-05-14    zlguo         1.0         pulse_handshake
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module pulse_handshake
(
    input   wire                        src_clk,
    input   wire                        src_rstn,
    input   wire                        src_pulse,

    input   wire                        dst_clk,
    input   wire                        dst_rstn,
    output  wire                        dst_pulse,
    output  wire                        sync_busy
);

    wire    w_pulse_temp;
    wire    w_pulse_sync;
    wire    w_sync_rsp;
    reg     r_pulse_src;
    reg     r_pulse_dst;

    // Source clock domain
    always @(posedge src_clk or negedge src_rstn) begin
        if (!src_rstn)
            r_pulse_src <= 1'b0;
        else
            r_pulse_src <= w_pulse_temp;
    end

    assign w_pulse_temp = (src_pulse) ? 1'b1 : (w_sync_rsp ? 1'b0 : r_pulse_src);

    jlsemi_util_sync_pos_with_rst_low
    #(.SYNC_STEP (2))
    u_pulse_pos_rsp_sync
    (
    .clk    (src_clk        ),
    .rst_n  (src_rstn       ),
    .din    (w_pulse_sync   ),
    .dout   (w_sync_rsp     )
    );

    assign sync_busy = w_sync_rsp | r_pulse_src;

    // Destination clock domain
    jlsemi_util_sync_pos_with_rst_low
    #(.SYNC_STEP (2))
    u_pulse_pos_sync
    (
    .clk    (dst_clk        ),
    .rst_n  (dst_rstn       ),
    .din    (r_pulse_src    ),
    .dout   (w_pulse_sync   )
    );

    always @(posedge dst_clk or negedge dst_rstn) begin
        if (!dst_rstn)
            r_pulse_dst <= 1'b0;
        else
            r_pulse_dst <= w_pulse_sync;
    end

    assign dst_pulse = (~r_pulse_dst) & w_pulse_sync;

endmodule
