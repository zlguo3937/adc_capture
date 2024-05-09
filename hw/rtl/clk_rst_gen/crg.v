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
//  2024-05-06    zlguo         1.0         crg
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module crg
(
    // Clock Gen
    // Clock input from analog
    input   wire            ANA_CLK200M,
    input   wire            ANA_CLK500M,

    // Register config: clock divider and clock phase
    input   wire    [8:0]   rf_pktctrl_rclk_div,
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
    output  wire            CLK_RD,

    // Reset Gen
    // Clock input from clk_gen, Reset input from digital iopad
    input   wire            RSTN,

    // Register config: software reset
    input   wire            pktctrl_wclk_sw_rstn,
    input   wire            pktctrl_rclk_sw_rstn,
    input   wire            pktctrl_mdio_rclk_sw_rstn,
    input   wire            mdio_rclk_sw_rstn,

    // Reset output
    output  wire            pktctrl_wrstn,
    output  wire            pktctrl_rrstn,
    output  wire            pktctrl_mdio_rrstn,
    output  wire            mdio_rstn
);

    wire rstn;

    clk_gen
    u_clk_gen
    (
    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_CLK500M                (ANA_CLK500M                ),
    .rstn                       (rstn                       ),
    .rf_pktctrl_rclk_div        (rf_pktctrl_rclk_div        ),
    .rf_pktctrl_rclk_phase      (rf_pktctrl_rclk_phase      ),
    .rf_pktctrl_wclk_en         (rf_pktctrl_wclk_en         ),
    .rf_pktctrl_rclk_en         (rf_pktctrl_rclk_en         ),
    .rf_pktctrl_mdio_rclk_en    (rf_pktctrl_mdio_rclk_en    ),
    .pktctrl_wclk               (pktctrl_wclk               ),
    .pktctrl_rclk               (pktctrl_rclk               ),
    .pktctrl_mdio_rclk          (pktctrl_mdio_rclk          ),
    .mdio_clk                   (mdio_clk                   ),
    .CLK_RD                     (CLK_RD                     )
    );

endmodule
