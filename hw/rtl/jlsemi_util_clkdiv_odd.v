`timescale 1ns/1ns
module jlsemi_util_clkdiv_odd
#(
    parameter DIV_N  = 25
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
    input   wire [1:0]  rf_pktctrl_rclk_phase,
    output  wire        clk_out_phase,
    output  wire        clk_out
);

    reg [(DIV_N-1)/2:0] cnt;
    reg                 clk_out1;
    reg                 clk_out2;
    wire                clk_out_pre;
    wire                clk_in_pre;
    wire                rstn_out;
    
    //function clock and scan clock mux
    jlsemi_util_clkmux_sel1
    u_dont_touch_clkdiv_clkmux(
    .clk0_i           (clk_in           ),
    .clk1_i           (dft_tpi_clk      ),
    .sel_i            (1'b0             ),
    .dft_test_clk_en  (dft_stuck_at_mode),
    .clk_o            (clk_in_pre       )
    );
    
    // dft_scan_en && dft_stuck_at_mode
    jlsemi_util_and_cell
    u_dont_touch_clkdiv_scanen_stuckatmode_and(
    .a_i  (dft_scan_en      ),
    .b_i  (dft_stuck_at_mode),
    .z_o  (                 )// spyglass disable W287b
    );
    
    // reset sync for div counter register
    jlsemi_util_async_reset_low_sync
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
        else if (cnt < ((DIV_N-1)/2 << 1))
            cnt <= cnt + 1'b1;
        else
            cnt <= 0;
    end

    always @(posedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out1 <= 1'b0;
        else if (cnt == 0)
            clk_out1 <= ~clk_out1;
        else
            clk_out1 <= clk_out1;
    end
    
    always @(negedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out2 <= 1'b0;
        else if (cnt == ((DIV_N+1)/2))
            clk_out2 <= ~clk_out2;
        else
            clk_out2 <= clk_out2;
    end

    reg clk_out3,clk_out4;

    wire  [(DIV_N-1)/2:0] cfg_phase_cnt;
    assign cfg_phase_cnt = rf_pktctrl_rclk_phase == 2'b00 ? 0 :
                            rf_pktctrl_rclk_phase == 2'b01 ? 4 :
                            rf_pktctrl_rclk_phase == 2'b10 ? 8 : 0;

    always @(posedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out3 <= 1'b0;
        else if (cnt == cfg_phase_cnt)
            clk_out3 <= ~clk_out3;
        else
            clk_out3 <= clk_out3;
    end

    always @(negedge clk_in_pre or negedge rstn_out)
    begin
        if(~rstn_out)
            clk_out4 <= 1'b0;
        else if (cnt == cfg_phase_cnt + 13)
            clk_out4 <= ~clk_out4;
        else
            clk_out4 <= clk_out4;
    end

    assign clk_out = clk_out1 ^ clk_out2;
    assign clk_out_phase = (rf_pktctrl_rclk_phase == 2'b11) ? (~(clk_out1 ^ clk_out2)) : (clk_out3 ^ clk_out4);

    endmodule
