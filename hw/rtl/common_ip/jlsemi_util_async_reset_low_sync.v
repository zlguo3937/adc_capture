module jlsemi_util_async_reset_low_sync
#(
    parameter RST_SYNC_STAGE = 3
)(
    input   rst_n_i,
    input   clk_i,
    input   dft_rstnsync_scan_rstn_ctrl,
    input   dft_rstnsync_scan_rstn,
    output  rst_n_o
);

    wire  rst_n_pre;
    wire  rst_n_sync;

    jlsemi_util_mux_cell
    u_dont_touch_rstsync_syncrst_mux
    (
    .a0_i   (rst_n_i                    ),
    .a1_i   (dft_rstnsync_scan_rstn     ),
    .sel_i  (dft_rstnsync_scan_rstn_ctrl),
    .z_o    (rst_n_pre                  )
    );

    jlsemi_util_sync_pos_with_rst_low
    #(.SYNC_STEP (RST_SYNC_STAGE))
    u_rstsync_rstn_sync_cell
    (
    .clk    (clk_i      ),
    .rst_n  (rst_n_pre  ),
    .din    (1'b1       ),
    .dout   (rst_n_sync )
    );

    jlsemi_util_mux_cell
    u_dont_touch_rstsync_out_mux
    (
    .a0_i   (rst_n_sync                 ),
    .a1_i   (dft_rstnsync_scan_rstn     ),
    .sel_i  (dft_rstnsync_scan_rstn_ctrl),
    .z_o    (rst_n_o                    )
    );

endmodule
