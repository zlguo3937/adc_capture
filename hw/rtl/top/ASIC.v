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
//  2024-05-06    zlguo         1.0         ASIC
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module ASIC
(
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

    wire    ANA_CLK200M;
    wire    ANA_CLK500M;

    DIGITAL_WRAPPER
    u_digital_top
    (
    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_CLK500M                (ANA_CLK500M                ),

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

    ANALOG_WRAPPER
    u_analog_top
    (
    .CLK200M                    (ANA_CLK200M                ),
    .CLK500M                    (ANA_CLK500M                )
    );

endmodule
