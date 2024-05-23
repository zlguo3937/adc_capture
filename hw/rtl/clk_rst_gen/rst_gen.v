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
//  2024-05-06    zlguo         1.0         rst_gen
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module rst_gen
(
    input   wire            RSTN,

    // Dft
    input   wire            dft_rstnsync_scan_rstn_ctrl,
    input   wire            dft_rstnsync_scan_rstn,

    // Clock input from clk_gen
    input   wire            clk_200m,
    input   wire            pktctrl_clk,

    // Clock input from ana
    input   wire            ANA_ADC_CLK500M,
    input   wire            ANA_ADC48_CLK500M,

    // Register sw_reset
    input   wire            rf_pktctrl_sw_rstn,
    input   wire            rf_regfile_sw_rstn,

    // Reset output
    output  wire            rstn, //TODO
    output  wire            pktctrl_rstn,
    output  wire            rstn_200m,
    output  wire            adc96_rstn,
    output  wire            adc48_rstn,
    output  wire            regfile_rstn
);

    wire    pktctrl_wrstn_in;
    wire    pktctrl_rrstn_in;
    wire    pktctrl_mdio_rrstn_in;
    wire    mdio_rstn_in;

    // Reset Debounce
    //TODO
    assign  rstn = RSTN;

    assign  pktctrl_rstn_in = rstn & rf_pktctrl_sw_rstn;
    assign  regfile_rstn_in = rstn & rf_regfile_sw_rstn;

    // Reset sync for pktctrl_rstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_pktctrl_rstn
    (
    .rst_n_i                      (pktctrl_rstn_in              ),
    .clk_i                        (pktctrl_clk                  ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (pktctrl_rstn                 )
    );

    // Reset sync for mdio_rstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_rstn_200m
    (
    .rst_n_i                      (rstn                         ),
    .clk_i                        (clk_200m                     ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (rstn_200m                    )
    );

    // Reset sync for regfile_rstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_regfile_rstn
    (
    .rst_n_i                      (regfile_rstn_in              ),
    .clk_i                        (clk_200m                     ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (regfile_rstn                 )
    );

    // Reset sync for adc96
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_adc96
    (
    .rst_n_i                      (rstn                         ),
    .clk_i                        (ANA_ADC_CLK500M              ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (adc96_rstn                   )
    );

    // Reset sync for adc96
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_adc48
    (
    .rst_n_i                      (rstn                         ),
    .clk_i                        (ANA_ADC48_CLK500M            ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (adc48_rstn                   )
    );

endmodule
