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
//  2024-05-06    zlguo         1.0         pktctrl_top
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module pktctrl_top
(
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

    output  wire    [17:0]  ADC_DATA,
    output  wire            ADC_DATA_VALID
);

    wire    [35:0]  pkt_gen_data_0;
    wire    [35:0]  pkt_gen_data_1;
    wire    [35:0]  pkt_gen_data_2;
    wire    [35:0]  pkt_gen_data_3;
    wire    [35:0]  pkt_gen_data_4;
    wire    [35:0]  pkt_gen_data_5;
    wire    [35:0]  pkt_gen_data_6;
    wire    [35:0]  pkt_gen_data_7;
    wire    [35:0]  pkt_gen_data_8;
    wire    [35:0]  pkt_gen_data_9;
    wire    [35:0]  pkt_gen_data_10;
    wire    [35:0]  pkt_gen_data_11;
    wire    [35:0]  pkt_gen_data_12;
    wire    [35:0]  pkt_gen_data_13;
    wire    [35:0]  pkt_gen_data_14;
    wire    [35:0]  pkt_gen_data_15;
    wire    [35:0]  pkt_gen_data_16;
    wire    [35:0]  pkt_gen_data_17;
    wire    [35:0]  pkt_gen_data_18;
    wire    [35:0]  pkt_gen_data_19;
    wire    [35:0]  pkt_gen_data_20;
    wire    [35:0]  pkt_gen_data_21;
    wire    [35:0]  pkt_gen_data_22;
    wire    [35:0]  pkt_gen_data_23;

    wire    [35:0]  adc_data_0;
    wire    [35:0]  adc_data_1;
    wire    [35:0]  adc_data_2;
    wire    [35:0]  adc_data_3;
    wire    [35:0]  adc_data_4;
    wire    [35:0]  adc_data_5;
    wire    [35:0]  adc_data_6;
    wire    [35:0]  adc_data_7;
    wire    [35:0]  adc_data_8;
    wire    [35:0]  adc_data_9;
    wire    [35:0]  adc_data_10;
    wire    [35:0]  adc_data_11;
    wire    [35:0]  adc_data_12;
    wire    [35:0]  adc_data_13;
    wire    [35:0]  adc_data_14;
    wire    [35:0]  adc_data_15;
    wire    [35:0]  adc_data_16;
    wire    [35:0]  adc_data_17;
    wire    [35:0]  adc_data_18;
    wire    [35:0]  adc_data_19;
    wire    [35:0]  adc_data_20;
    wire    [35:0]  adc_data_21;
    wire    [35:0]  adc_data_22;
    wire    [35:0]  adc_data_23;

    package_ctrl
    u_package_ctrl
    (
    .adc_data_0                 (adc_data_0                 ),
    .adc_data_1                 (adc_data_1                 ),
    .adc_data_2                 (adc_data_2                 ),
    .adc_data_3                 (adc_data_3                 ),
    .adc_data_4                 (adc_data_4                 ),
    .adc_data_5                 (adc_data_5                 ),
    .adc_data_6                 (adc_data_6                 ),
    .adc_data_7                 (adc_data_7                 ),
    .adc_data_8                 (adc_data_8                 ),
    .adc_data_9                 (adc_data_9                 ),
    .adc_data_10                (adc_data_10                ),
    .adc_data_11                (adc_data_11                ),
    .adc_data_12                (adc_data_12                ),
    .adc_data_13                (adc_data_13                ),
    .adc_data_14                (adc_data_14                ),
    .adc_data_15                (adc_data_15                ),
    .adc_data_16                (adc_data_16                ),
    .adc_data_17                (adc_data_17                ),
    .adc_data_18                (adc_data_18                ),
    .adc_data_19                (adc_data_19                ),
    .adc_data_20                (adc_data_20                ),
    .adc_data_21                (adc_data_21                ),
    .adc_data_22                (adc_data_22                ),
    .adc_data_23                (adc_data_23                ),

    .ADC_DATA                   (ADC_DATA                   ),
    .ADC_DATA_VALID             (ADC_DATA_VALID             )
    );

    package_gen
    u_package_gen
    (
    .pkt_gen_data_0             (pkt_gen_data_0             ),
    .pkt_gen_data_1             (pkt_gen_data_1             ),
    .pkt_gen_data_2             (pkt_gen_data_2             ),
    .pkt_gen_data_3             (pkt_gen_data_3             ),
    .pkt_gen_data_4             (pkt_gen_data_4             ),
    .pkt_gen_data_5             (pkt_gen_data_5             ),
    .pkt_gen_data_6             (pkt_gen_data_6             ),
    .pkt_gen_data_7             (pkt_gen_data_7             ),
    .pkt_gen_data_8             (pkt_gen_data_8             ),
    .pkt_gen_data_9             (pkt_gen_data_9             ),
    .pkt_gen_data_10            (pkt_gen_data_10            ),
    .pkt_gen_data_11            (pkt_gen_data_11            ),
    .pkt_gen_data_12            (pkt_gen_data_12            ),
    .pkt_gen_data_13            (pkt_gen_data_13            ),
    .pkt_gen_data_14            (pkt_gen_data_14            ),
    .pkt_gen_data_15            (pkt_gen_data_15            ),
    .pkt_gen_data_16            (pkt_gen_data_16            ),
    .pkt_gen_data_17            (pkt_gen_data_17            ),
    .pkt_gen_data_18            (pkt_gen_data_18            ),
    .pkt_gen_data_19            (pkt_gen_data_19            ),
    .pkt_gen_data_20            (pkt_gen_data_20            ),
    .pkt_gen_data_21            (pkt_gen_data_21            ),
    .pkt_gen_data_22            (pkt_gen_data_22            ),
    .pkt_gen_data_23            (pkt_gen_data_23            )
    );

    adc_data_sel
    u_adc_data_sel
    (
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
    .pkt_gen_data_0             (pkt_gen_data_0             ),
    .pkt_gen_data_1             (pkt_gen_data_1             ),
    .pkt_gen_data_2             (pkt_gen_data_2             ),
    .pkt_gen_data_3             (pkt_gen_data_3             ),
    .pkt_gen_data_4             (pkt_gen_data_4             ),
    .pkt_gen_data_5             (pkt_gen_data_5             ),
    .pkt_gen_data_6             (pkt_gen_data_6             ),
    .pkt_gen_data_7             (pkt_gen_data_7             ),
    .pkt_gen_data_8             (pkt_gen_data_8             ),
    .pkt_gen_data_9             (pkt_gen_data_9             ),
    .pkt_gen_data_10            (pkt_gen_data_10            ),
    .pkt_gen_data_11            (pkt_gen_data_11            ),
    .pkt_gen_data_12            (pkt_gen_data_12            ),
    .pkt_gen_data_13            (pkt_gen_data_13            ),
    .pkt_gen_data_14            (pkt_gen_data_14            ),
    .pkt_gen_data_15            (pkt_gen_data_15            ),
    .pkt_gen_data_16            (pkt_gen_data_16            ),
    .pkt_gen_data_17            (pkt_gen_data_17            ),
    .pkt_gen_data_18            (pkt_gen_data_18            ),
    .pkt_gen_data_19            (pkt_gen_data_19            ),
    .pkt_gen_data_20            (pkt_gen_data_20            ),
    .pkt_gen_data_21            (pkt_gen_data_21            ),
    .pkt_gen_data_22            (pkt_gen_data_22            ),
    .pkt_gen_data_23            (pkt_gen_data_23            ),
    .adc_data_0                 (adc_data_0                 ),
    .adc_data_1                 (adc_data_1                 ),
    .adc_data_2                 (adc_data_2                 ),
    .adc_data_3                 (adc_data_3                 ),
    .adc_data_4                 (adc_data_4                 ),
    .adc_data_5                 (adc_data_5                 ),
    .adc_data_6                 (adc_data_6                 ),
    .adc_data_7                 (adc_data_7                 ),
    .adc_data_8                 (adc_data_8                 ),
    .adc_data_9                 (adc_data_9                 ),
    .adc_data_10                (adc_data_10                ),
    .adc_data_11                (adc_data_11                ),
    .adc_data_12                (adc_data_12                ),
    .adc_data_13                (adc_data_13                ),
    .adc_data_14                (adc_data_14                ),
    .adc_data_15                (adc_data_15                ),
    .adc_data_16                (adc_data_16                ),
    .adc_data_17                (adc_data_17                ),
    .adc_data_18                (adc_data_18                ),
    .adc_data_19                (adc_data_19                ),
    .adc_data_20                (adc_data_20                ),
    .adc_data_21                (adc_data_21                ),
    .adc_data_22                (adc_data_22                ),
    .adc_data_23                (adc_data_23                )
    );

endmodule
