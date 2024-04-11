`timescale 1ns/1ns
module jlsemi_util_clkdiv_odd_tb;

    reg   dft_stuck_at_mode;
    reg   dft_tpi_clk;
    reg   dft_clkdiv_rstn_ctrl;
    reg   dft_clkdiv_scan_rstn;
    reg   dft_scan_en;
    reg   clk_in;
    reg   rstn_in;
    reg   [1:0]rf_pktctrl_rclk_phase;
    wire  clk_out;
    wire  clk_out_phase;

    jlsemi_util_clkdiv_odd
    u_jlsemi_util_clkdiv_odd
    (
    .dft_stuck_at_mode    (dft_stuck_at_mode),
    .dft_tpi_clk          (dft_tpi_clk),
    .dft_clkdiv_rstn_ctrl (dft_clkdiv_rstn_ctrl),
    .dft_clkdiv_scan_rstn (dft_clkdiv_scan_rstn),
    .dft_scan_en          (dft_scan_en),
    .clk_in               (clk_in),
    .rf_pktctrl_rclk_phase(rf_pktctrl_rclk_phase),
    .rstn_in              (rstn_in),
    .clk_out              (clk_out),
    .clk_out_phase        (clk_out_phase)
    );

    initial
    begin
        `ifdef VPD_ON
            $vcdpluson();
        `endif
        $fsdbDumpfile("jlsemi_util_clkdiv_odd_tb.fsdb");
        $fsdbDumpvars("+all");
    end

    initial begin
        clk_in= 0;
        forever
        begin
            #1 clk_in = ~clk_in;
        end
    end

    // Apply stimulus
    initial
    begin
        rstn_in = 0;
        @ (negedge clk_in)
        rstn_in = 0 ;
        repeat(1) @ (negedge clk_in);
        rstn_in = 1 ;
    end

    initial
    begin
        dft_stuck_at_mode = 1'b0;
        dft_tpi_clk = 1'b0;
        dft_clkdiv_rstn_ctrl = 1'b0;
        dft_clkdiv_scan_rstn = 1'b0;
        dft_scan_en = 1'b0;
        rf_pktctrl_rclk_phase = 2'b01;
    end

    initial begin
        #500;
        $finish;
    end

endmodule
