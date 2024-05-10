module adc_data_sel
(
    adc_data_in_95, adc_data_in_94, adc_data_in_93, adc_data_in_92, adc_data_in_91, adc_data_in_90, adc_data_in_89, adc_data_in_88,
    adc_data_in_87, adc_data_in_86, adc_data_in_85, adc_data_in_84, adc_data_in_83, adc_data_in_82, adc_data_in_81, adc_data_in_80,
    adc_data_in_79, adc_data_in_78, adc_data_in_77, adc_data_in_76, adc_data_in_75, adc_data_in_74, adc_data_in_73, adc_data_in_72,
    adc_data_in_71, adc_data_in_70, adc_data_in_69, adc_data_in_68, adc_data_in_67, adc_data_in_66, adc_data_in_65, adc_data_in_64,
    adc_data_in_63, adc_data_in_62, adc_data_in_61, adc_data_in_60, adc_data_in_59, adc_data_in_58, adc_data_in_57, adc_data_in_56,
    adc_data_in_55, adc_data_in_54, adc_data_in_53, adc_data_in_52, adc_data_in_51, adc_data_in_50, adc_data_in_49, adc_data_in_48,
    adc_data_in_47, adc_data_in_46, adc_data_in_45, adc_data_in_44, adc_data_in_43, adc_data_in_42, adc_data_in_41, adc_data_in_40,
    adc_data_in_39, adc_data_in_38, adc_data_in_37, adc_data_in_36, adc_data_in_35, adc_data_in_34, adc_data_in_33, adc_data_in_32,
    adc_data_in_31, adc_data_in_30, adc_data_in_29, adc_data_in_28, adc_data_in_27, adc_data_in_26, adc_data_in_25, adc_data_in_24,
    adc_data_in_23, adc_data_in_22, adc_data_in_21, adc_data_in_20, adc_data_in_19, adc_data_in_18, adc_data_in_17, adc_data_in_16,
    adc_data_in_15, adc_data_in_14, adc_data_in_13, adc_data_in_12, adc_data_in_11, adc_data_in_10, adc_data_in_9,  adc_data_in_8,
    adc_data_in_7,  adc_data_in_6,  adc_data_in_5,  adc_data_in_4,  adc_data_in_3,  adc_data_in_2,  adc_data_in_1,  adc_data_in_0,

    pkt_gen_data_in_95, pkt_gen_data_in_94, pkt_gen_data_in_93, pkt_gen_data_in_92, pkt_gen_data_in_91, pkt_gen_data_in_90, pkt_gen_data_in_89, pkt_gen_data_in_88,
    pkt_gen_data_in_87, pkt_gen_data_in_86, pkt_gen_data_in_85, pkt_gen_data_in_84, pkt_gen_data_in_83, pkt_gen_data_in_82, pkt_gen_data_in_81, pkt_gen_data_in_80,
    pkt_gen_data_in_79, pkt_gen_data_in_78, pkt_gen_data_in_77, pkt_gen_data_in_76, pkt_gen_data_in_75, pkt_gen_data_in_74, pkt_gen_data_in_73, pkt_gen_data_in_72,
    pkt_gen_data_in_71, pkt_gen_data_in_70, pkt_gen_data_in_69, pkt_gen_data_in_68, pkt_gen_data_in_67, pkt_gen_data_in_66, pkt_gen_data_in_65, pkt_gen_data_in_64,
    pkt_gen_data_in_63, pkt_gen_data_in_62, pkt_gen_data_in_61, pkt_gen_data_in_60, pkt_gen_data_in_59, pkt_gen_data_in_58, pkt_gen_data_in_57, pkt_gen_data_in_56,
    pkt_gen_data_in_55, pkt_gen_data_in_54, pkt_gen_data_in_53, pkt_gen_data_in_52, pkt_gen_data_in_51, pkt_gen_data_in_50, pkt_gen_data_in_49, pkt_gen_data_in_48,
    pkt_gen_data_in_47, pkt_gen_data_in_46, pkt_gen_data_in_45, pkt_gen_data_in_44, pkt_gen_data_in_43, pkt_gen_data_in_42, pkt_gen_data_in_41, pkt_gen_data_in_40,
    pkt_gen_data_in_39, pkt_gen_data_in_38, pkt_gen_data_in_37, pkt_gen_data_in_36, pkt_gen_data_in_35, pkt_gen_data_in_34, pkt_gen_data_in_33, pkt_gen_data_in_32,
    pkt_gen_data_in_31, pkt_gen_data_in_30, pkt_gen_data_in_29, pkt_gen_data_in_28, pkt_gen_data_in_27, pkt_gen_data_in_26, pkt_gen_data_in_25, pkt_gen_data_in_24,
    pkt_gen_data_in_23, pkt_gen_data_in_22, pkt_gen_data_in_21, pkt_gen_data_in_20, pkt_gen_data_in_19, pkt_gen_data_in_18, pkt_gen_data_in_17, pkt_gen_data_in_16,
    pkt_gen_data_in_15, pkt_gen_data_in_14, pkt_gen_data_in_13, pkt_gen_data_in_12, pkt_gen_data_in_11, pkt_gen_data_in_10, pkt_gen_data_in_9,  pkt_gen_data_in_8,
    pkt_gen_data_in_7,  pkt_gen_data_in_6,  pkt_gen_data_in_5,  pkt_gen_data_in_4,  pkt_gen_data_in_3,  pkt_gen_data_in_2,  pkt_gen_data_in_1,  pkt_gen_data_in_0,

    rf_self_mode, data_in
);

    input       rf_self_mode;

    input [8:0] adc_data_in_95, adc_data_in_94, adc_data_in_93, adc_data_in_92, adc_data_in_91, adc_data_in_90, adc_data_in_89, adc_data_in_88,
                adc_data_in_87, adc_data_in_86, adc_data_in_85, adc_data_in_84, adc_data_in_83, adc_data_in_82, adc_data_in_81, adc_data_in_80,
                adc_data_in_79, adc_data_in_78, adc_data_in_77, adc_data_in_76, adc_data_in_75, adc_data_in_74, adc_data_in_73, adc_data_in_72,
                adc_data_in_71, adc_data_in_70, adc_data_in_69, adc_data_in_68, adc_data_in_67, adc_data_in_66, adc_data_in_65, adc_data_in_64,
                adc_data_in_63, adc_data_in_62, adc_data_in_61, adc_data_in_60, adc_data_in_59, adc_data_in_58, adc_data_in_57, adc_data_in_56,
                adc_data_in_55, adc_data_in_54, adc_data_in_53, adc_data_in_52, adc_data_in_51, adc_data_in_50, adc_data_in_49, adc_data_in_48,
                adc_data_in_47, adc_data_in_46, adc_data_in_45, adc_data_in_44, adc_data_in_43, adc_data_in_42, adc_data_in_41, adc_data_in_40,
                adc_data_in_39, adc_data_in_38, adc_data_in_37, adc_data_in_36, adc_data_in_35, adc_data_in_34, adc_data_in_33, adc_data_in_32,
                adc_data_in_31, adc_data_in_30, adc_data_in_29, adc_data_in_28, adc_data_in_27, adc_data_in_26, adc_data_in_25, adc_data_in_24,
                adc_data_in_23, adc_data_in_22, adc_data_in_21, adc_data_in_20, adc_data_in_19, adc_data_in_18, adc_data_in_17, adc_data_in_16,
                adc_data_in_15, adc_data_in_14, adc_data_in_13, adc_data_in_12, adc_data_in_11, adc_data_in_10, adc_data_in_9,  adc_data_in_8,
                adc_data_in_7,  adc_data_in_6,  adc_data_in_5,  adc_data_in_4,  adc_data_in_3,  adc_data_in_2,  adc_data_in_1,  adc_data_in_0;

    input [8:0] pkt_gen_data_in_95, pkt_gen_data_in_94, pkt_gen_data_in_93, pkt_gen_data_in_92, pkt_gen_data_in_91, pkt_gen_data_in_90, pkt_gen_data_in_89, pkt_gen_data_in_88,
                pkt_gen_data_in_87, pkt_gen_data_in_86, pkt_gen_data_in_85, pkt_gen_data_in_84, pkt_gen_data_in_83, pkt_gen_data_in_82, pkt_gen_data_in_81, pkt_gen_data_in_80,
                pkt_gen_data_in_79, pkt_gen_data_in_78, pkt_gen_data_in_77, pkt_gen_data_in_76, pkt_gen_data_in_75, pkt_gen_data_in_74, pkt_gen_data_in_73, pkt_gen_data_in_72,
                pkt_gen_data_in_71, pkt_gen_data_in_70, pkt_gen_data_in_69, pkt_gen_data_in_68, pkt_gen_data_in_67, pkt_gen_data_in_66, pkt_gen_data_in_65, pkt_gen_data_in_64,
                pkt_gen_data_in_63, pkt_gen_data_in_62, pkt_gen_data_in_61, pkt_gen_data_in_60, pkt_gen_data_in_59, pkt_gen_data_in_58, pkt_gen_data_in_57, pkt_gen_data_in_56,
                pkt_gen_data_in_55, pkt_gen_data_in_54, pkt_gen_data_in_53, pkt_gen_data_in_52, pkt_gen_data_in_51, pkt_gen_data_in_50, pkt_gen_data_in_49, pkt_gen_data_in_48,
                pkt_gen_data_in_47, pkt_gen_data_in_46, pkt_gen_data_in_45, pkt_gen_data_in_44, pkt_gen_data_in_43, pkt_gen_data_in_42, pkt_gen_data_in_41, pkt_gen_data_in_40,
                pkt_gen_data_in_39, pkt_gen_data_in_38, pkt_gen_data_in_37, pkt_gen_data_in_36, pkt_gen_data_in_35, pkt_gen_data_in_34, pkt_gen_data_in_33, pkt_gen_data_in_32,
                pkt_gen_data_in_31, pkt_gen_data_in_30, pkt_gen_data_in_29, pkt_gen_data_in_28, pkt_gen_data_in_27, pkt_gen_data_in_26, pkt_gen_data_in_25, pkt_gen_data_in_24,
                pkt_gen_data_in_23, pkt_gen_data_in_22, pkt_gen_data_in_21, pkt_gen_data_in_20, pkt_gen_data_in_19, pkt_gen_data_in_18, pkt_gen_data_in_17, pkt_gen_data_in_16,
                pkt_gen_data_in_15, pkt_gen_data_in_14, pkt_gen_data_in_13, pkt_gen_data_in_12, pkt_gen_data_in_11, pkt_gen_data_in_10, pkt_gen_data_in_9,  pkt_gen_data_in_8,
                pkt_gen_data_in_7,  pkt_gen_data_in_6,  pkt_gen_data_in_5,  pkt_gen_data_in_4,  pkt_gen_data_in_3,  pkt_gen_data_in_2,  pkt_gen_data_in_1,  pkt_gen_data_in_0;

    output  [9*96-1:0] data_in;

    wire    [9*96-1:0] adc_data_in;
    wire    [9*96-1:0] pkt_gen_data_in;

    assign adc_data_in = {  adc_data_in_95, adc_data_in_94, adc_data_in_93, adc_data_in_92, adc_data_in_91, adc_data_in_90, adc_data_in_89, adc_data_in_88,
                            adc_data_in_87, adc_data_in_86, adc_data_in_85, adc_data_in_84, adc_data_in_83, adc_data_in_82, adc_data_in_81, adc_data_in_80,
                            adc_data_in_79, adc_data_in_78, adc_data_in_77, adc_data_in_76, adc_data_in_75, adc_data_in_74, adc_data_in_73, adc_data_in_72,
                            adc_data_in_71, adc_data_in_70, adc_data_in_69, adc_data_in_68, adc_data_in_67, adc_data_in_66, adc_data_in_65, adc_data_in_64,
                            adc_data_in_63, adc_data_in_62, adc_data_in_61, adc_data_in_60, adc_data_in_59, adc_data_in_58, adc_data_in_57, adc_data_in_56,
                            adc_data_in_55, adc_data_in_54, adc_data_in_53, adc_data_in_52, adc_data_in_51, adc_data_in_50, adc_data_in_49, adc_data_in_48,
                            adc_data_in_47, adc_data_in_46, adc_data_in_45, adc_data_in_44, adc_data_in_43, adc_data_in_42, adc_data_in_41, adc_data_in_40,
                            adc_data_in_39, adc_data_in_38, adc_data_in_37, adc_data_in_36, adc_data_in_35, adc_data_in_34, adc_data_in_33, adc_data_in_32,
                            adc_data_in_31, adc_data_in_30, adc_data_in_29, adc_data_in_28, adc_data_in_27, adc_data_in_26, adc_data_in_25, adc_data_in_24,
                            adc_data_in_23, adc_data_in_22, adc_data_in_21, adc_data_in_20, adc_data_in_19, adc_data_in_18, adc_data_in_17, adc_data_in_16,
                            adc_data_in_15, adc_data_in_14, adc_data_in_13, adc_data_in_12, adc_data_in_11, adc_data_in_10, adc_data_in_9,  adc_data_in_8,
                            adc_data_in_7,  adc_data_in_6,  adc_data_in_5,  adc_data_in_4,  adc_data_in_3,  adc_data_in_2,  adc_data_in_1,  adc_data_in_0   };

    assign pkt_gen_data_in = {  pkt_gen_data_in_95, pkt_gen_data_in_94, pkt_gen_data_in_93, pkt_gen_data_in_92, pkt_gen_data_in_91, pkt_gen_data_in_90, pkt_gen_data_in_89, pkt_gen_data_in_88,
                                pkt_gen_data_in_87, pkt_gen_data_in_86, pkt_gen_data_in_85, pkt_gen_data_in_84, pkt_gen_data_in_83, pkt_gen_data_in_82, pkt_gen_data_in_81, pkt_gen_data_in_80,
                                pkt_gen_data_in_79, pkt_gen_data_in_78, pkt_gen_data_in_77, pkt_gen_data_in_76, pkt_gen_data_in_75, pkt_gen_data_in_74, pkt_gen_data_in_73, pkt_gen_data_in_72,
                                pkt_gen_data_in_71, pkt_gen_data_in_70, pkt_gen_data_in_69, pkt_gen_data_in_68, pkt_gen_data_in_67, pkt_gen_data_in_66, pkt_gen_data_in_65, pkt_gen_data_in_64,
                                pkt_gen_data_in_63, pkt_gen_data_in_62, pkt_gen_data_in_61, pkt_gen_data_in_60, pkt_gen_data_in_59, pkt_gen_data_in_58, pkt_gen_data_in_57, pkt_gen_data_in_56,
                                pkt_gen_data_in_55, pkt_gen_data_in_54, pkt_gen_data_in_53, pkt_gen_data_in_52, pkt_gen_data_in_51, pkt_gen_data_in_50, pkt_gen_data_in_49, pkt_gen_data_in_48,
                                pkt_gen_data_in_47, pkt_gen_data_in_46, pkt_gen_data_in_45, pkt_gen_data_in_44, pkt_gen_data_in_43, pkt_gen_data_in_42, pkt_gen_data_in_41, pkt_gen_data_in_40,
                                pkt_gen_data_in_39, pkt_gen_data_in_38, pkt_gen_data_in_37, pkt_gen_data_in_36, pkt_gen_data_in_35, pkt_gen_data_in_34, pkt_gen_data_in_33, pkt_gen_data_in_32,
                                pkt_gen_data_in_31, pkt_gen_data_in_30, pkt_gen_data_in_29, pkt_gen_data_in_28, pkt_gen_data_in_27, pkt_gen_data_in_26, pkt_gen_data_in_25, pkt_gen_data_in_24,
                                pkt_gen_data_in_23, pkt_gen_data_in_22, pkt_gen_data_in_21, pkt_gen_data_in_20, pkt_gen_data_in_19, pkt_gen_data_in_18, pkt_gen_data_in_17, pkt_gen_data_in_16,
                                pkt_gen_data_in_15, pkt_gen_data_in_14, pkt_gen_data_in_13, pkt_gen_data_in_12, pkt_gen_data_in_11, pkt_gen_data_in_10, pkt_gen_data_in_9,  pkt_gen_data_in_8,
                                pkt_gen_data_in_7,  pkt_gen_data_in_6,  pkt_gen_data_in_5,  pkt_gen_data_in_4,  pkt_gen_data_in_3,  pkt_gen_data_in_2,  pkt_gen_data_in_1,  pkt_gen_data_in_0   };

    assign data_in = rf_self_mode ? pkt_gen_data_in : adc_data_in;

endmodule
