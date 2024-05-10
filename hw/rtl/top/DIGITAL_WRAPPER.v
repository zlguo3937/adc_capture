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
//  2024-05-06    zlguo         1.0         DIGITAL_WRAPPER
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module DIGITAL_WRAPPER
(
    input   wire    ANA_CLK200M,
    input   wire    ANA_CLK500M,

    inout   wire    PAD1_RSTN,

    inout   wire    PAD2_CLK_RD
);
    
    // crg
    wire    [8:0]   rf_pktctrl_rclk_div;
    wire    [8:0]   rf_pktctrl_rclk_phase;
    wire            rf_pktctrl_wclk_en;
    wire            rf_pktctrl_rclk_en;
    wire            rf_pktctrl_mdio_rclk_en;
    wire            pktctrl_wclk;
    wire            pktctrl_rclk;
    wire            pktctrl_mdio_rclk;
    wire            mdio_clk;
    wire            rf_pktctrl_sw_wrstn;
    wire            rf_pktctrl_sw_rrstn;
    wire            rf_pktctrl_mdio_sw_rrstn;
    wire            rf_mdio_sw_rstn;
    wire            pktctrl_wrstn;
    wire            pktctrl_rrstn;
    wire            pktctrl_mdio_rrstn;
    wire            mdio_rstn;

    // iopad
    wire            rf_RSTN_OEN;
    wire            rf_RSTN_REN;

    // crg
    crg
    u_crg
    (
    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_CLK500M                (ANA_CLK500M                ),
    .rf_pktctrl_rclk_div        (rf_pktctrl_rclk_div        ),
    .rf_pktctrl_rclk_phase      (rf_pktctrl_rclk_phase      ),
    .rf_pktctrl_wclk_en         (rf_pktctrl_wclk_en         ),
    .rf_pktctrl_rclk_en         (rf_pktctrl_rclk_en         ),
    .rf_pktctrl_mdio_rclk_en    (rf_pktctrl_mdio_rclk_en    ),
    .pktctrl_wclk               (pktctrl_wclk               ),
    .pktctrl_rclk               (pktctrl_rclk               ),
    .pktctrl_mdio_rclk          (pktctrl_mdio_rclk          ),
    .mdio_clk                   (mdio_clk                   ),
    .CLK_RD                     (CLK_RD                     ),
    .RSTN                       (RSTN                       ),
    .rf_pktctrl_sw_wrstn        (rf_pktctrl_sw_wrstn        ),
    .rf_pktctrl_sw_rrstn        (rf_pktctrl_sw_rrstn        ),
    .rf_pktctrl_mdio_sw_rrstn   (rf_pktctrl_mdio_sw_rrstn   ),
    .rf_mdio_sw_rstn            (rf_mdio_sw_rstn            ),
    .pktctrl_wrstn              (pktctrl_wrstn              ),
    .pktctrl_rrstn              (pktctrl_rrstn              ),
    .pktctrl_mdio_rrstn         (pktctrl_mdio_rrstn         ),
    .mdio_rstn                  (mdio_rstn                  )
    );

    // iopad
    iopad_top
    u_iopad_top
    (
    .PAD1_RSTN                  (PAD1_RSTN                  ),
    .PAD2_CLK_RD                (PAD2_CLK_RD                ),
    .rf_RSTN_OEN                (rf_RSTN_OEN                ),
    .rf_RSTN_REN                (rf_RSTN_REN                )
    );

    pktctrl_top
    u_pktctrl_top
    (

    );

    ctrl_sys
    u_ctrl_sys
    (

    );

endmodule
