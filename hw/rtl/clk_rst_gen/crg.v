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
    //Dft
    input   wire            dft_rstnsync_scan_rstn_ctrl,
    input   wire            dft_rstnsync_scan_rstn,
    input   wire            dft_rtl_icg_en,
    input   wire            dft_stuck_at_mode,
    input   wire            dft_tpi_clk,
    input   wire            dft_clkdiv_rstn_ctrl,
    input   wire            dft_clkdiv_scan_rstn,
    input   wire            dft_scan_en,

    // Clock Gen
    // Clock input from analog
    input   wire            ANA_CLK200M,
    input   wire            ANA_CLK500M,

    input   wire            rf_pktctrl_clk_en,
    input   wire            rf_pktctrl_sw_rstn,
    input   wire            rf_regfile_sw_rstn,

    // Clock output
    output  wire            pktctrl_clk,
    output  wire            clk_200m,

    // Reset Gen
    // Clock input from clk_gen, Reset input from digital iopad
    input   wire            RSTN,

    // Reset output
    output  wire            pktctrl_rstn,
    output  wire            rstn_200m,
    output  wire            regfile_rstn
);

    wire rstn;

    clk_gen
    u_clk_gen
    (
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .dft_rtl_icg_en             (dft_rtl_icg_en             ),
    .dft_stuck_at_mode          (dft_stuck_at_mode          ),
    .dft_tpi_clk                (dft_tpi_clk                ),
    .dft_clkdiv_rstn_ctrl       (dft_clkdiv_rstn_ctrl       ),
    .dft_clkdiv_scan_rstn       (dft_clkdiv_scan_rstn       ),
    .dft_scan_en                (dft_scan_en                ),
    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_CLK500M                (ANA_CLK500M                ),
    .rstn                       (rstn                       ),
    .rf_pktctrl_clk_en          (rf_pktctrl_clk_en          ),
    .pktctrl_clk                (pktctrl_clk                ),
    .clk_200m                   (clk_200m                   )
    );

    rst_gen
    u_rst_gen
    (
    .RSTN                       (RSTN                       ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .pktctrl_clk                (pktctrl_clk                ),
    .clk_200m                   (clk_200m                   ),
    .rf_pktctrl_sw_rstn         (rf_pktctrl_sw_rstn         ),
    .rf_regfile_sw_rstn         (rf_regfile_sw_rstn         ),
    .rstn                       (rstn                       ),
    .pktctrl_rstn               (pktctrl_rstn               ),
    .rstn_200m                  (rstn_200m                  ),
    .regfile_rstn               (regfile_rstn               )
    );

endmodule
