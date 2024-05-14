module adc_data_sel
(
    input   wire            rf_self_mode,

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

    input   wire    [35:0]  pkt_gen_data_0,
    input   wire    [35:0]  pkt_gen_data_1,
    input   wire    [35:0]  pkt_gen_data_2,
    input   wire    [35:0]  pkt_gen_data_3,
    input   wire    [35:0]  pkt_gen_data_4,
    input   wire    [35:0]  pkt_gen_data_5,
    input   wire    [35:0]  pkt_gen_data_6,
    input   wire    [35:0]  pkt_gen_data_7,
    input   wire    [35:0]  pkt_gen_data_8,
    input   wire    [35:0]  pkt_gen_data_9,
    input   wire    [35:0]  pkt_gen_data_10,
    input   wire    [35:0]  pkt_gen_data_11,
    input   wire    [35:0]  pkt_gen_data_12,
    input   wire    [35:0]  pkt_gen_data_13,
    input   wire    [35:0]  pkt_gen_data_14,
    input   wire    [35:0]  pkt_gen_data_15,
    input   wire    [35:0]  pkt_gen_data_16,
    input   wire    [35:0]  pkt_gen_data_17,
    input   wire    [35:0]  pkt_gen_data_18,
    input   wire    [35:0]  pkt_gen_data_19,
    input   wire    [35:0]  pkt_gen_data_20,
    input   wire    [35:0]  pkt_gen_data_21,
    input   wire    [35:0]  pkt_gen_data_22,
    input   wire    [35:0]  pkt_gen_data_23,

    output  wire    [35:0]  adc_data_0,
    output  wire    [35:0]  adc_data_1,
    output  wire    [35:0]  adc_data_2,
    output  wire    [35:0]  adc_data_3,
    output  wire    [35:0]  adc_data_4,
    output  wire    [35:0]  adc_data_5,
    output  wire    [35:0]  adc_data_6,
    output  wire    [35:0]  adc_data_7,
    output  wire    [35:0]  adc_data_8,
    output  wire    [35:0]  adc_data_9,
    output  wire    [35:0]  adc_data_10,
    output  wire    [35:0]  adc_data_11,
    output  wire    [35:0]  adc_data_12,
    output  wire    [35:0]  adc_data_13,
    output  wire    [35:0]  adc_data_14,
    output  wire    [35:0]  adc_data_15,
    output  wire    [35:0]  adc_data_16,
    output  wire    [35:0]  adc_data_17,
    output  wire    [35:0]  adc_data_18,
    output  wire    [35:0]  adc_data_19,
    output  wire    [35:0]  adc_data_20,
    output  wire    [35:0]  adc_data_21,
    output  wire    [35:0]  adc_data_22,
    output  wire    [35:0]  adc_data_23
);

    assign adc_data_0 = rf_self_mode ? pkt_gen_data_0 : ANA_ADC_DATA_0;
    assign adc_data_1 = rf_self_mode ? pkt_gen_data_1 : ANA_ADC_DATA_1;
    assign adc_data_2 = rf_self_mode ? pkt_gen_data_2 : ANA_ADC_DATA_2;
    assign adc_data_3 = rf_self_mode ? pkt_gen_data_3 : ANA_ADC_DATA_3;
    assign adc_data_4 = rf_self_mode ? pkt_gen_data_4 : ANA_ADC_DATA_4;
    assign adc_data_5 = rf_self_mode ? pkt_gen_data_5 : ANA_ADC_DATA_5;
    assign adc_data_6 = rf_self_mode ? pkt_gen_data_6 : ANA_ADC_DATA_6;
    assign adc_data_7 = rf_self_mode ? pkt_gen_data_7 : ANA_ADC_DATA_7;
    assign adc_data_8 = rf_self_mode ? pkt_gen_data_8 : ANA_ADC_DATA_8;
    assign adc_data_9 = rf_self_mode ? pkt_gen_data_9 : ANA_ADC_DATA_9;
    assign adc_data_10 = rf_self_mode ? pkt_gen_data_10 : ANA_ADC_DATA_10;
    assign adc_data_11 = rf_self_mode ? pkt_gen_data_11 : ANA_ADC_DATA_11;
    assign adc_data_12 = rf_self_mode ? pkt_gen_data_12 : ANA_ADC_DATA_12;
    assign adc_data_13 = rf_self_mode ? pkt_gen_data_13 : ANA_ADC_DATA_13;
    assign adc_data_14 = rf_self_mode ? pkt_gen_data_14 : ANA_ADC_DATA_14;
    assign adc_data_15 = rf_self_mode ? pkt_gen_data_15 : ANA_ADC_DATA_15;
    assign adc_data_16 = rf_self_mode ? pkt_gen_data_16 : ANA_ADC_DATA_16;
    assign adc_data_17 = rf_self_mode ? pkt_gen_data_17 : ANA_ADC_DATA_17;
    assign adc_data_18 = rf_self_mode ? pkt_gen_data_18 : ANA_ADC_DATA_18;
    assign adc_data_19 = rf_self_mode ? pkt_gen_data_19 : ANA_ADC_DATA_19;
    assign adc_data_20 = rf_self_mode ? pkt_gen_data_20 : ANA_ADC_DATA_20;
    assign adc_data_21 = rf_self_mode ? pkt_gen_data_21 : ANA_ADC_DATA_21;
    assign adc_data_22 = rf_self_mode ? pkt_gen_data_22 : ANA_ADC_DATA_22;
    assign adc_data_23 = rf_self_mode ? pkt_gen_data_23 : ANA_ADC_DATA_23;

endmodule
