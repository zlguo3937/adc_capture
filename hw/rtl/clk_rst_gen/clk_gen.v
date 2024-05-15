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
    input   wire            dft_stuck_at_mode,
    input   wire            dft_tpi_clk,
    input   wire            dft_clkdiv_rstn_ctrl,
    input   wire            dft_clkdiv_scan_rstn,
    input   wire            dft_scan_en,

    // Clock input from analog, Reset input from digital rst_gen
    input   wire            ANA_CLK200M,
    input   wire            ANA_CLK500M,
    input   wire            rstn, // from digital rst_gen

    // Register config: clock divider and clock phase
    input   wire    [8:0]   rf_pktctrl_clk_div, // 4,8,10,20,40,50,100,200,400 --> 50M,25M,20M,10M,5M,4M,2M,1M,500K
    input   wire    [8:0]   rf_pktctrl_clk_phase,

    // Register config: clock gate enable
    input   wire            rf_pktctrl_clk_en,

    // Clock output
    output  wire            pktctrl_clk,
    output  wire            clk_200m,
    output  wire            CLK_RD, //clock output to iopad for FPGA fifo write clk
    output  wire            DATA_RD_EN // CLK_RD pulse at pktctrl_clk
);

    wire    pktctrl_clk_occ;
    wire    pktctrl_clk_pre;
    wire    clk_200m_occ;
    wire    clk_200m_pre;

    // Pktctrl data write clock
    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_pktctrl_wclk
    (
    .clk_i                      (ANA_CLK500M                ),
    .clk_o                      (pktctrl_clk_occ            )
    );

    jlsemi_util_clkbuf
    u_dont_touch_buf_pktctrl_clk
    (
    .clk_i                      (pktctrl_clk_occ            ),
    .clk_o                      (pktctrl_clk_pre            )
    );

    jlsemi_util_clkgate #(
        .RST_SYNC_STAGE (3),
        .SYNC_STEP      (3))
    u_clkgate_to_pktctrl_wclk
    (
    .clk_i                      (pktctrl_clk_pre            ),
    .clk_en_i                   (rf_pktctrl_clk_en          ),
    .rstn_i                     (rstn                       ),
    .dft_rstnsync_scan_rstn     (dft_rstnsync_scan_rstn     ),
    .dft_rstnsync_scan_rstn_ctrl(dft_rstnsync_scan_rstn_ctrl),
    .dft_rtl_icg_en             (dft_rtl_icg_en             ),
    .clk_o                      (pktctrl_clk                )
    );

    // Output clock to IOPad and DATA_RD_EN to Pktctrl data fast-read en
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
    .clk_in                     (ANA_CLK500M                ),
    .rstn_in                    (rstn                       ),
    .DIV_N                      (rf_pktctrl_clk_div         ),
    .DIV_PHASE_CNT              (rf_pktctrl_clk_phase       ),
    .clk_out                    (CLK_RD                     ),
    .DATA_RD_EN                 (DATA_RD_EN                 )
    );

    // mdio and regfile clock
    jlsemi_util_clkbuf
    u_dont_touch_occ_anchor_buf_clk_200m
    (
    .clk_i                      (ANA_CLK200M                ),
    .clk_o                      (clk_200m_occ               )
    );

    jlsemi_util_clkbuf
    u_dont_touch_buf_clk_200m
    (
    .clk_i                      (clk_200m_occ               ),
    .clk_o                      (clk_200m_pre               )
    );

    assign clk_200m = clk_200m_pre;

endmodule
