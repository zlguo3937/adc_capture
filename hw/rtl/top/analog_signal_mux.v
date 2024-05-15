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
//  2024-05-10    zlguo         1.0         analog_signal_mux
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module analog_signal_mux
(
    input   wire            CLK200M,
    input   wire            CLK500M,

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

    output  wire            ANA_CLK200M,
    output  wire            ANA_CLK500M,

    output  wire    [35:0]  ANA_ADC_DATA_0,
    output  wire    [35:0]  ANA_ADC_DATA_1,
    output  wire    [35:0]  ANA_ADC_DATA_2,
    output  wire    [35:0]  ANA_ADC_DATA_3,
    output  wire    [35:0]  ANA_ADC_DATA_4,
    output  wire    [35:0]  ANA_ADC_DATA_5,
    output  wire    [35:0]  ANA_ADC_DATA_6,
    output  wire    [35:0]  ANA_ADC_DATA_7,
    output  wire    [35:0]  ANA_ADC_DATA_8,
    output  wire    [35:0]  ANA_ADC_DATA_9,
    output  wire    [35:0]  ANA_ADC_DATA_10,
    output  wire    [35:0]  ANA_ADC_DATA_11,
    output  wire    [35:0]  ANA_ADC_DATA_12,
    output  wire    [35:0]  ANA_ADC_DATA_13,
    output  wire    [35:0]  ANA_ADC_DATA_14,
    output  wire    [35:0]  ANA_ADC_DATA_15,
    output  wire    [35:0]  ANA_ADC_DATA_16,
    output  wire    [35:0]  ANA_ADC_DATA_17,
    output  wire    [35:0]  ANA_ADC_DATA_18,
    output  wire    [35:0]  ANA_ADC_DATA_19,
    output  wire    [35:0]  ANA_ADC_DATA_20,
    output  wire    [35:0]  ANA_ADC_DATA_21,
    output  wire    [35:0]  ANA_ADC_DATA_22,
    output  wire    [35:0]  ANA_ADC_DATA_23,

    output  wire    [35:0]  ANA_ADC48_DATA_0,
    output  wire    [35:0]  ANA_ADC48_DATA_1,
    output  wire    [35:0]  ANA_ADC48_DATA_2,
    output  wire    [35:0]  ANA_ADC48_DATA_3,
    output  wire    [35:0]  ANA_ADC48_DATA_4,
    output  wire    [35:0]  ANA_ADC48_DATA_5,
    output  wire    [35:0]  ANA_ADC48_DATA_6,
    output  wire    [35:0]  ANA_ADC48_DATA_7,
    output  wire    [35:0]  ANA_ADC48_DATA_8,
    output  wire    [35:0]  ANA_ADC48_DATA_9,
    output  wire    [35:0]  ANA_ADC48_DATA_10,
    output  wire    [35:0]  ANA_ADC48_DATA_11

);

    assign ANA_CLK200M = CLK200M;
    assign ANA_CLK500M = CLK500M;

    assign ANA_ADC_DATA_0  = {ADC_DATA_3,  ADC_DATA_2,  ADC_DATA_1,  ADC_DATA_0};
    assign ANA_ADC_DATA_1  = {ADC_DATA_7,  ADC_DATA_6,  ADC_DATA_5,  ADC_DATA_4};
    assign ANA_ADC_DATA_2  = {ADC_DATA_11, ADC_DATA_10, ADC_DATA_9,  ADC_DATA_8};
    assign ANA_ADC_DATA_3  = {ADC_DATA_15, ADC_DATA_14, ADC_DATA_13, ADC_DATA_12};
    assign ANA_ADC_DATA_4  = {ADC_DATA_19, ADC_DATA_18, ADC_DATA_17, ADC_DATA_16};
    assign ANA_ADC_DATA_5  = {ADC_DATA_23, ADC_DATA_22, ADC_DATA_21, ADC_DATA_20};
    assign ANA_ADC_DATA_6  = {ADC_DATA_27, ADC_DATA_26, ADC_DATA_25, ADC_DATA_24};
    assign ANA_ADC_DATA_7  = {ADC_DATA_31, ADC_DATA_30, ADC_DATA_29, ADC_DATA_28};
    assign ANA_ADC_DATA_8  = {ADC_DATA_35, ADC_DATA_34, ADC_DATA_33, ADC_DATA_32};
    assign ANA_ADC_DATA_9  = {ADC_DATA_39, ADC_DATA_38, ADC_DATA_37, ADC_DATA_36};
    assign ANA_ADC_DATA_10 = {ADC_DATA_43, ADC_DATA_42, ADC_DATA_41, ADC_DATA_40};
    assign ANA_ADC_DATA_11 = {ADC_DATA_47, ADC_DATA_46, ADC_DATA_45, ADC_DATA_44};
    assign ANA_ADC_DATA_12 = {ADC_DATA_51, ADC_DATA_50, ADC_DATA_49, ADC_DATA_48};
    assign ANA_ADC_DATA_13 = {ADC_DATA_55, ADC_DATA_54, ADC_DATA_53, ADC_DATA_52};
    assign ANA_ADC_DATA_14 = {ADC_DATA_59, ADC_DATA_58, ADC_DATA_57, ADC_DATA_56};
    assign ANA_ADC_DATA_15 = {ADC_DATA_63, ADC_DATA_62, ADC_DATA_61, ADC_DATA_60};
    assign ANA_ADC_DATA_16 = {ADC_DATA_67, ADC_DATA_66, ADC_DATA_65, ADC_DATA_64};
    assign ANA_ADC_DATA_17 = {ADC_DATA_71, ADC_DATA_70, ADC_DATA_69, ADC_DATA_68};
    assign ANA_ADC_DATA_18 = {ADC_DATA_75, ADC_DATA_74, ADC_DATA_73, ADC_DATA_72};
    assign ANA_ADC_DATA_19 = {ADC_DATA_79, ADC_DATA_78, ADC_DATA_77, ADC_DATA_76};
    assign ANA_ADC_DATA_20 = {ADC_DATA_83, ADC_DATA_82, ADC_DATA_81, ADC_DATA_80};
    assign ANA_ADC_DATA_21 = {ADC_DATA_87, ADC_DATA_86, ADC_DATA_85, ADC_DATA_84};
    assign ANA_ADC_DATA_22 = {ADC_DATA_91, ADC_DATA_90, ADC_DATA_89, ADC_DATA_88};
    assign ANA_ADC_DATA_23 = {ADC_DATA_95, ADC_DATA_94, ADC_DATA_93, ADC_DATA_92};

    assign ANA_ADC48_DATA_0  = {ADC48_DATA_3,  ADC48_DATA_2,  ADC48_DATA_1,  ADC48_DATA_0};
    assign ANA_ADC48_DATA_1  = {ADC48_DATA_7,  ADC48_DATA_6,  ADC48_DATA_5,  ADC48_DATA_4};
    assign ANA_ADC48_DATA_2  = {ADC48_DATA_11, ADC48_DATA_10, ADC48_DATA_9,  ADC48_DATA_8};
    assign ANA_ADC48_DATA_3  = {ADC48_DATA_15, ADC48_DATA_14, ADC48_DATA_13, ADC48_DATA_12};
    assign ANA_ADC48_DATA_4  = {ADC48_DATA_19, ADC48_DATA_18, ADC48_DATA_17, ADC48_DATA_16};
    assign ANA_ADC48_DATA_5  = {ADC48_DATA_23, ADC48_DATA_22, ADC48_DATA_21, ADC48_DATA_20};
    assign ANA_ADC48_DATA_6  = {ADC48_DATA_27, ADC48_DATA_26, ADC48_DATA_25, ADC48_DATA_24};
    assign ANA_ADC48_DATA_7  = {ADC48_DATA_31, ADC48_DATA_30, ADC48_DATA_29, ADC48_DATA_28};
    assign ANA_ADC48_DATA_8  = {ADC48_DATA_35, ADC48_DATA_34, ADC48_DATA_33, ADC48_DATA_32};
    assign ANA_ADC48_DATA_9  = {ADC48_DATA_39, ADC48_DATA_38, ADC48_DATA_37, ADC48_DATA_36};
    assign ANA_ADC48_DATA_10 = {ADC48_DATA_43, ADC48_DATA_42, ADC48_DATA_41, ADC48_DATA_40};
    assign ANA_ADC48_DATA_11 = {ADC48_DATA_47, ADC48_DATA_46, ADC48_DATA_45, ADC48_DATA_44};

endmodule