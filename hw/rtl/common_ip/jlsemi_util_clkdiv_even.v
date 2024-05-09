module jlsemi_util_clkdiv_even
#(
    parameter RST_SYNC_STAGE = 3,
    parameter DIV_N          = 2
)(
    input   wire        dft_stuck_at_mode,
    input   wire        dft_tpi_clk,
    input   wire        dft_clkdiv_rstn_ctrl,
    input   wire        dft_clkdiv_scan_rstn,
    input   wire        dft_scan_en,
`ifdef JL_SYNTHESIS
    input   wire        scanin, // spyglass disable W240
    output  wire        scanout,
`endif
    input   wire        clk_in,
    input   wire        rstn_in,
    output  wire        clk_out
);

    reg     [(DIV_N/2)-1:0] cnt;
    reg                     clk_out_pre;
    wire                    clk_in_pre;
    wire                    rstn_out;
    
    //function clock and scan clock mux
    jlsemi_util_clkmux_sel1
    u_dont_touch_clkdiv_clkmux
    (
    .clk0_i             (clk_in             ),
    .clk1_i             (dft_tpi_clk        ),
    .sel_i              (1'b0               ),
    .dft_test_clk_en    (dft_stuck_at_mode  ),
    .clk_o              (clk_in_pre         )
    );
    
    // dft_scan_en && dft_stuck_at_mode
    jlsemi_util_and_cell
    u_dont_touch_clkdiv_scanen_stuckatmode_and
    (
    .a_i                (dft_scan_en        ),
    .b_i                (dft_stuck_at_mode  ),
    .z_o                (                   ) // spyglass disable W287b
    );
    
    // reset sync for div counter register
    jlsemi_util_async_reset_low_sync
    #(.RST_SYNC_STAGE(RST_SYNC_STAGE))
    u_dont_touch_clkdiv_rst_sync_reg_cell
    (
    .rst_n_i                      (rstn_in              ),
    .clk_i                        (clk_in_pre           ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_clkdiv_rstn_ctrl ),
    .dft_rstnsync_scan_rstn       (dft_clkdiv_scan_rstn ),
    .rst_n_o                      (rstn_out             )
    );
    
    `ifdef JL_SYNTHESIS
        assign scanout = 1'b0;
    `endif

    always @(posedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            cnt <= 0;
        else if (cnt < ((DIV_N/2)-1))
            cnt <= cnt + 1'b1;
        else
            cnt <= 0;
    end

    always @(posedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out_pre <= 1'b0;
        else if (cnt == ((DIV_N/2)-1))
            clk_out_pre <= ~clk_out_pre;
        else
            clk_out_pre <= clk_out_pre;
    end

    jlsemi_util_clkbuf
    u_dont_touch_clkdiv_out_buf
    (
    .clk_i              (clk_out_pre        ),
    .clk_o              (clk_out            )
    );

endmodule
