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
`timescale 1ns/1ns
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
`ifdef FPGA
    ,
    input   wire    CLK100M
`endif
);

    wire            CLK200M;
    wire            ADC_CLK500M;
    wire            ADC48_CLK500M;

`ifdef FPGA
    wire    locked;
    wire    RSTN;
    wire    CLK_100M_BUFG;

    clk_wiz_0
    u_clk_wiz_0
    (
    // Clock out ports
    .CLK200M        (CLK200M        ),
    .ADC_CLK500M    (ADC_CLK500M    ),
    .ADC48_CLK500M  (ADC48_CLK500M  ),
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

`else
`endif

    wire    [8:0]   ADC_DATA_0;
    wire    [8:0]   ADC_DATA_1;
    wire    [8:0]   ADC_DATA_2;
    wire    [8:0]   ADC_DATA_3;
    wire    [8:0]   ADC_DATA_4;
    wire    [8:0]   ADC_DATA_5;
    wire    [8:0]   ADC_DATA_6;
    wire    [8:0]   ADC_DATA_7;
    wire    [8:0]   ADC_DATA_8;
    wire    [8:0]   ADC_DATA_9;
    wire    [8:0]   ADC_DATA_10;
    wire    [8:0]   ADC_DATA_11;
    wire    [8:0]   ADC_DATA_12;
    wire    [8:0]   ADC_DATA_13;
    wire    [8:0]   ADC_DATA_14;
    wire    [8:0]   ADC_DATA_15;
    wire    [8:0]   ADC_DATA_16;
    wire    [8:0]   ADC_DATA_17;
    wire    [8:0]   ADC_DATA_18;
    wire    [8:0]   ADC_DATA_19;
    wire    [8:0]   ADC_DATA_20;
    wire    [8:0]   ADC_DATA_21;
    wire    [8:0]   ADC_DATA_22;
    wire    [8:0]   ADC_DATA_23;
    wire    [8:0]   ADC_DATA_24;
    wire    [8:0]   ADC_DATA_25;
    wire    [8:0]   ADC_DATA_26;
    wire    [8:0]   ADC_DATA_27;
    wire    [8:0]   ADC_DATA_28;
    wire    [8:0]   ADC_DATA_29;
    wire    [8:0]   ADC_DATA_30;
    wire    [8:0]   ADC_DATA_31;
    wire    [8:0]   ADC_DATA_32;
    wire    [8:0]   ADC_DATA_33;
    wire    [8:0]   ADC_DATA_34;
    wire    [8:0]   ADC_DATA_35;
    wire    [8:0]   ADC_DATA_36;
    wire    [8:0]   ADC_DATA_37;
    wire    [8:0]   ADC_DATA_38;
    wire    [8:0]   ADC_DATA_39;
    wire    [8:0]   ADC_DATA_40;
    wire    [8:0]   ADC_DATA_41;
    wire    [8:0]   ADC_DATA_42;
    wire    [8:0]   ADC_DATA_43;
    wire    [8:0]   ADC_DATA_44;
    wire    [8:0]   ADC_DATA_45;
    wire    [8:0]   ADC_DATA_46;
    wire    [8:0]   ADC_DATA_47;
    wire    [8:0]   ADC_DATA_48;
    wire    [8:0]   ADC_DATA_49;
    wire    [8:0]   ADC_DATA_50;
    wire    [8:0]   ADC_DATA_51;
    wire    [8:0]   ADC_DATA_52;
    wire    [8:0]   ADC_DATA_53;
    wire    [8:0]   ADC_DATA_54;
    wire    [8:0]   ADC_DATA_55;
    wire    [8:0]   ADC_DATA_56;
    wire    [8:0]   ADC_DATA_57;
    wire    [8:0]   ADC_DATA_58;
    wire    [8:0]   ADC_DATA_59;
    wire    [8:0]   ADC_DATA_60;
    wire    [8:0]   ADC_DATA_61;
    wire    [8:0]   ADC_DATA_62;
    wire    [8:0]   ADC_DATA_63;
    wire    [8:0]   ADC_DATA_64;
    wire    [8:0]   ADC_DATA_65;
    wire    [8:0]   ADC_DATA_66;
    wire    [8:0]   ADC_DATA_67;
    wire    [8:0]   ADC_DATA_68;
    wire    [8:0]   ADC_DATA_69;
    wire    [8:0]   ADC_DATA_70;
    wire    [8:0]   ADC_DATA_71;
    wire    [8:0]   ADC_DATA_72;
    wire    [8:0]   ADC_DATA_73;
    wire    [8:0]   ADC_DATA_74;
    wire    [8:0]   ADC_DATA_75;
    wire    [8:0]   ADC_DATA_76;
    wire    [8:0]   ADC_DATA_77;
    wire    [8:0]   ADC_DATA_78;
    wire    [8:0]   ADC_DATA_79;
    wire    [8:0]   ADC_DATA_80;
    wire    [8:0]   ADC_DATA_81;
    wire    [8:0]   ADC_DATA_82;
    wire    [8:0]   ADC_DATA_83;
    wire    [8:0]   ADC_DATA_84;
    wire    [8:0]   ADC_DATA_85;
    wire    [8:0]   ADC_DATA_86;
    wire    [8:0]   ADC_DATA_87;
    wire    [8:0]   ADC_DATA_88;
    wire    [8:0]   ADC_DATA_89;
    wire    [8:0]   ADC_DATA_90;
    wire    [8:0]   ADC_DATA_91;
    wire    [8:0]   ADC_DATA_92;
    wire    [8:0]   ADC_DATA_93;
    wire    [8:0]   ADC_DATA_94;
    wire    [8:0]   ADC_DATA_95;
    wire    [8:0]   ADC48_DATA_0;
    wire    [8:0]   ADC48_DATA_1;
    wire    [8:0]   ADC48_DATA_2;
    wire    [8:0]   ADC48_DATA_3;
    wire    [8:0]   ADC48_DATA_4;
    wire    [8:0]   ADC48_DATA_5;
    wire    [8:0]   ADC48_DATA_6;
    wire    [8:0]   ADC48_DATA_7;
    wire    [8:0]   ADC48_DATA_8;
    wire    [8:0]   ADC48_DATA_9;
    wire    [8:0]   ADC48_DATA_10;
    wire    [8:0]   ADC48_DATA_11;
    wire    [8:0]   ADC48_DATA_12;
    wire    [8:0]   ADC48_DATA_13;
    wire    [8:0]   ADC48_DATA_14;
    wire    [8:0]   ADC48_DATA_15;
    wire    [8:0]   ADC48_DATA_16;
    wire    [8:0]   ADC48_DATA_17;
    wire    [8:0]   ADC48_DATA_18;
    wire    [8:0]   ADC48_DATA_19;
    wire    [8:0]   ADC48_DATA_20;
    wire    [8:0]   ADC48_DATA_21;
    wire    [8:0]   ADC48_DATA_22;
    wire    [8:0]   ADC48_DATA_23;
    wire    [8:0]   ADC48_DATA_24;
    wire    [8:0]   ADC48_DATA_25;
    wire    [8:0]   ADC48_DATA_26;
    wire    [8:0]   ADC48_DATA_27;
    wire    [8:0]   ADC48_DATA_28;
    wire    [8:0]   ADC48_DATA_29;
    wire    [8:0]   ADC48_DATA_30;
    wire    [8:0]   ADC48_DATA_31;
    wire    [8:0]   ADC48_DATA_32;
    wire    [8:0]   ADC48_DATA_33;
    wire    [8:0]   ADC48_DATA_34;
    wire    [8:0]   ADC48_DATA_35;
    wire    [8:0]   ADC48_DATA_36;
    wire    [8:0]   ADC48_DATA_37;
    wire    [8:0]   ADC48_DATA_38;
    wire    [8:0]   ADC48_DATA_39;
    wire    [8:0]   ADC48_DATA_40;
    wire    [8:0]   ADC48_DATA_41;
    wire    [8:0]   ADC48_DATA_42;
    wire    [8:0]   ADC48_DATA_43;
    wire    [8:0]   ADC48_DATA_44;
    wire    [8:0]   ADC48_DATA_45;
    wire    [8:0]   ADC48_DATA_46;
    wire    [8:0]   ADC48_DATA_47;

    DIGITAL_WRAPPER
    u_digital_top
    (
    .CLK200M                    (CLK200M                    ),
    .ADC_CLK500M                (ADC_CLK500M                ),
    .ADC48_CLK500M              (ADC48_CLK500M              ),

    .ADC_DATA_0                 (ADC_DATA_0                 ),
    .ADC_DATA_1                 (ADC_DATA_1                 ),
    .ADC_DATA_2                 (ADC_DATA_2                 ),
    .ADC_DATA_3                 (ADC_DATA_3                 ),
    .ADC_DATA_4                 (ADC_DATA_4                 ),
    .ADC_DATA_5                 (ADC_DATA_5                 ),
    .ADC_DATA_6                 (ADC_DATA_6                 ),
    .ADC_DATA_7                 (ADC_DATA_7                 ),
    .ADC_DATA_8                 (ADC_DATA_8                 ),
    .ADC_DATA_9                 (ADC_DATA_9                 ),
    .ADC_DATA_10                (ADC_DATA_10                ),
    .ADC_DATA_11                (ADC_DATA_11                ),
    .ADC_DATA_12                (ADC_DATA_12                ),
    .ADC_DATA_13                (ADC_DATA_13                ),
    .ADC_DATA_14                (ADC_DATA_14                ),
    .ADC_DATA_15                (ADC_DATA_15                ),
    .ADC_DATA_16                (ADC_DATA_16                ),
    .ADC_DATA_17                (ADC_DATA_17                ),
    .ADC_DATA_18                (ADC_DATA_18                ),
    .ADC_DATA_19                (ADC_DATA_19                ),
    .ADC_DATA_20                (ADC_DATA_20                ),
    .ADC_DATA_21                (ADC_DATA_21                ),
    .ADC_DATA_22                (ADC_DATA_22                ),
    .ADC_DATA_23                (ADC_DATA_23                ),
    .ADC_DATA_24                (ADC_DATA_24                ),
    .ADC_DATA_25                (ADC_DATA_25                ),
    .ADC_DATA_26                (ADC_DATA_26                ),
    .ADC_DATA_27                (ADC_DATA_27                ),
    .ADC_DATA_28                (ADC_DATA_28                ),
    .ADC_DATA_29                (ADC_DATA_29                ),
    .ADC_DATA_30                (ADC_DATA_30                ),
    .ADC_DATA_31                (ADC_DATA_31                ),
    .ADC_DATA_32                (ADC_DATA_32                ),
    .ADC_DATA_33                (ADC_DATA_33                ),
    .ADC_DATA_34                (ADC_DATA_34                ),
    .ADC_DATA_35                (ADC_DATA_35                ),
    .ADC_DATA_36                (ADC_DATA_36                ),
    .ADC_DATA_37                (ADC_DATA_37                ),
    .ADC_DATA_38                (ADC_DATA_38                ),
    .ADC_DATA_39                (ADC_DATA_39                ),
    .ADC_DATA_40                (ADC_DATA_40                ),
    .ADC_DATA_41                (ADC_DATA_41                ),
    .ADC_DATA_42                (ADC_DATA_42                ),
    .ADC_DATA_43                (ADC_DATA_43                ),
    .ADC_DATA_44                (ADC_DATA_44                ),
    .ADC_DATA_45                (ADC_DATA_45                ),
    .ADC_DATA_46                (ADC_DATA_46                ),
    .ADC_DATA_47                (ADC_DATA_47                ),
    .ADC_DATA_48                (ADC_DATA_48                ),
    .ADC_DATA_49                (ADC_DATA_49                ),
    .ADC_DATA_50                (ADC_DATA_50                ),
    .ADC_DATA_51                (ADC_DATA_51                ),
    .ADC_DATA_52                (ADC_DATA_52                ),
    .ADC_DATA_53                (ADC_DATA_53                ),
    .ADC_DATA_54                (ADC_DATA_54                ),
    .ADC_DATA_55                (ADC_DATA_55                ),
    .ADC_DATA_56                (ADC_DATA_56                ),
    .ADC_DATA_57                (ADC_DATA_57                ),
    .ADC_DATA_58                (ADC_DATA_58                ),
    .ADC_DATA_59                (ADC_DATA_59                ),
    .ADC_DATA_60                (ADC_DATA_60                ),
    .ADC_DATA_61                (ADC_DATA_61                ),
    .ADC_DATA_62                (ADC_DATA_62                ),
    .ADC_DATA_63                (ADC_DATA_63                ),
    .ADC_DATA_64                (ADC_DATA_64                ),
    .ADC_DATA_65                (ADC_DATA_65                ),
    .ADC_DATA_66                (ADC_DATA_66                ),
    .ADC_DATA_67                (ADC_DATA_67                ),
    .ADC_DATA_68                (ADC_DATA_68                ),
    .ADC_DATA_69                (ADC_DATA_69                ),
    .ADC_DATA_70                (ADC_DATA_70                ),
    .ADC_DATA_71                (ADC_DATA_71                ),
    .ADC_DATA_72                (ADC_DATA_72                ),
    .ADC_DATA_73                (ADC_DATA_73                ),
    .ADC_DATA_74                (ADC_DATA_74                ),
    .ADC_DATA_75                (ADC_DATA_75                ),
    .ADC_DATA_76                (ADC_DATA_76                ),
    .ADC_DATA_77                (ADC_DATA_77                ),
    .ADC_DATA_78                (ADC_DATA_78                ),
    .ADC_DATA_79                (ADC_DATA_79                ),
    .ADC_DATA_80                (ADC_DATA_80                ),
    .ADC_DATA_81                (ADC_DATA_81                ),
    .ADC_DATA_82                (ADC_DATA_82                ),
    .ADC_DATA_83                (ADC_DATA_83                ),
    .ADC_DATA_84                (ADC_DATA_84                ),
    .ADC_DATA_85                (ADC_DATA_85                ),
    .ADC_DATA_86                (ADC_DATA_86                ),
    .ADC_DATA_87                (ADC_DATA_87                ),
    .ADC_DATA_88                (ADC_DATA_88                ),
    .ADC_DATA_89                (ADC_DATA_89                ),
    .ADC_DATA_90                (ADC_DATA_90                ),
    .ADC_DATA_91                (ADC_DATA_91                ),
    .ADC_DATA_92                (ADC_DATA_92                ),
    .ADC_DATA_93                (ADC_DATA_93                ),
    .ADC_DATA_94                (ADC_DATA_94                ),
    .ADC_DATA_95                (ADC_DATA_95                ),
    .ADC48_DATA_0               (ADC48_DATA_0               ),
    .ADC48_DATA_1               (ADC48_DATA_1               ),
    .ADC48_DATA_2               (ADC48_DATA_2               ),
    .ADC48_DATA_3               (ADC48_DATA_3               ),
    .ADC48_DATA_4               (ADC48_DATA_4               ),
    .ADC48_DATA_5               (ADC48_DATA_5               ),
    .ADC48_DATA_6               (ADC48_DATA_6               ),
    .ADC48_DATA_7               (ADC48_DATA_7               ),
    .ADC48_DATA_8               (ADC48_DATA_8               ),
    .ADC48_DATA_9               (ADC48_DATA_9               ),
    .ADC48_DATA_10              (ADC48_DATA_10              ),
    .ADC48_DATA_11              (ADC48_DATA_11              ),
    .ADC48_DATA_12              (ADC48_DATA_12              ),
    .ADC48_DATA_13              (ADC48_DATA_13              ),
    .ADC48_DATA_14              (ADC48_DATA_14              ),
    .ADC48_DATA_15              (ADC48_DATA_15              ),
    .ADC48_DATA_16              (ADC48_DATA_16              ),
    .ADC48_DATA_17              (ADC48_DATA_17              ),
    .ADC48_DATA_18              (ADC48_DATA_18              ),
    .ADC48_DATA_19              (ADC48_DATA_19              ),
    .ADC48_DATA_20              (ADC48_DATA_20              ),
    .ADC48_DATA_21              (ADC48_DATA_21              ),
    .ADC48_DATA_22              (ADC48_DATA_22              ),
    .ADC48_DATA_23              (ADC48_DATA_23              ),
    .ADC48_DATA_24              (ADC48_DATA_24              ),
    .ADC48_DATA_25              (ADC48_DATA_25              ),
    .ADC48_DATA_26              (ADC48_DATA_26              ),
    .ADC48_DATA_27              (ADC48_DATA_27              ),
    .ADC48_DATA_28              (ADC48_DATA_28              ),
    .ADC48_DATA_29              (ADC48_DATA_29              ),
    .ADC48_DATA_30              (ADC48_DATA_30              ),
    .ADC48_DATA_31              (ADC48_DATA_31              ),
    .ADC48_DATA_32              (ADC48_DATA_32              ),
    .ADC48_DATA_33              (ADC48_DATA_33              ),
    .ADC48_DATA_34              (ADC48_DATA_34              ),
    .ADC48_DATA_35              (ADC48_DATA_35              ),
    .ADC48_DATA_36              (ADC48_DATA_36              ),
    .ADC48_DATA_37              (ADC48_DATA_37              ),
    .ADC48_DATA_38              (ADC48_DATA_38              ),
    .ADC48_DATA_39              (ADC48_DATA_39              ),
    .ADC48_DATA_40              (ADC48_DATA_40              ),
    .ADC48_DATA_41              (ADC48_DATA_41              ),
    .ADC48_DATA_42              (ADC48_DATA_42              ),
    .ADC48_DATA_43              (ADC48_DATA_43              ),
    .ADC48_DATA_44              (ADC48_DATA_44              ),
    .ADC48_DATA_45              (ADC48_DATA_45              ),
    .ADC48_DATA_46              (ADC48_DATA_46              ),
    .ADC48_DATA_47              (ADC48_DATA_47              ),

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
`ifndef FPGA
    .PAD20_RSTN                 (PAD20_RSTN                 ),
`else
    .PAD20_RSTN                 (RSTN                       ),
`endif
    .PAD21_CLK_RD               (PAD21_CLK_RD               ),
    .PAD22_MDC                  (PAD22_MDC                  ),
    .PAD23_MDIO                 (PAD23_MDIO                 )
    );

`ifndef FPGA
    ANALOG_WRAPPER
    u_analog_top
    (
    .CLK200M                    (CLK200M                    ),
    .ADC_CLK500M                (ADC_CLK500M                ),
    .ADC48_CLK500M              (ADC48_CLK500M              ),

    .ADC_DATA_0                 (ADC_DATA_0                 ),
    .ADC_DATA_1                 (ADC_DATA_1                 ),
    .ADC_DATA_2                 (ADC_DATA_2                 ),
    .ADC_DATA_3                 (ADC_DATA_3                 ),
    .ADC_DATA_4                 (ADC_DATA_4                 ),
    .ADC_DATA_5                 (ADC_DATA_5                 ),
    .ADC_DATA_6                 (ADC_DATA_6                 ),
    .ADC_DATA_7                 (ADC_DATA_7                 ),
    .ADC_DATA_8                 (ADC_DATA_8                 ),
    .ADC_DATA_9                 (ADC_DATA_9                 ),
    .ADC_DATA_10                (ADC_DATA_10                ),
    .ADC_DATA_11                (ADC_DATA_11                ),
    .ADC_DATA_12                (ADC_DATA_12                ),
    .ADC_DATA_13                (ADC_DATA_13                ),
    .ADC_DATA_14                (ADC_DATA_14                ),
    .ADC_DATA_15                (ADC_DATA_15                ),
    .ADC_DATA_16                (ADC_DATA_16                ),
    .ADC_DATA_17                (ADC_DATA_17                ),
    .ADC_DATA_18                (ADC_DATA_18                ),
    .ADC_DATA_19                (ADC_DATA_19                ),
    .ADC_DATA_20                (ADC_DATA_20                ),
    .ADC_DATA_21                (ADC_DATA_21                ),
    .ADC_DATA_22                (ADC_DATA_22                ),
    .ADC_DATA_23                (ADC_DATA_23                ),
    .ADC_DATA_24                (ADC_DATA_24                ),
    .ADC_DATA_25                (ADC_DATA_25                ),
    .ADC_DATA_26                (ADC_DATA_26                ),
    .ADC_DATA_27                (ADC_DATA_27                ),
    .ADC_DATA_28                (ADC_DATA_28                ),
    .ADC_DATA_29                (ADC_DATA_29                ),
    .ADC_DATA_30                (ADC_DATA_30                ),
    .ADC_DATA_31                (ADC_DATA_31                ),
    .ADC_DATA_32                (ADC_DATA_32                ),
    .ADC_DATA_33                (ADC_DATA_33                ),
    .ADC_DATA_34                (ADC_DATA_34                ),
    .ADC_DATA_35                (ADC_DATA_35                ),
    .ADC_DATA_36                (ADC_DATA_36                ),
    .ADC_DATA_37                (ADC_DATA_37                ),
    .ADC_DATA_38                (ADC_DATA_38                ),
    .ADC_DATA_39                (ADC_DATA_39                ),
    .ADC_DATA_40                (ADC_DATA_40                ),
    .ADC_DATA_41                (ADC_DATA_41                ),
    .ADC_DATA_42                (ADC_DATA_42                ),
    .ADC_DATA_43                (ADC_DATA_43                ),
    .ADC_DATA_44                (ADC_DATA_44                ),
    .ADC_DATA_45                (ADC_DATA_45                ),
    .ADC_DATA_46                (ADC_DATA_46                ),
    .ADC_DATA_47                (ADC_DATA_47                ),
    .ADC_DATA_48                (ADC_DATA_48                ),
    .ADC_DATA_49                (ADC_DATA_49                ),
    .ADC_DATA_50                (ADC_DATA_50                ),
    .ADC_DATA_51                (ADC_DATA_51                ),
    .ADC_DATA_52                (ADC_DATA_52                ),
    .ADC_DATA_53                (ADC_DATA_53                ),
    .ADC_DATA_54                (ADC_DATA_54                ),
    .ADC_DATA_55                (ADC_DATA_55                ),
    .ADC_DATA_56                (ADC_DATA_56                ),
    .ADC_DATA_57                (ADC_DATA_57                ),
    .ADC_DATA_58                (ADC_DATA_58                ),
    .ADC_DATA_59                (ADC_DATA_59                ),
    .ADC_DATA_60                (ADC_DATA_60                ),
    .ADC_DATA_61                (ADC_DATA_61                ),
    .ADC_DATA_62                (ADC_DATA_62                ),
    .ADC_DATA_63                (ADC_DATA_63                ),
    .ADC_DATA_64                (ADC_DATA_64                ),
    .ADC_DATA_65                (ADC_DATA_65                ),
    .ADC_DATA_66                (ADC_DATA_66                ),
    .ADC_DATA_67                (ADC_DATA_67                ),
    .ADC_DATA_68                (ADC_DATA_68                ),
    .ADC_DATA_69                (ADC_DATA_69                ),
    .ADC_DATA_70                (ADC_DATA_70                ),
    .ADC_DATA_71                (ADC_DATA_71                ),
    .ADC_DATA_72                (ADC_DATA_72                ),
    .ADC_DATA_73                (ADC_DATA_73                ),
    .ADC_DATA_74                (ADC_DATA_74                ),
    .ADC_DATA_75                (ADC_DATA_75                ),
    .ADC_DATA_76                (ADC_DATA_76                ),
    .ADC_DATA_77                (ADC_DATA_77                ),
    .ADC_DATA_78                (ADC_DATA_78                ),
    .ADC_DATA_79                (ADC_DATA_79                ),
    .ADC_DATA_80                (ADC_DATA_80                ),
    .ADC_DATA_81                (ADC_DATA_81                ),
    .ADC_DATA_82                (ADC_DATA_82                ),
    .ADC_DATA_83                (ADC_DATA_83                ),
    .ADC_DATA_84                (ADC_DATA_84                ),
    .ADC_DATA_85                (ADC_DATA_85                ),
    .ADC_DATA_86                (ADC_DATA_86                ),
    .ADC_DATA_87                (ADC_DATA_87                ),
    .ADC_DATA_88                (ADC_DATA_88                ),
    .ADC_DATA_89                (ADC_DATA_89                ),
    .ADC_DATA_90                (ADC_DATA_90                ),
    .ADC_DATA_91                (ADC_DATA_91                ),
    .ADC_DATA_92                (ADC_DATA_92                ),
    .ADC_DATA_93                (ADC_DATA_93                ),
    .ADC_DATA_94                (ADC_DATA_94                ),
    .ADC_DATA_95                (ADC_DATA_95                ),
    .ADC48_DATA_0               (ADC48_DATA_0               ),
    .ADC48_DATA_1               (ADC48_DATA_1               ),
    .ADC48_DATA_2               (ADC48_DATA_2               ),
    .ADC48_DATA_3               (ADC48_DATA_3               ),
    .ADC48_DATA_4               (ADC48_DATA_4               ),
    .ADC48_DATA_5               (ADC48_DATA_5               ),
    .ADC48_DATA_6               (ADC48_DATA_6               ),
    .ADC48_DATA_7               (ADC48_DATA_7               ),
    .ADC48_DATA_8               (ADC48_DATA_8               ),
    .ADC48_DATA_9               (ADC48_DATA_9               ),
    .ADC48_DATA_10              (ADC48_DATA_10              ),
    .ADC48_DATA_11              (ADC48_DATA_11              ),
    .ADC48_DATA_12              (ADC48_DATA_12              ),
    .ADC48_DATA_13              (ADC48_DATA_13              ),
    .ADC48_DATA_14              (ADC48_DATA_14              ),
    .ADC48_DATA_15              (ADC48_DATA_15              ),
    .ADC48_DATA_16              (ADC48_DATA_16              ),
    .ADC48_DATA_17              (ADC48_DATA_17              ),
    .ADC48_DATA_18              (ADC48_DATA_18              ),
    .ADC48_DATA_19              (ADC48_DATA_19              ),
    .ADC48_DATA_20              (ADC48_DATA_20              ),
    .ADC48_DATA_21              (ADC48_DATA_21              ),
    .ADC48_DATA_22              (ADC48_DATA_22              ),
    .ADC48_DATA_23              (ADC48_DATA_23              ),
    .ADC48_DATA_24              (ADC48_DATA_24              ),
    .ADC48_DATA_25              (ADC48_DATA_25              ),
    .ADC48_DATA_26              (ADC48_DATA_26              ),
    .ADC48_DATA_27              (ADC48_DATA_27              ),
    .ADC48_DATA_28              (ADC48_DATA_28              ),
    .ADC48_DATA_29              (ADC48_DATA_29              ),
    .ADC48_DATA_30              (ADC48_DATA_30              ),
    .ADC48_DATA_31              (ADC48_DATA_31              ),
    .ADC48_DATA_32              (ADC48_DATA_32              ),
    .ADC48_DATA_33              (ADC48_DATA_33              ),
    .ADC48_DATA_34              (ADC48_DATA_34              ),
    .ADC48_DATA_35              (ADC48_DATA_35              ),
    .ADC48_DATA_36              (ADC48_DATA_36              ),
    .ADC48_DATA_37              (ADC48_DATA_37              ),
    .ADC48_DATA_38              (ADC48_DATA_38              ),
    .ADC48_DATA_39              (ADC48_DATA_39              ),
    .ADC48_DATA_40              (ADC48_DATA_40              ),
    .ADC48_DATA_41              (ADC48_DATA_41              ),
    .ADC48_DATA_42              (ADC48_DATA_42              ),
    .ADC48_DATA_43              (ADC48_DATA_43              ),
    .ADC48_DATA_44              (ADC48_DATA_44              ),
    .ADC48_DATA_45              (ADC48_DATA_45              ),
    .ADC48_DATA_46              (ADC48_DATA_46              ),
    .ADC48_DATA_47              (ADC48_DATA_47              )
    );
`else
`endif

endmodule
