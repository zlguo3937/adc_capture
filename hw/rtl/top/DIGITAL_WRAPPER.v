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

    inout   wire    PAD1_ADC_DATA_1,
    inout   wire    PAD2_ADC_DATA_2,
    inout   wire    PAD3_ADC_DATA_3,
    inout   wire    PAD4_ADC_DATA_4,
    inout   wire    PAD5_ADC_DATA_5,
    inout   wire    PAD6_ADC_DATA_6,
    inout   wire    PAD7_ADC_DATA_7,
    inout   wire    PAD8_ADC_DATA_8,
    inout   wire    PAD9_ADC_DATA_9,
    inout   wire    PAD10_ADC_DATA_10,
    inout   wire    PAD11_ADC_DATA_11,
    inout   wire    PAD12_ADC_DATA_12,
    inout   wire    PAD13_ADC_DATA_13,
    inout   wire    PAD14_ADC_DATA_14,
    inout   wire    PAD15_ADC_DATA_15,
    inout   wire    PAD16_ADC_DATA_16,
    inout   wire    PAD17_ADC_DATA_17,
    inout   wire    PAD18_ADC_DATA_18,
    inout   wire    PAD19_ADC_DATA_VALID,
    inout   wire    PAD20_RSTN,
    inout   wire    PAD21_CLK_RD,
    inout   wire    PAD22_MDC,
    inout   wire    PAD23_MDIO
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
    
    wire    [17:0]  ADC_DATA;
    wire            ADC_DATA_VALID;

    // iopad
    iopad_top
    u_iopad_top
    (
    .ADC_DATA                   (ADC_DATA                   ),
    .ADC_DATA_VALID             (ADC_DATA_VALID             ),
    .CLK_RD                     (CLK_RD                     ),
    .MDIO_I                     (MDIO_I                     ),
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
    .ADC_DATA                   (ADC_DATA                   ),
    .ADC_DATA_VALID             (ADC_DATA_VALID             ),
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
    .ANA_ADC_DATA_23            (ANA_ADC_DATA_23            )
    );

    ctrl_sys
    u_ctrl_sys
    (

    );

endmodule
