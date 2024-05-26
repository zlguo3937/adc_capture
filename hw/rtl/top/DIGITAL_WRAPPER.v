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
`timescale 1ns/1ns
module DIGITAL_WRAPPER
(
    input   wire            ANA_CLK200M,
    input   wire            ANA_ADC_CLK500M,
    input   wire            ANA_ADC48_CLK500M,

    output  wire            adc96_rstn,
    output  wire            adc48_rstn,

    input   wire    [35:0]  ANA_ADC_DATA_0,
    input   wire    [35:0]  ANA_ADC_DATA_1,
    input   wire    [35:0]  ANA_ADC_DATA_2,
    input   wire    [35:0]  ANA_ADC_DATA_3,
    input   wire    [35:0]  ANA_ADC_DATA_4,
    input   wire    [35:0]  ANA_ADC_DATA_5,
    input   wire    [35:0]  ANA_ADC_DATA_6,
    input   wire    [35:0]  ANA_ADC_DATA_7,
    input   wire    [35:0]  ANA_ADC_DATA_8,
    input   wire    [35:0]  ANA_ADC_DATA_9,
    input   wire    [35:0]  ANA_ADC_DATA_10,
    input   wire    [35:0]  ANA_ADC_DATA_11,
    input   wire    [35:0]  ANA_ADC_DATA_12,
    input   wire    [35:0]  ANA_ADC_DATA_13,
    input   wire    [35:0]  ANA_ADC_DATA_14,
    input   wire    [35:0]  ANA_ADC_DATA_15,
    input   wire    [35:0]  ANA_ADC_DATA_16,
    input   wire    [35:0]  ANA_ADC_DATA_17,
    input   wire    [35:0]  ANA_ADC_DATA_18,
    input   wire    [35:0]  ANA_ADC_DATA_19,
    input   wire    [35:0]  ANA_ADC_DATA_20,
    input   wire    [35:0]  ANA_ADC_DATA_21,
    input   wire    [35:0]  ANA_ADC_DATA_22,
    input   wire    [35:0]  ANA_ADC_DATA_23,

    input   wire    [35:0]  ANA_ADC48_DATA_0,
    input   wire    [35:0]  ANA_ADC48_DATA_1,
    input   wire    [35:0]  ANA_ADC48_DATA_2,
    input   wire    [35:0]  ANA_ADC48_DATA_3,
    input   wire    [35:0]  ANA_ADC48_DATA_4,
    input   wire    [35:0]  ANA_ADC48_DATA_5,
    input   wire    [35:0]  ANA_ADC48_DATA_6,
    input   wire    [35:0]  ANA_ADC48_DATA_7,
    input   wire    [35:0]  ANA_ADC48_DATA_8,
    input   wire    [35:0]  ANA_ADC48_DATA_9,
    input   wire    [35:0]  ANA_ADC48_DATA_10,
    input   wire    [35:0]  ANA_ADC48_DATA_11,

    inout   wire            PAD1_ADC_DATA_1,
    inout   wire            PAD2_ADC_DATA_2,
    inout   wire            PAD3_ADC_DATA_3,
    inout   wire            PAD4_ADC_DATA_4,
    inout   wire            PAD5_ADC_DATA_5,
    inout   wire            PAD6_ADC_DATA_6,
    inout   wire            PAD7_ADC_DATA_7,
    inout   wire            PAD8_ADC_DATA_8,
    inout   wire            PAD9_ADC_DATA_9,
    inout   wire            PAD10_ADC_DATA_10,
    inout   wire            PAD11_ADC_DATA_11,
    inout   wire            PAD12_ADC_DATA_12,
    inout   wire            PAD13_ADC_DATA_13,
    inout   wire            PAD14_ADC_DATA_14,
    inout   wire            PAD15_ADC_DATA_15,
    inout   wire            PAD16_ADC_DATA_16,
    inout   wire            PAD17_ADC_DATA_17,
    inout   wire            PAD18_ADC_DATA_18,
    inout   wire            PAD19_ADC_DATA_VALID,
    inout   wire            PAD20_RSTN,
    inout   wire            PAD21_CLK_RD,
    inout   wire            PAD22_MDC,
    inout   wire            PAD23_MDIO
);
    
    // crg
    wire    [8:0]   rf_pktctrl_gap;
    wire    [8:0]   rf_pktctrl_phase;
    wire            rf_pktctrl_clk_en;
    wire            rf_pktctrl_sw_rstn;
    wire            pktctrl_clk;
    wire            pktctrl_rstn;

    wire            clk_200m;
    wire            rstn_200m;

    wire            CLK_RD;
    wire            DATA_RD_EN; 
    wire            RSTN; 

    wire    [17:0]  ADC_DATA;
    wire            ADC_DATA_VALID;
    wire            MDIO;
    wire            MDC;
    wire            mdio_out;
    wire            mdio_oen;

    wire            rf_self_test_mode;

    wire            rf_capture_mode;
    wire            rf_capture_start;
    wire            rf_capture_again;

    wire            rf_96path_en;
    wire    [1:0]   rf_pkt_data_length;
    wire    [15:0]  rf_pkt_idle_length;

    wire    [6:0]   rf_mdio_data_sel;
    wire    [14:0]  rf_mdio_memory_addr;
    wire    [8:0]   rf_mdio_pkt_data;

    // crg
    crg
    u_crg
    (
    .dft_rstnsync_scan_rstn_ctrl(1'b0                       ),
    .dft_rstnsync_scan_rstn     (1'b0                       ),
    .dft_rtl_icg_en             (1'b0                       ),
    .dft_stuck_at_mode          (1'b0                       ),
    .dft_tpi_clk                (1'b0                       ),
    .dft_clkdiv_rstn_ctrl       (1'b0                       ),
    .dft_clkdiv_scan_rstn       (1'b0                       ),
    .dft_scan_en                (1'b0                       ),
    .dft_test_clk_en            (1'b0                       ),
    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_ADC_CLK500M            (ANA_ADC_CLK500M            ),
    .ANA_ADC48_CLK500M          (ANA_ADC48_CLK500M          ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_pktctrl_clk_en          (rf_pktctrl_clk_en          ),
    .rf_pktctrl_sw_rstn         (rf_pktctrl_sw_rstn         ),
    .pktctrl_clk                (pktctrl_clk                ),
    .pktctrl_rstn               (pktctrl_rstn               ),
    .clk_200m                   (clk_200m                   ),
    .rstn_200m                  (rstn_200m                  ),
    .adc96_rstn                 (adc96_rstn                 ),
    .adc48_rstn                 (adc48_rstn                 ),
    .RSTN                       (RSTN                       )
    );

    // iopad
    iopad_top
    u_iopad_top
    (
    .ADC_DATA                   (ADC_DATA                   ),
    .ADC_DATA_VALID             (ADC_DATA_VALID             ),
    .CLK_RD                     (CLK_RD                     ),
    .MDIO_I                     (mdio_out                   ),
    .mdio_oen                   (mdio_oen                   ),
    .RSTN                       (RSTN                       ),
    .MDC                        (MDC                        ),
    .MDIO                       (MDIO                       ),
    .PAD1_ADC_DATA_1            (PAD1_ADC_DATA_1            ),
    .PAD2_ADC_DATA_2            (PAD2_ADC_DATA_2            ),
    .PAD3_ADC_DATA_3            (PAD3_ADC_DATA_3            ),
    .PAD4_ADC_DATA_4            (PAD4_ADC_DATA_4            ),
    .PAD5_ADC_DATA_5            (PAD5_ADC_DATA_5            ),
    .PAD6_ADC_DATA_6            (PAD6_ADC_DATA_6            ),
    .PAD7_ADC_DATA_7            (PAD7_ADC_DATA_7            ),
    .PAD8_ADC_DATA_8            (PAD8_ADC_DATA_8            ),
    .PAD9_ADC_DATA_9            (PAD9_ADC_DATA_9            ),
    .PAD10_ADC_DATA_10          (PAD10_ADC_DATA_10          ),
    .PAD11_ADC_DATA_11          (PAD11_ADC_DATA_11          ),
    .PAD12_ADC_DATA_12          (PAD12_ADC_DATA_12          ),
    .PAD13_ADC_DATA_13          (PAD13_ADC_DATA_13          ),
    .PAD14_ADC_DATA_14          (PAD14_ADC_DATA_14          ),
    .PAD15_ADC_DATA_15          (PAD15_ADC_DATA_15          ),
    .PAD16_ADC_DATA_16          (PAD16_ADC_DATA_16          ),
    .PAD17_ADC_DATA_17          (PAD17_ADC_DATA_17          ),
    .PAD18_ADC_DATA_18          (PAD18_ADC_DATA_18          ),
    .PAD19_ADC_DATA_VALID       (PAD19_ADC_DATA_VALID       ),
    .PAD20_RSTN                 (PAD20_RSTN                 ),
    .PAD21_CLK_RD               (PAD21_CLK_RD               ),
    .PAD22_MDC                  (PAD22_MDC                  ),
    .PAD23_MDIO                 (PAD23_MDIO                 )
    );

    pktctrl_top
    u_pktctrl_top
    (
    .clk_200m                   (clk_200m                   ),
    .pktctrl_clk                (pktctrl_clk                ),
    .rstn_200m                  (rstn_200m                  ),
    .pktctrl_rstn               (pktctrl_rstn               ),
    .rf_self_test_mode          (rf_self_test_mode          ),
    .rf_capture_mode            (rf_capture_mode            ),
    .rf_capture_start           (rf_capture_start           ),
    .rf_capture_again           (rf_capture_again           ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_pkt_data_length         (rf_pkt_data_length         ),
    .rf_pkt_idle_length         (rf_pkt_idle_length         ),
    .rf_pktctrl_gap             (rf_pktctrl_gap             ),
    .rf_pktctrl_phase           (rf_pktctrl_phase           ),
    .rf_mdio_data_sel           (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr        (rf_mdio_memory_addr        ),
    .rf_mdio_pkt_data           (rf_mdio_pkt_data           ),
    .ANA_ADC_DATA_0             (ANA_ADC_DATA_0             ),
    .ANA_ADC_DATA_1             (ANA_ADC_DATA_1             ),
    .ANA_ADC_DATA_2             (ANA_ADC_DATA_2             ),
    .ANA_ADC_DATA_3             (ANA_ADC_DATA_3             ),
    .ANA_ADC_DATA_4             (ANA_ADC_DATA_4             ),
    .ANA_ADC_DATA_5             (ANA_ADC_DATA_5             ),
    .ANA_ADC_DATA_6             (ANA_ADC_DATA_6             ),
    .ANA_ADC_DATA_7             (ANA_ADC_DATA_7             ),
    .ANA_ADC_DATA_8             (ANA_ADC_DATA_8             ),
    .ANA_ADC_DATA_9             (ANA_ADC_DATA_9             ),
    .ANA_ADC_DATA_10            (ANA_ADC_DATA_10            ),
    .ANA_ADC_DATA_11            (ANA_ADC_DATA_11            ),
    .ANA_ADC_DATA_12            (ANA_ADC_DATA_12            ),
    .ANA_ADC_DATA_13            (ANA_ADC_DATA_13            ),
    .ANA_ADC_DATA_14            (ANA_ADC_DATA_14            ),
    .ANA_ADC_DATA_15            (ANA_ADC_DATA_15            ),
    .ANA_ADC_DATA_16            (ANA_ADC_DATA_16            ),
    .ANA_ADC_DATA_17            (ANA_ADC_DATA_17            ),
    .ANA_ADC_DATA_18            (ANA_ADC_DATA_18            ),
    .ANA_ADC_DATA_19            (ANA_ADC_DATA_19            ),
    .ANA_ADC_DATA_20            (ANA_ADC_DATA_20            ),
    .ANA_ADC_DATA_21            (ANA_ADC_DATA_21            ),
    .ANA_ADC_DATA_22            (ANA_ADC_DATA_22            ),
    .ANA_ADC_DATA_23            (ANA_ADC_DATA_23            ),
    .ANA_ADC48_DATA_0           (ANA_ADC48_DATA_0           ),
    .ANA_ADC48_DATA_1           (ANA_ADC48_DATA_1           ),
    .ANA_ADC48_DATA_2           (ANA_ADC48_DATA_2           ),
    .ANA_ADC48_DATA_3           (ANA_ADC48_DATA_3           ),
    .ANA_ADC48_DATA_4           (ANA_ADC48_DATA_4           ),
    .ANA_ADC48_DATA_5           (ANA_ADC48_DATA_5           ),
    .ANA_ADC48_DATA_6           (ANA_ADC48_DATA_6           ),
    .ANA_ADC48_DATA_7           (ANA_ADC48_DATA_7           ),
    .ANA_ADC48_DATA_8           (ANA_ADC48_DATA_8           ),
    .ANA_ADC48_DATA_9           (ANA_ADC48_DATA_9           ),
    .ANA_ADC48_DATA_10          (ANA_ADC48_DATA_10          ),
    .ANA_ADC48_DATA_11          (ANA_ADC48_DATA_11          ),
    .CLK_RD                     (CLK_RD                     ),
    .ADC_DATA                   (ADC_DATA                   ),
    .ADC_DATA_VALID             (ADC_DATA_VALID             )
    );

    ctrl_sys
    u_ctrl_sys
    (
    .clk_200m                   (clk_200m                   ),
    .rstn_200m                  (rstn_200m                  ),
    .pktctrl_clk                (pktctrl_clk                ),
    .pktctrl_rstn               (pktctrl_rstn               ),
    .mdio_in                    (MDIO                       ),
    .mdc                        (MDC                        ),
    .mdio_out                   (mdio_out                   ),
    .mdio_oen                   (mdio_oen                   ),
    
    // Digital config register
    .rf_self_test_mode_sync     (rf_self_test_mode          ),
    .rf_capture_mode_sync       (rf_capture_mode            ),
    .rf_capture_start_sync      (rf_capture_start           ),
    .rf_capture_again_sync      (rf_capture_again           ),
    .rf_96path_en_sync          (rf_96path_en               ),
    .rf_pkt_data_length_sync    (rf_pkt_data_length         ),
    .rf_pkt_idle_length_sync    (rf_pkt_idle_length         ),
    .rf_pktctrl_gap_sync        (rf_pktctrl_gap             ),
    .rf_pktctrl_phase_sync      (rf_pktctrl_phase           ),
    .rf_mdio_data_sel_sync      (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr_sync   (rf_mdio_memory_addr        ),
    .rf_mdio_pkt_data           (rf_mdio_pkt_data           ),

    .rf_pktctrl_clk_en          (rf_pktctrl_clk_en          ),
    .rf_pktctrl_sw_rstn         (rf_pktctrl_sw_rstn         )

    );

endmodule
