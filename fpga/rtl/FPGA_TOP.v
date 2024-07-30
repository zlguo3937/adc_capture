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
//  2024-07-30    zlguo         1.0         FPGA_TOP
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module FPGA_TOP
(
    output  wire    PAD1_ADC_DATA_1,
    output  wire    PAD2_ADC_DATA_2,
    output  wire    PAD3_ADC_DATA_3,
    output  wire    PAD4_ADC_DATA_4,
    output  wire    PAD5_ADC_DATA_5,
    output  wire    PAD6_ADC_DATA_6,
    output  wire    PAD7_ADC_DATA_7,
    output  wire    PAD8_ADC_DATA_8,
    output  wire    PAD9_ADC_DATA_9,
    output  wire    PAD10_ADC_DATA_10,
    output  wire    PAD11_ADC_DATA_11,
    output  wire    PAD12_ADC_DATA_12,
    output  wire    PAD13_ADC_DATA_13,
    output  wire    PAD14_ADC_DATA_14,
    output  wire    PAD15_ADC_DATA_15,
    output  wire    PAD16_ADC_DATA_16,
    output  wire    PAD17_ADC_DATA_17,
    output  wire    PAD18_ADC_DATA_18,
    output  wire    PAD19_ADC_DATA_VALID,
    input   wire    PAD20_RSTN,
    output  wire    PAD21_CLK_RD,
    input   wire    PAD22_MDC,
    inout   wire    PAD23_MDIO,
    input   wire    CLK100M
);

    wire            CLK200M;
    wire            ADC_CLK500M;
    wire            ADC48_CLK500M;

    wire    		locked;
    wire    		RSTN;
    wire    		CLK_100M_BUFG;

    clk_wiz_0
    u_clk_wiz_0
    (
    // Clock out ports
    .CLK200M        (CLK200M        ),
    .ADC_CLK500M    (ADC_CLK500M    ),
    // Status and control signals
    .resetn         (RSTN           ),
    .locked         (locked         ),
    // Clock in ports
    .CLK_100M       (CLK_100M       )
    );

    BUFG
    u_CLK_100M_BUFG
    (
    .I              (CLK_100M       ),
    .O              (CLK_100M_BUFG  )
    );

    reset_debouncer
    u_reset_debouncer
    (
    .clk            (CLK_100M_BUFG  ),
    .rstn_in        (PAD20_RSTN     ),
    .rstn_out       (RSTN           )
    );

    DIGITAL_WRAPPER
    u_digital_top
    (
    .CLK200M                    (CLK200M                    ),
    .ADC_CLK500M                (ADC_CLK500M                ),
    .ADC48_CLK500M              (ADC_CLK500M                ),

    .ADC_DATA_0                 (9'b0		                ),
    .ADC_DATA_1                 (9'b0		                ),
    .ADC_DATA_2                 (9'b0		                ),
    .ADC_DATA_3                 (9'b0		                ),
    .ADC_DATA_4                 (9'b0		                ),
    .ADC_DATA_5                 (9'b0		                ),
    .ADC_DATA_6                 (9'b0		                ),
    .ADC_DATA_7                 (9'b0		                ),
    .ADC_DATA_8                 (9'b0		                ),
    .ADC_DATA_9                 (9'b0		                ),
    .ADC_DATA_10                (9'b0		                ),
    .ADC_DATA_11                (9'b0		                ),
    .ADC_DATA_12                (9'b0		                ),
    .ADC_DATA_13                (9'b0		                ),
    .ADC_DATA_14                (9'b0		                ),
    .ADC_DATA_15                (9'b0		                ),
    .ADC_DATA_16                (9'b0		                ),
    .ADC_DATA_17                (9'b0		                ),
    .ADC_DATA_18                (9'b0		                ),
    .ADC_DATA_19                (9'b0		                ),
    .ADC_DATA_20                (9'b0		                ),
    .ADC_DATA_21                (9'b0		                ),
    .ADC_DATA_22                (9'b0		                ),
    .ADC_DATA_23                (9'b0		                ),
    .ADC_DATA_24                (9'b0		                ),
    .ADC_DATA_25                (9'b0		                ),
    .ADC_DATA_26                (9'b0		                ),
    .ADC_DATA_27                (9'b0		                ),
    .ADC_DATA_28                (9'b0		                ),
    .ADC_DATA_29                (9'b0		                ),
    .ADC_DATA_30                (9'b0		                ),
    .ADC_DATA_31                (9'b0		                ),
    .ADC_DATA_32                (9'b0		                ),
    .ADC_DATA_33                (9'b0		                ),
    .ADC_DATA_34                (9'b0		                ),
    .ADC_DATA_35                (9'b0		                ),
    .ADC_DATA_36                (9'b0		                ),
    .ADC_DATA_37                (9'b0		                ),
    .ADC_DATA_38                (9'b0		                ),
    .ADC_DATA_39                (9'b0		                ),
    .ADC_DATA_40                (9'b0		                ),
    .ADC_DATA_41                (9'b0		                ),
    .ADC_DATA_42                (9'b0		                ),
    .ADC_DATA_43                (9'b0		                ),
    .ADC_DATA_44                (9'b0		                ),
    .ADC_DATA_45                (9'b0		                ),
    .ADC_DATA_46                (9'b0		                ),
    .ADC_DATA_47                (9'b0		                ),
    .ADC_DATA_48                (9'b0		                ),
    .ADC_DATA_49                (9'b0		                ),
    .ADC_DATA_50                (9'b0		                ),
    .ADC_DATA_51                (9'b0		                ),
    .ADC_DATA_52                (9'b0		                ),
    .ADC_DATA_53                (9'b0		                ),
    .ADC_DATA_54                (9'b0		                ),
    .ADC_DATA_55                (9'b0		                ),
    .ADC_DATA_56                (9'b0		                ),
    .ADC_DATA_57                (9'b0		                ),
    .ADC_DATA_58                (9'b0		                ),
    .ADC_DATA_59                (9'b0		                ),
    .ADC_DATA_60                (9'b0		                ),
    .ADC_DATA_61                (9'b0		                ),
    .ADC_DATA_62                (9'b0		                ),
    .ADC_DATA_63                (9'b0		                ),
    .ADC_DATA_64                (9'b0		                ),
    .ADC_DATA_65                (9'b0		                ),
    .ADC_DATA_66                (9'b0		                ),
    .ADC_DATA_67                (9'b0		                ),
    .ADC_DATA_68                (9'b0		                ),
    .ADC_DATA_69                (9'b0		                ),
    .ADC_DATA_70                (9'b0		                ),
    .ADC_DATA_71                (9'b0		                ),
    .ADC_DATA_72                (9'b0		                ),
    .ADC_DATA_73                (9'b0		                ),
    .ADC_DATA_74                (9'b0		                ),
    .ADC_DATA_75                (9'b0		                ),
    .ADC_DATA_76                (9'b0		                ),
    .ADC_DATA_77                (9'b0		                ),
    .ADC_DATA_78                (9'b0		                ),
    .ADC_DATA_79                (9'b0		                ),
    .ADC_DATA_80                (9'b0		                ),
    .ADC_DATA_81                (9'b0		                ),
    .ADC_DATA_82                (9'b0		                ),
    .ADC_DATA_83                (9'b0		                ),
    .ADC_DATA_84                (9'b0		                ),
    .ADC_DATA_85                (9'b0		                ),
    .ADC_DATA_86                (9'b0		                ),
    .ADC_DATA_87                (9'b0		                ),
    .ADC_DATA_88                (9'b0		                ),
    .ADC_DATA_89                (9'b0		                ),
    .ADC_DATA_90                (9'b0		                ),
    .ADC_DATA_91                (9'b0		                ),
    .ADC_DATA_92                (9'b0		                ),
    .ADC_DATA_93                (9'b0		                ),
    .ADC_DATA_94                (9'b0		                ),
    .ADC_DATA_95                (9'b0		                ),
    .ADC48_DATA_0               (9'b0		                ),
    .ADC48_DATA_1               (9'b0		                ),
    .ADC48_DATA_2               (9'b0		                ),
    .ADC48_DATA_3               (9'b0		                ),
    .ADC48_DATA_4               (9'b0		                ),
    .ADC48_DATA_5               (9'b0		                ),
    .ADC48_DATA_6               (9'b0		                ),
    .ADC48_DATA_7               (9'b0		                ),
    .ADC48_DATA_8               (9'b0		                ),
    .ADC48_DATA_9               (9'b0		                ),
    .ADC48_DATA_10              (9'b0		                ),
    .ADC48_DATA_11              (9'b0		                ),
    .ADC48_DATA_12              (9'b0		                ),
    .ADC48_DATA_13              (9'b0		                ),
    .ADC48_DATA_14              (9'b0		                ),
    .ADC48_DATA_15              (9'b0		                ),
    .ADC48_DATA_16              (9'b0		                ),
    .ADC48_DATA_17              (9'b0		                ),
    .ADC48_DATA_18              (9'b0		                ),
    .ADC48_DATA_19              (9'b0		                ),
    .ADC48_DATA_20              (9'b0		                ),
    .ADC48_DATA_21              (9'b0		                ),
    .ADC48_DATA_22              (9'b0		                ),
    .ADC48_DATA_23              (9'b0		                ),
    .ADC48_DATA_24              (9'b0		                ),
    .ADC48_DATA_25              (9'b0		                ),
    .ADC48_DATA_26              (9'b0		                ),
    .ADC48_DATA_27              (9'b0		                ),
    .ADC48_DATA_28              (9'b0		                ),
    .ADC48_DATA_29              (9'b0		                ),
    .ADC48_DATA_30              (9'b0		                ),
    .ADC48_DATA_31              (9'b0		                ),
    .ADC48_DATA_32              (9'b0		                ),
    .ADC48_DATA_33              (9'b0		                ),
    .ADC48_DATA_34              (9'b0		                ),
    .ADC48_DATA_35              (9'b0		                ),
    .ADC48_DATA_36              (9'b0		                ),
    .ADC48_DATA_37              (9'b0		                ),
    .ADC48_DATA_38              (9'b0		                ),
    .ADC48_DATA_39              (9'b0		                ),
    .ADC48_DATA_40              (9'b0		                ),
    .ADC48_DATA_41              (9'b0		                ),
    .ADC48_DATA_42              (9'b0		                ),
    .ADC48_DATA_43              (9'b0		                ),
    .ADC48_DATA_44              (9'b0		                ),
    .ADC48_DATA_45              (9'b0		                ),
    .ADC48_DATA_46              (9'b0		                ),
    .ADC48_DATA_47              (9'b0		                ),

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

	// reset
    .PAD20_RSTN                 (RSTN                       ),

    .PAD21_CLK_RD               (PAD21_CLK_RD               ),
    .PAD22_MDC                  (PAD22_MDC                  ),
    .PAD23_MDIO                 (PAD23_MDIO                 )
    );

endmodule
