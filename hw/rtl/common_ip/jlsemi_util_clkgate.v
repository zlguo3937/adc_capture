`timescale 1ns/1ns
module jlsemi_util_clkgate
#(
    parameter RST_SYNC_STAGE = 3,
    parameter SYNC_STEP      = 2
)(
    input   clk_i,
    input   clk_en_i,
    input   rstn_i,
    input   dft_rstnsync_scan_rstn,
    input   dft_rstnsync_scan_rstn_ctrl,
    input   dft_rtl_icg_en,
    output  clk_o
);

    wire    rstn_sync;
    wire    en_sync;

    jlsemi_util_async_reset_low_sync
    #(.RST_SYNC_STAGE (RST_SYNC_STAGE))
    u_clkgate_rstn_sync
    (
    .rst_n_i                    (rstn_i                     ),
    .clk_i                      (clk_i                      ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .rst_n_o                    (rstn_sync                  )
    );

    jlsemi_util_sync_pos_with_rst_low
    #(.SYNC_STEP (SYNC_STEP))
    u_clkgate_en_sync
    (
    .clk    (clk_i      ),
    .rst_n  (rstn_sync  ),
    .din    (clk_en_i   ),
    .dout   (en_sync    )
    );

    `ifdef JL_SYNTHESIS
        jlsemi_cell_clk_gating_cell
        u_dont_touch_clk_gating
        (
        .TE (dft_rtl_icg_en ),
        .E  (en_sync        ),
        .CP (clk_i          )
        .Q  (clk_o          )
        );
    `else
        reg en_sync_latch;
        always @(*)
            if(!clk_i)
                en_sync_latch <= en_sync | dft_rtl_icg_en;
    
        assign clk_o = clk_i & en_sync_latch;
    `endif

endmodule
