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
`timescale 1ns/1ns
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
    input   wire            dft_test_clk_en,

    // Clock Gen
    // Clock input from analog
    input   wire            ANA_CLK200M,
    input   wire            ANA_ADC_CLK500M,
    input   wire            ANA_ADC48_CLK500M,

    input   wire            rf_pktctrl_clk_en,
    input   wire            rf_pktctrl_sw_rstn,

    // Whitch 500M clock be selected
    input   wire            rf_96path_en,

    // Clock output
    output  wire            pktctrl_clk,
    output  wire            clk_200m,

    // Reset Gen
    // Clock input from clk_gen, Reset input from digital iopad
    input   wire            RSTN,

    // Reset output
    output  wire            pktctrl_rstn,
    output  wire            rstn_200m,
    output  wire            adc96_rstn,
    output  wire            adc48_rstn
);

    wire rstn;

`ifdef FPGA
    assign pktctrl_clk  = ANA_ADC_CLK500M;
    assign clk_200m     = ANA_CLK200M;

	// Reset sync for pktctrl_rstn
    async_reset_low_sync
    u_asyncrstn_sync_to_pktctrl_rstn
    (
    .rst_n_i                    (RSTN            			),
    .clk_i                      (pktctrl_clk                ),
    .rst_n_o                    (pktctrl_rstn               )
    );

	// Reset sync for rstn_200m
    async_reset_low_sync
    u_asyncrstn_sync_to_rstn_200m
    (
    .rst_n_i                    (RSTN            			),
    .clk_i                      (clk_200m                	),
    .rst_n_o                    (rstn_200m               	)
    );

	// Reset sync for adc96_rstn
    async_reset_low_sync
    u_asyncrstn_sync_to_adc96_rstn
    (
    .rst_n_i                    (RSTN            			),
    .clk_i                      (pktctrl_clk                ),
    .rst_n_o                    (adc96_rstn               	)
    );

	// Reset sync for adc48_rstn
    async_reset_low_sync
    u_asyncrstn_sync_to_adc48_rstn
    (
    .rst_n_i                    (RSTN            			),
    .clk_i                      (pktctrl_clk                ),
    .rst_n_o                    (adc48_rstn               	)
    );
`else
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
    .dft_test_clk_en            (dft_test_clk_en            ),
    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_ADC_CLK500M            (ANA_ADC_CLK500M            ),
    .ANA_ADC48_CLK500M          (ANA_ADC48_CLK500M          ),
    .rstn                       (rstn                       ),
    .rf_pktctrl_clk_en          (rf_pktctrl_clk_en          ),
    .rf_96path_en               (rf_96path_en               ),
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
    .rstn                       (rstn                       ),
    .pktctrl_rstn               (pktctrl_rstn               ),
    .rstn_200m                  (rstn_200m                  ),
    .ANA_ADC_CLK500M            (ANA_ADC_CLK500M            ),
    .ANA_ADC48_CLK500M          (ANA_ADC48_CLK500M          ),
    .adc96_rstn                 (adc96_rstn                 ),
    .adc48_rstn                 (adc48_rstn                 )
    );
`endif

endmodule
