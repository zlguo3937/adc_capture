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
    input   wire            CLK200M,
    input   wire            ADC_CLK500M,
    input   wire            ADC48_CLK500M,

    input   wire    [8:0]   ADC_DATA_0 ,
    input   wire    [8:0]   ADC_DATA_1 ,
    input   wire    [8:0]   ADC_DATA_2 ,
    input   wire    [8:0]   ADC_DATA_3 ,
    input   wire    [8:0]   ADC_DATA_4 ,
    input   wire    [8:0]   ADC_DATA_5 ,
    input   wire    [8:0]   ADC_DATA_6 ,
    input   wire    [8:0]   ADC_DATA_7 ,
    input   wire    [8:0]   ADC_DATA_8 ,
    input   wire    [8:0]   ADC_DATA_9 ,
    input   wire    [8:0]   ADC_DATA_10,
    input   wire    [8:0]   ADC_DATA_11,
    input   wire    [8:0]   ADC_DATA_12,
    input   wire    [8:0]   ADC_DATA_13,
    input   wire    [8:0]   ADC_DATA_14,
    input   wire    [8:0]   ADC_DATA_15,
    input   wire    [8:0]   ADC_DATA_16,
    input   wire    [8:0]   ADC_DATA_17,
    input   wire    [8:0]   ADC_DATA_18,
    input   wire    [8:0]   ADC_DATA_19,
    input   wire    [8:0]   ADC_DATA_20,
    input   wire    [8:0]   ADC_DATA_21,
    input   wire    [8:0]   ADC_DATA_22,
    input   wire    [8:0]   ADC_DATA_23,
    input   wire    [8:0]   ADC_DATA_24,
    input   wire    [8:0]   ADC_DATA_25,
    input   wire    [8:0]   ADC_DATA_26,
    input   wire    [8:0]   ADC_DATA_27,
    input   wire    [8:0]   ADC_DATA_28,
    input   wire    [8:0]   ADC_DATA_29,
    input   wire    [8:0]   ADC_DATA_30,
    input   wire    [8:0]   ADC_DATA_31,
    input   wire    [8:0]   ADC_DATA_32,
    input   wire    [8:0]   ADC_DATA_33,
    input   wire    [8:0]   ADC_DATA_34,
    input   wire    [8:0]   ADC_DATA_35,
    input   wire    [8:0]   ADC_DATA_36,
    input   wire    [8:0]   ADC_DATA_37,
    input   wire    [8:0]   ADC_DATA_38,
    input   wire    [8:0]   ADC_DATA_39,
    input   wire    [8:0]   ADC_DATA_40,
    input   wire    [8:0]   ADC_DATA_41,
    input   wire    [8:0]   ADC_DATA_42,
    input   wire    [8:0]   ADC_DATA_43,
    input   wire    [8:0]   ADC_DATA_44,
    input   wire    [8:0]   ADC_DATA_45,
    input   wire    [8:0]   ADC_DATA_46,
    input   wire    [8:0]   ADC_DATA_47,
    input   wire    [8:0]   ADC_DATA_48,
    input   wire    [8:0]   ADC_DATA_49,
    input   wire    [8:0]   ADC_DATA_50,
    input   wire    [8:0]   ADC_DATA_51,
    input   wire    [8:0]   ADC_DATA_52,
    input   wire    [8:0]   ADC_DATA_53,
    input   wire    [8:0]   ADC_DATA_54,
    input   wire    [8:0]   ADC_DATA_55,
    input   wire    [8:0]   ADC_DATA_56,
    input   wire    [8:0]   ADC_DATA_57,
    input   wire    [8:0]   ADC_DATA_58,
    input   wire    [8:0]   ADC_DATA_59,
    input   wire    [8:0]   ADC_DATA_60,
    input   wire    [8:0]   ADC_DATA_61,
    input   wire    [8:0]   ADC_DATA_62,
    input   wire    [8:0]   ADC_DATA_63,
    input   wire    [8:0]   ADC_DATA_64,
    input   wire    [8:0]   ADC_DATA_65,
    input   wire    [8:0]   ADC_DATA_66,
    input   wire    [8:0]   ADC_DATA_67,
    input   wire    [8:0]   ADC_DATA_68,
    input   wire    [8:0]   ADC_DATA_69,
    input   wire    [8:0]   ADC_DATA_70,
    input   wire    [8:0]   ADC_DATA_71,
    input   wire    [8:0]   ADC_DATA_72,
    input   wire    [8:0]   ADC_DATA_73,
    input   wire    [8:0]   ADC_DATA_74,
    input   wire    [8:0]   ADC_DATA_75,
    input   wire    [8:0]   ADC_DATA_76,
    input   wire    [8:0]   ADC_DATA_77,
    input   wire    [8:0]   ADC_DATA_78,
    input   wire    [8:0]   ADC_DATA_79,
    input   wire    [8:0]   ADC_DATA_80,
    input   wire    [8:0]   ADC_DATA_81,
    input   wire    [8:0]   ADC_DATA_82,
    input   wire    [8:0]   ADC_DATA_83,
    input   wire    [8:0]   ADC_DATA_84,
    input   wire    [8:0]   ADC_DATA_85,
    input   wire    [8:0]   ADC_DATA_86,
    input   wire    [8:0]   ADC_DATA_87,
    input   wire    [8:0]   ADC_DATA_88,
    input   wire    [8:0]   ADC_DATA_89,
    input   wire    [8:0]   ADC_DATA_90,
    input   wire    [8:0]   ADC_DATA_91,
    input   wire    [8:0]   ADC_DATA_92,
    input   wire    [8:0]   ADC_DATA_93,
    input   wire    [8:0]   ADC_DATA_94,
    input   wire    [8:0]   ADC_DATA_95,
    input   wire    [8:0]   ADC48_DATA_0,
    input   wire    [8:0]   ADC48_DATA_1,
    input   wire    [8:0]   ADC48_DATA_2,
    input   wire    [8:0]   ADC48_DATA_3,
    input   wire    [8:0]   ADC48_DATA_4,
    input   wire    [8:0]   ADC48_DATA_5,
    input   wire    [8:0]   ADC48_DATA_6,
    input   wire    [8:0]   ADC48_DATA_7,
    input   wire    [8:0]   ADC48_DATA_8,
    input   wire    [8:0]   ADC48_DATA_9,
    input   wire    [8:0]   ADC48_DATA_10,
    input   wire    [8:0]   ADC48_DATA_11,
    input   wire    [8:0]   ADC48_DATA_12,
    input   wire    [8:0]   ADC48_DATA_13,
    input   wire    [8:0]   ADC48_DATA_14,
    input   wire    [8:0]   ADC48_DATA_15,
    input   wire    [8:0]   ADC48_DATA_16,
    input   wire    [8:0]   ADC48_DATA_17,
    input   wire    [8:0]   ADC48_DATA_18,
    input   wire    [8:0]   ADC48_DATA_19,
    input   wire    [8:0]   ADC48_DATA_20,
    input   wire    [8:0]   ADC48_DATA_21,
    input   wire    [8:0]   ADC48_DATA_22,
    input   wire    [8:0]   ADC48_DATA_23,
    input   wire    [8:0]   ADC48_DATA_24,
    input   wire    [8:0]   ADC48_DATA_25,
    input   wire    [8:0]   ADC48_DATA_26,
    input   wire    [8:0]   ADC48_DATA_27,
    input   wire    [8:0]   ADC48_DATA_28,
    input   wire    [8:0]   ADC48_DATA_29,
    input   wire    [8:0]   ADC48_DATA_30,
    input   wire    [8:0]   ADC48_DATA_31,
    input   wire    [8:0]   ADC48_DATA_32,
    input   wire    [8:0]   ADC48_DATA_33,
    input   wire    [8:0]   ADC48_DATA_34,
    input   wire    [8:0]   ADC48_DATA_35,
    input   wire    [8:0]   ADC48_DATA_36,
    input   wire    [8:0]   ADC48_DATA_37,
    input   wire    [8:0]   ADC48_DATA_38,
    input   wire    [8:0]   ADC48_DATA_39,
    input   wire    [8:0]   ADC48_DATA_40,
    input   wire    [8:0]   ADC48_DATA_41,
    input   wire    [8:0]   ADC48_DATA_42,
    input   wire    [8:0]   ADC48_DATA_43,
    input   wire    [8:0]   ADC48_DATA_44,
    input   wire    [8:0]   ADC48_DATA_45,
    input   wire    [8:0]   ADC48_DATA_46,
    input   wire    [8:0]   ADC48_DATA_47,

    // Analog register
    input   wire    [14:0]  SAR_PVSENSOR_CNT,
    output  wire            BG25M_TEST_EN,
    output  wire            SAR_BUFFER_PD,
    output  wire            SAR_CKBUF_PD,
    output  wire            SAR_CLK_EN,
    output  wire            SAR_DELAY,
    output  wire            SAR_PU_LDOADC,
    output  wire            SAR_PU_SENSOR,
    output  wire            SAR_PVSENSOR_CNT_EN,
    output  wire            SAR_REVERSE,
    output  wire            SAR_RSTN,
    output  wire            SAR_SF_ST1_PD,
    output  wire            SAR_SKEWGEN_EN,
    output  wire            SAR_TEST_EN,
    output  wire            SAR_VREF_PD,
    output  wire    [15:0]  SAR_RESVD1,
    output  wire    [1:0]   SAR_CKBUF_ISEL,
    output  wire    [1:0]   SAR_ISEL,
    output  wire    [1:0]   SAR_REFSEL,
    output  wire    [1:0]   SAR_SF_ST1_ISEL,
    output  wire    [2:0]   BG25M_TEST_SEL,
    output  wire    [2:0]   SAR_CMSEL,
    output  wire    [2:0]   SAR_LDO_ADCSEL,
    output  wire    [2:0]   SAR_LDO_BUFFERSEL,
    output  wire    [2:0]   SAR_LDO_CKSEL,
    output  wire    [2:0]   SAR_TEST_SEL,
    output  wire    [5:0]   SAR_CKCALBUF_DELAY,
    output  wire    [5:0]   SAR_DAC0_COARSE,
    output  wire    [5:0]   SAR_DAC0_FINE,
    output  wire    [5:0]   SAR_DAC1_COARSE,
    output  wire    [5:0]   SAR_DAC1_FINE,
    output  wire    [5:0]   SAR_DAC2_COARSE,
    output  wire    [5:0]   SAR_DAC2_FINE,
    output  wire    [5:0]   SAR_DAC3_COARSE,
    output  wire    [5:0]   SAR_DAC3_FINE,
    output  wire    [5:0]   SAR_DAC4_COARSE,
    output  wire    [5:0]   SAR_DAC4_FINE,
    output  wire    [5:0]   SAR_DAC5_COARSE,
    output  wire    [5:0]   SAR_DAC5_FINE,
    output  wire    [5:0]   SAR_DAC6_COARSE,
    output  wire    [5:0]   SAR_DAC6_FINE,
    output  wire    [5:0]   SAR_DAC7_COARSE,
    output  wire    [5:0]   SAR_DAC7_FINE,

    output  wire            PAD1_ADC_DATA_1,
    output  wire            PAD2_ADC_DATA_2,
    output  wire            PAD3_ADC_DATA_3,
    output  wire            PAD4_ADC_DATA_4,
    output  wire            PAD5_ADC_DATA_5,
    output  wire            PAD6_ADC_DATA_6,
    output  wire            PAD7_ADC_DATA_7,
    output  wire            PAD8_ADC_DATA_8,
    output  wire            PAD9_ADC_DATA_9,
    output  wire            PAD10_ADC_DATA_10,
    output  wire            PAD11_ADC_DATA_11,
    output  wire            PAD12_ADC_DATA_12,
    output  wire            PAD13_ADC_DATA_13,
    output  wire            PAD14_ADC_DATA_14,
    output  wire            PAD15_ADC_DATA_15,
    output  wire            PAD16_ADC_DATA_16,
    output  wire            PAD17_ADC_DATA_17,
    output  wire            PAD18_ADC_DATA_18,
    output  wire            PAD19_ADC_DATA_VALID,
    input   wire            PAD20_RSTN,
    output  wire            PAD21_CLK_RD,
    input   wire            PAD22_MDC,
    inout   wire            PAD23_MDIO
);

    // analog_signal_mux
    wire            ANA_CLK200M;
    wire            ANA_ADC_CLK500M;
    wire            ANA_ADC48_CLK500M;
    wire    [35:0]  ANA_ADC_DATA_0;
    wire    [35:0]  ANA_ADC_DATA_1;
    wire    [35:0]  ANA_ADC_DATA_2;
    wire    [35:0]  ANA_ADC_DATA_3;
    wire    [35:0]  ANA_ADC_DATA_4;
    wire    [35:0]  ANA_ADC_DATA_5;
    wire    [35:0]  ANA_ADC_DATA_6;
    wire    [35:0]  ANA_ADC_DATA_7;
    wire    [35:0]  ANA_ADC_DATA_8;
    wire    [35:0]  ANA_ADC_DATA_9;
    wire    [35:0]  ANA_ADC_DATA_10;
    wire    [35:0]  ANA_ADC_DATA_11;
    wire    [35:0]  ANA_ADC_DATA_12;
    wire    [35:0]  ANA_ADC_DATA_13;
    wire    [35:0]  ANA_ADC_DATA_14;
    wire    [35:0]  ANA_ADC_DATA_15;
    wire    [35:0]  ANA_ADC_DATA_16;
    wire    [35:0]  ANA_ADC_DATA_17;
    wire    [35:0]  ANA_ADC_DATA_18;
    wire    [35:0]  ANA_ADC_DATA_19;
    wire    [35:0]  ANA_ADC_DATA_20;
    wire    [35:0]  ANA_ADC_DATA_21;
    wire    [35:0]  ANA_ADC_DATA_22;
    wire    [35:0]  ANA_ADC_DATA_23;

    wire    [35:0]  ANA_ADC48_DATA_0;
    wire    [35:0]  ANA_ADC48_DATA_1;
    wire    [35:0]  ANA_ADC48_DATA_2;
    wire    [35:0]  ANA_ADC48_DATA_3;
    wire    [35:0]  ANA_ADC48_DATA_4;
    wire    [35:0]  ANA_ADC48_DATA_5;
    wire    [35:0]  ANA_ADC48_DATA_6;
    wire    [35:0]  ANA_ADC48_DATA_7;
    wire    [35:0]  ANA_ADC48_DATA_8;
    wire    [35:0]  ANA_ADC48_DATA_9;
    wire    [35:0]  ANA_ADC48_DATA_10;
    wire    [35:0]  ANA_ADC48_DATA_11;

    // crg
    wire    [8:0]   rf_pktctrl_gap;
    wire    [8:0]   rf_pktctrl_phase;
    wire            rf_pktctrl_clk_en;
    wire            rf_pktctrl_sw_rstn;
    wire            pktctrl_clk;
    wire            pktctrl_rstn;
    wire            clk_200m;
    wire            rstn_200m;
    wire            adc96_rstn;
    wire            adc48_rstn;

    // io pad
    wire            CLK_RD;
    wire            DATA_RD_EN; 
    wire            RSTN; 

    wire    [17:0]  ADC_DATA;
    wire            ADC_DATA_VALID;
    wire            MDIO;
    wire            MDC;
    wire            mdio_out;
    wire            mdio_oen;

    // ctrl_sys
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

    // analog_signal_mux instantiation
    analog_signal_mux
    u_analog_signal_mux
    (
    .adc96_rstn                 (adc96_rstn                 ),
    .adc48_rstn                 (adc48_rstn                 ),
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

    .ANA_CLK200M                (ANA_CLK200M                ),
    .ANA_ADC_CLK500M            (ANA_ADC_CLK500M            ),
    .ANA_ADC48_CLK500M          (ANA_ADC48_CLK500M          ),

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
    .ANA_ADC48_DATA_11          (ANA_ADC48_DATA_11          )
    );

    // crg instantiation
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

    // iopad instantiation
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

    // pktctrl_top instantiation
    pktctrl_top
    u_pktctrl_top
    (
    .pktctrl_clk                (pktctrl_clk                ),
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

    // ctrl_sys instantiation
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
    .rf_pktctrl_sw_rstn         (rf_pktctrl_sw_rstn         ),

    .SAR_PVSENSOR_CNT           (SAR_PVSENSOR_CNT           ),
    .BG25M_TEST_EN              (BG25M_TEST_EN              ),
    .SAR_BUFFER_PD              (SAR_BUFFER_PD              ),
    .SAR_CKBUF_PD               (SAR_CKBUF_PD               ),
    .SAR_CLK_EN                 (SAR_CLK_EN                 ),
    .SAR_DELAY                  (SAR_DELAY                  ),
    .SAR_PU_LDOADC              (SAR_PU_LDOADC              ),
    .SAR_PU_SENSOR              (SAR_PU_SENSOR              ),
    .SAR_PVSENSOR_CNT_EN        (SAR_PVSENSOR_CNT_EN        ),
    .SAR_REVERSE                (SAR_REVERSE                ),
    .SAR_RSTN                   (SAR_RSTN                   ),
    .SAR_SF_ST1_PD              (SAR_SF_ST1_PD              ),
    .SAR_SKEWGEN_EN             (SAR_SKEWGEN_EN             ),
    .SAR_TEST_EN                (SAR_TEST_EN                ),
    .SAR_VREF_PD                (SAR_VREF_PD                ),
    .SAR_RESVD1                 (SAR_RESVD1                 ),
    .SAR_CKBUF_ISEL             (SAR_CKBUF_ISEL             ),
    .SAR_ISEL                   (SAR_ISEL                   ),
    .SAR_REFSEL                 (SAR_REFSEL                 ),
    .SAR_SF_ST1_ISEL            (SAR_SF_ST1_ISEL            ),
    .BG25M_TEST_SEL             (BG25M_TEST_SEL             ),
    .SAR_CMSEL                  (SAR_CMSEL                  ),
    .SAR_LDO_ADCSEL             (SAR_LDO_ADCSEL             ),
    .SAR_LDO_BUFFERSEL          (SAR_LDO_BUFFERSEL          ),
    .SAR_LDO_CKSEL              (SAR_LDO_CKSEL              ),
    .SAR_TEST_SEL               (SAR_TEST_SEL               ),
    .SAR_CKCALBUF_DELAY         (SAR_CKCALBUF_DELAY         ),
    .SAR_DAC0_COARSE            (SAR_DAC0_COARSE            ),
    .SAR_DAC0_FINE              (SAR_DAC0_FINE              ),
    .SAR_DAC1_COARSE            (SAR_DAC1_COARSE            ),
    .SAR_DAC1_FINE              (SAR_DAC1_FINE              ),
    .SAR_DAC2_COARSE            (SAR_DAC2_COARSE            ),
    .SAR_DAC2_FINE              (SAR_DAC2_FINE              ),
    .SAR_DAC3_COARSE            (SAR_DAC3_COARSE            ),
    .SAR_DAC3_FINE              (SAR_DAC3_FINE              ),
    .SAR_DAC4_COARSE            (SAR_DAC4_COARSE            ),
    .SAR_DAC4_FINE              (SAR_DAC4_FINE              ),
    .SAR_DAC5_COARSE            (SAR_DAC5_COARSE            ),
    .SAR_DAC5_FINE              (SAR_DAC5_FINE              ),
    .SAR_DAC6_COARSE            (SAR_DAC6_COARSE            ),
    .SAR_DAC6_FINE              (SAR_DAC6_FINE              ),
    .SAR_DAC7_COARSE            (SAR_DAC7_COARSE            ),
    .SAR_DAC7_FINE              (SAR_DAC7_FINE              )
    );

endmodule
