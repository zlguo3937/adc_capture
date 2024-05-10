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
module rst_gen
(
    input   wire            RSTN,

    // Dft
    input   wire            dft_rstnsync_scan_rstn_ctrl,
    input   wire            dft_rstnsync_scan_rstn,

    // Clock input from clk_gen
    input   wire            pktctrl_wclk,
    input   wire            pktctrl_rclk,
    input   wire            pktctrl_mdio_rclk,
    input   wire            mdio_clk,
    

    // Register sw_reset
    input   wire            rf_pktctrl_sw_wrstn,
    input   wire            rf_pktctrl_sw_rrstn,
    input   wire            rf_pktctrl_mdio_sw_rrstn,
    input   wire            rf_mdio_sw_rstn,

    // Reset output
    output  wire            rstn, //TODO
    output  wire            pktctrl_wrstn,
    output  wire            pktctrl_rrstn,
    output  wire            pktctrl_mdio_rrstn,
    output  wire            mdio_rstn
);

    wire    pktctrl_wrstn_in;
    wire    pktctrl_rrstn_in;
    wire    pktctrl_mdio_rrstn_in;
    wire    mdio_rstn_in;

    // Reset Debounce
    //TODO

    assign  pktctrl_wrstn_in        = rstn & rf_pktctrl_sw_wrstn;
    assign  pktctrl_rrstn_in        = rstn & rf_pktctrl_sw_rrstn;
    assign  pktctrl_mdio_rrstn_in   = rstn & rf_pktctrl_mdio_sw_rrstn;
    assign  mdio_rstn_in            = rstn & rf_mdio_sw_rstn;

    // Reset sync for pktctrl_wrstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_pktctrl_wrstn
    (
    .rst_n_i                      (pktctrl_wrstn_in             ),
    .clk_i                        (pktctrl_wclk                 ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (pktctrl_wrstn                )
    );

    // Reset sync for pktctrl_rrstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_pktctrl_rrstn
    (
    .rst_n_i                      (pktctrl_rrstn_in             ),
    .clk_i                        (pktctrl_wclk                 ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (pktctrl_rrstn                )
    );

    // Reset sync for pktctrl_mdio_rrstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_pktctrl_mdio_rrstn
    (
    .rst_n_i                      (pktctrl_mdio_rrstn_in        ),
    .clk_i                        (pktctrl_wclk                 ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (pktctrl_mdio_rrstn           )
    );

    // Reset sync for mdio_rstn
    jlsemi_util_async_reset_low_sync #(
        .RST_SYNC_STAGE (3))
    u_dont_touch_rst_sync_to_mdio_rstn
    (
    .rst_n_i                      (mdio_rstn_in                 ),
    .clk_i                        (pktctrl_wclk                 ),
    .dft_rstnsync_scan_rstn_ctrl  (dft_rstnsync_scan_rstn_ctrl  ),
    .dft_rstnsync_scan_rstn       (dft_rstnsync_scan_rstn       ),
    .rst_n_o                      (mdio_rstn                    )
    );

endmodule
