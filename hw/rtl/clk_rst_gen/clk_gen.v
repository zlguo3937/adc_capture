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
`timescale 1ns/1ns
module clk_gen
(
    //Dft
    input   wire            dft_rstnsync_scan_rstn_ctrl,
    input   wire            dft_rstnsync_scan_rstn,
    input   wire            dft_rtl_icg_en,
    input   wire            dft_stuck_at_mode,
    input   wire            dft_tpi_clk,
    input   wire            dft_clkdiv_rstn_ctrl,
    input   wire            dft_clkdiv_scan_rstn,
    input   wire            dft_scan_en,
    input   wire            dft_test_clk_en,

    // Clock input from analog, Reset input from digital rst_gen
    input   wire            ANA_CLK200M,
    input   wire            ANA_ADC_CLK500M,
    input   wire            ANA_ADC48_CLK500M,
    input   wire            rstn, // from digital rst_gen

    // Whitch 500M clock be selected
    input   wire            rf_96path_en,

    // Register config: clock gate enable
    input   wire            rf_pktctrl_clk_en,

    // Clock output
    output  wire            pktctrl_clk,
    output  wire            clk_200m
);

    wire    pktctrl_clk_occ;
    wire    clk_200m_occ;
    wire    ANA_CLK500M;

    // Pktctrl clock
    jlsemi_util_clkmux_sel1
    u_clkmux_to_CLK500M
    (
    .clk0_i                     (ANA_ADC48_CLK500M          ),
    .clk1_i                     (ANA_ADC_CLK500M            ),
    .sel_i                      (rf_96path_en               ),
    .dft_test_clk_en            (dft_test_clk_en            ),
    .clk_o                      (ANA_CLK500M                )
    );

    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_pktctrl_wclk
    (
    .clk_i                      (ANA_CLK500M                ),
    .clk_o                      (pktctrl_clk_occ            )
    );

    jlsemi_util_clkgate #(
        .RST_SYNC_STAGE (3),
        .SYNC_STEP      (3))
    u_clkgate_to_pktctrl_wclk
    (
    .clk_i                      (pktctrl_clk_occ            ),
    .clk_en_i                   (rf_pktctrl_clk_en          ),
    .rstn_i                     (rstn                       ),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rtl_icg_en             (dft_rtl_icg_en             ),
    .clk_o                      (pktctrl_clk                )
    );

    // mdio and regfile clock
    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_clk_200m
    (
    .clk_i                      (ANA_CLK200M                ),
    .clk_o                      (clk_200m_occ               )
    );

    assign clk_200m = clk_200m_occ;

endmodule
