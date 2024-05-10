// --------------------------------------------------------------------
// Copyright (c) 2024 by JLSemi Inc.
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
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-05-06    zlguo         1.0         clk_gen
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module clk_gen
(
    //Dft
    input   wire            dft_rstnsync_scan_rstn_ctrl,
    input   wire            dft_rstnsync_scan_rstn,
    input   wire            dft_rtl_icg_en,

    // Clock input from analog, Reset input from digital rst_gen
    input   wire            ANA_CLK200M,
    input   wire            ANA_CLK500M,
    input   wire            rstn, // from digital rst_gen

    // Register config: clock divider and clock phase
    input   wire    [8:0]   rf_pktctrl_rclk_div, // 4,8,10,20,40,50,100,200,400 --> 50M,25M,20M,10M,5M,4M,2M,1M,500K
    input   wire    [8:0]   rf_pktctrl_rclk_phase,

    // Register config: clock gate enable
    input   wire            rf_pktctrl_wclk_en,
    input   wire            rf_pktctrl_rclk_en,
    input   wire            rf_pktctrl_mdio_rclk_en,

    // Clock output
    output  wire            pktctrl_wclk,
    output  wire            pktctrl_rclk,
    output  wire            pktctrl_mdio_rclk,
    output  wire            mdio_clk,
    output  wire            CLK_RD //clock output to iopad for FPGA fifo write clk
);

    wire    pktctrl_wclk_pre;
    wire    divclk_pktctrl_rclk;
    wire    pktctrl_rclk_pre;

    // Pktctrl data write clock
    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_pktctrl_wclk
    (
    .clk_i                      (ANA_CLK500M                ),
    .clk_o                      (pktctrl_wclk_pre           )
    );

    jlsemi_util_clkgate #(
        .RST_SYNC_STAGE (3),
        .SYNC_STEP      (3))
    u_clkgate_to_pktctrl_wclk
    (
    .clk_i                      (pktctrl_wclk_pre           ),
    .clk_en_i                   (rf_pktctrl_wclk_en         ),
    .rstn_i                     (rstn                       ),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rtl_icg_en             (dft_rtl_icg_en             ),
    .clk_o                      (pktctrl_wclk               )
    );

    // Pktctrl data fast-read clock
    jlsemi_util_clkdiv_even_with_cfg #(
        .RST_SYNC_STAGE (3))
    u_even_clkdiv_to_fastread_rclk
    (
    .dft_stuck_at_mode          (dft_stuck_at_mode          ),
    .dft_tpi_clk                (dft_tpi_clk                ),
    .dft_clkdiv_rstn_ctrl       (dft_clkdiv_rstn_ctrl       ),
    .dft_clkdiv_scan_rstn       (dft_clkdiv_scan_rstn       ),
    .dft_scan_en                (dft_scan_en                ),
    `ifdef JL_SYNTHESIS
        .scanin  (1'b0 ), // spyglass disable W240
        .scanout (     ),
    `endif
    .clk_in                     (ANA_CLK200M                ),
    .rstn_in                    (rstn                       ),
    .DIV_N                      (rf_pktctrl_rclk_div        ),
    .clk_out                    (divclk_pktctrl_rclk        )
    );

    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_pktctrl_rclk
    (
    .clk_i                      (divclk_pktctrl_rclk        ),
    .clk_o                      (pktctrl_rclk_pre           )
    );

    jlsemi_util_clkgate #(
        .RST_SYNC_STAGE (3),
        .SYNC_STEP      (3))
    u_clkgate_to_pktctrl_rclk
    (
    .clk_i                      (pktctrl_rclk_pre           ),
    .clk_en_i                   (rf_pktctrl_rclk_en         ),
    .rstn_i                     (rstn                       ),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rtl_icg_en             (dft_rtl_icg_en             ),
    .clk_o                      (pktctrl_rclk               )
    );

    // Pktctrl data mdio-read clock
    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_mdio_rclk
    (
    .clk_i                      (ANA_CLK200M                ),
    .clk_o                      (pktctrl_rclk_pre           )
    );

    jlsemi_util_clkgate #(
        .RST_SYNC_STAGE (3),
        .SYNC_STEP      (3))
    u_clkgate_to_pktctrl_mdio_rclk
    (
    .clk_i                      (pktctrl_rclk_pre           ),
    .clk_en_i                   (rf_pktctrl_mdio_rclk_en    ),
    .rstn_i                     (rstn                       ),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rtl_icg_en             (dft_rtl_icg_en             ),
    .clk_o                      (pktctrl_mdio_rclk          )
    );

    // mdio and regfile clock
    assign mdio_clk = pktctrl_rclk_pre;

    // Output clock to IOPad
    jlsemi_util_clkdiv_even_with_phase #(
        .RST_SYNC_STAGE (3))
    u_even_clkdiv_to_CLKRD_with_phase
    (
    .dft_stuck_at_mode          (dft_stuck_at_mode          ),
    .dft_tpi_clk                (dft_tpi_clk                ),
    .dft_clkdiv_rstn_ctrl       (dft_clkdiv_rstn_ctrl       ),
    .dft_clkdiv_scan_rstn       (dft_clkdiv_scan_rstn       ),
    .dft_scan_en                (dft_scan_en                ),
    `ifdef JL_SYNTHESIS
        .scanin  (1'b0 ), // spyglass disable W240
        .scanout (     ),
    `endif
    .clk_in                     (ANA_CLK200M                ),
    .rstn_in                    (rstn                       ),
    .DIV_N                      (rf_pktctrl_rclk_div        ),
    .DIV_PHASE_CNT              (rf_pktctrl_rclk_phase      ),
    .clk_out                    (CLK_RD                     )
    );

endmodule
