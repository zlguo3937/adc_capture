`timescale 10ps/10ps

module ANALOG_WRAPPER
#(
    parameter WIDTH = 9
)
(
    output  wire            CLK200M,
    output  wire            ADC_CLK500M,
    output  wire            ADC48_CLK500M,

    output  wire    [8:0]   ADC_DATA_0,
    output  wire    [8:0]   ADC_DATA_1,
    output  wire    [8:0]   ADC_DATA_2,
    output  wire    [8:0]   ADC_DATA_3,
    output  wire    [8:0]   ADC_DATA_4,
    output  wire    [8:0]   ADC_DATA_5,
    output  wire    [8:0]   ADC_DATA_6,
    output  wire    [8:0]   ADC_DATA_7,
    output  wire    [8:0]   ADC_DATA_8,
    output  wire    [8:0]   ADC_DATA_9,
    output  wire    [8:0]   ADC_DATA_10,
    output  wire    [8:0]   ADC_DATA_11,
    output  wire    [8:0]   ADC_DATA_12,
    output  wire    [8:0]   ADC_DATA_13,
    output  wire    [8:0]   ADC_DATA_14,
    output  wire    [8:0]   ADC_DATA_15,
    output  wire    [8:0]   ADC_DATA_16,
    output  wire    [8:0]   ADC_DATA_17,
    output  wire    [8:0]   ADC_DATA_18,
    output  wire    [8:0]   ADC_DATA_19,
    output  wire    [8:0]   ADC_DATA_20,
    output  wire    [8:0]   ADC_DATA_21,
    output  wire    [8:0]   ADC_DATA_22,
    output  wire    [8:0]   ADC_DATA_23,
    output  wire    [8:0]   ADC_DATA_24,
    output  wire    [8:0]   ADC_DATA_25,
    output  wire    [8:0]   ADC_DATA_26,
    output  wire    [8:0]   ADC_DATA_27,
    output  wire    [8:0]   ADC_DATA_28,
    output  wire    [8:0]   ADC_DATA_29,
    output  wire    [8:0]   ADC_DATA_30,
    output  wire    [8:0]   ADC_DATA_31,
    output  wire    [8:0]   ADC_DATA_32,
    output  wire    [8:0]   ADC_DATA_33,
    output  wire    [8:0]   ADC_DATA_34,
    output  wire    [8:0]   ADC_DATA_35,
    output  wire    [8:0]   ADC_DATA_36,
    output  wire    [8:0]   ADC_DATA_37,
    output  wire    [8:0]   ADC_DATA_38,
    output  wire    [8:0]   ADC_DATA_39,
    output  wire    [8:0]   ADC_DATA_40,
    output  wire    [8:0]   ADC_DATA_41,
    output  wire    [8:0]   ADC_DATA_42,
    output  wire    [8:0]   ADC_DATA_43,
    output  wire    [8:0]   ADC_DATA_44,
    output  wire    [8:0]   ADC_DATA_45,
    output  wire    [8:0]   ADC_DATA_46,
    output  wire    [8:0]   ADC_DATA_47,
    output  wire    [8:0]   ADC_DATA_48,
    output  wire    [8:0]   ADC_DATA_49,
    output  wire    [8:0]   ADC_DATA_50,
    output  wire    [8:0]   ADC_DATA_51,
    output  wire    [8:0]   ADC_DATA_52,
    output  wire    [8:0]   ADC_DATA_53,
    output  wire    [8:0]   ADC_DATA_54,
    output  wire    [8:0]   ADC_DATA_55,
    output  wire    [8:0]   ADC_DATA_56,
    output  wire    [8:0]   ADC_DATA_57,
    output  wire    [8:0]   ADC_DATA_58,
    output  wire    [8:0]   ADC_DATA_59,
    output  wire    [8:0]   ADC_DATA_60,
    output  wire    [8:0]   ADC_DATA_61,
    output  wire    [8:0]   ADC_DATA_62,
    output  wire    [8:0]   ADC_DATA_63,
    output  wire    [8:0]   ADC_DATA_64,
    output  wire    [8:0]   ADC_DATA_65,
    output  wire    [8:0]   ADC_DATA_66,
    output  wire    [8:0]   ADC_DATA_67,
    output  wire    [8:0]   ADC_DATA_68,
    output  wire    [8:0]   ADC_DATA_69,
    output  wire    [8:0]   ADC_DATA_70,
    output  wire    [8:0]   ADC_DATA_71,
    output  wire    [8:0]   ADC_DATA_72,
    output  wire    [8:0]   ADC_DATA_73,
    output  wire    [8:0]   ADC_DATA_74,
    output  wire    [8:0]   ADC_DATA_75,
    output  wire    [8:0]   ADC_DATA_76,
    output  wire    [8:0]   ADC_DATA_77,
    output  wire    [8:0]   ADC_DATA_78,
    output  wire    [8:0]   ADC_DATA_79,
    output  wire    [8:0]   ADC_DATA_80,
    output  wire    [8:0]   ADC_DATA_81,
    output  wire    [8:0]   ADC_DATA_82,
    output  wire    [8:0]   ADC_DATA_83,
    output  wire    [8:0]   ADC_DATA_84,
    output  wire    [8:0]   ADC_DATA_85,
    output  wire    [8:0]   ADC_DATA_86,
    output  wire    [8:0]   ADC_DATA_87,
    output  wire    [8:0]   ADC_DATA_88,
    output  wire    [8:0]   ADC_DATA_89,
    output  wire    [8:0]   ADC_DATA_90,
    output  wire    [8:0]   ADC_DATA_91,
    output  wire    [8:0]   ADC_DATA_92,
    output  wire    [8:0]   ADC_DATA_93,
    output  wire    [8:0]   ADC_DATA_94,
    output  wire    [8:0]   ADC_DATA_95,
    output  wire    [8:0]   ADC48_DATA_0,
    output  wire    [8:0]   ADC48_DATA_1,
    output  wire    [8:0]   ADC48_DATA_2,
    output  wire    [8:0]   ADC48_DATA_3,
    output  wire    [8:0]   ADC48_DATA_4,
    output  wire    [8:0]   ADC48_DATA_5,
    output  wire    [8:0]   ADC48_DATA_6,
    output  wire    [8:0]   ADC48_DATA_7,
    output  wire    [8:0]   ADC48_DATA_8,
    output  wire    [8:0]   ADC48_DATA_9,
    output  wire    [8:0]   ADC48_DATA_10,
    output  wire    [8:0]   ADC48_DATA_11,
    output  wire    [8:0]   ADC48_DATA_12,
    output  wire    [8:0]   ADC48_DATA_13,
    output  wire    [8:0]   ADC48_DATA_14,
    output  wire    [8:0]   ADC48_DATA_15,
    output  wire    [8:0]   ADC48_DATA_16,
    output  wire    [8:0]   ADC48_DATA_17,
    output  wire    [8:0]   ADC48_DATA_18,
    output  wire    [8:0]   ADC48_DATA_19,
    output  wire    [8:0]   ADC48_DATA_20,
    output  wire    [8:0]   ADC48_DATA_21,
    output  wire    [8:0]   ADC48_DATA_22,
    output  wire    [8:0]   ADC48_DATA_23,
    output  wire    [8:0]   ADC48_DATA_24,
    output  wire    [8:0]   ADC48_DATA_25,
    output  wire    [8:0]   ADC48_DATA_26,
    output  wire    [8:0]   ADC48_DATA_27,
    output  wire    [8:0]   ADC48_DATA_28,
    output  wire    [8:0]   ADC48_DATA_29,
    output  wire    [8:0]   ADC48_DATA_30,
    output  wire    [8:0]   ADC48_DATA_31,
    output  wire    [8:0]   ADC48_DATA_32,
    output  wire    [8:0]   ADC48_DATA_33,
    output  wire    [8:0]   ADC48_DATA_34,
    output  wire    [8:0]   ADC48_DATA_35,
    output  wire    [8:0]   ADC48_DATA_36,
    output  wire    [8:0]   ADC48_DATA_37,
    output  wire    [8:0]   ADC48_DATA_38,
    output  wire    [8:0]   ADC48_DATA_39,
    output  wire    [8:0]   ADC48_DATA_40,
    output  wire    [8:0]   ADC48_DATA_41,
    output  wire    [8:0]   ADC48_DATA_42,
    output  wire    [8:0]   ADC48_DATA_43,
    output  wire    [8:0]   ADC48_DATA_44,
    output  wire    [8:0]   ADC48_DATA_45,
    output  wire    [8:0]   ADC48_DATA_46,
    output  wire    [8:0]   ADC48_DATA_47
);
`ifdef JL_SYNTHESIS
`else
    localparam SIZE = 1 << WIDTH;
    localparam real PI = 3.14159265358979323846;
    localparam channel = 8'h60; // ADC_TI96

    reg clk;
    reg reset=0;

    reg [8:0]   phase = 0;

    real sine_lut [0:SIZE-1];
    real sine_wave;

    reg clk_500M;
    reg clk_200M;
    reg clk_500M_ti48;
    reg clk_500M_ti96;

    reg [4:0]   count_500M;
    reg [5:0]   count_200M;

    reg         adcti48_en;
    reg         adcti96_en;

    integer k;
    integer num_48;
    integer num_96;
    integer k_48;
    integer k_96;

    reg [8:0]   vd;
    reg [8:0]   vd_ti48 [0:47];
    reg [8:0]   vd_ti96 [0:95];

    reg [8:0]   vd_ti48_tmp [0:47];
    reg [8:0]   vd_ti96_tmp [0:95];

    real sampler;
    real unconverted;

    initial begin
        clk = 0;
        forever
        begin
            #2.08 clk = ~clk;
        end
    end

    initial begin
        integer i;
        for (i=0;i<SIZE;i=i+1) begin
            sine_lut[i] = 0.5 * $sin(2 * PI * i / SIZE);
        end
        phase <= 0;
        count_500M <= 0;
        count_200M <= 0;
        clk_500M <= 0;
        clk_200M <= 0;

        adcti48_en <= 1'b1; // 1--open adcti48
        adcti96_en <= 1'b1; // 1--open adcti96
    end

    always @(posedge clk) begin
        if (count_500M == (5'b11000-1)) begin
            count_500M <= 0;
            clk_500M <= ~clk_500M;
        end
        else begin
            count_500M <= count_500M + 1;
        end
        if (adcti48_en==1'b1) begin clk_500M_ti48 <= ~clk_500M; end
        if (adcti96_en==1'b1) begin clk_500M_ti96 <= ~clk_500M; end
        if (count_200M == (6'b111100-1)) begin
            count_200M <= 0;
            clk_200M <= ~clk_200M;
        end
        else begin
            count_200M <= count_200M + 1;
        end
    end

    always @(posedge clk or posedge reset or negedge clk) begin
        if (reset)
            phase <= 0;
        else
            phase <= phase + 1;
    end

    // sine wave
    always @(posedge clk or posedge reset or negedge clk) begin
        sampler = sine_wave;
        unconverted = sampler;
        for (k=8;k>=0;k=k-1) begin
            if (unconverted > 0) begin
                vd[k] = 1'b1;
                unconverted = unconverted - 0.502*(2**k)/512;
            end
            else begin
                vd[k] = 1'b0;
                unconverted = unconverted + 0.502*(2**k)/512;
            end
        end
        if (adcti96_en == 1'b1) begin
            vd_ti96_tmp[num_96] <= vd;
        end
        num_96 = num_96 + 1;
    end

    always @(posedge clk or posedge reset) begin
        if (adcti48_en == 1'b1) begin
            vd_ti48_tmp[num_48] <= vd;
        end
        num_48 = num_48 + 1;
    end

    always @(posedge clk_500M) begin
        num_96=0;
        num_48=0;
        for (k_96=0;k_96<96;k_96=k_96+1) begin
            vd_ti96[k_96] <= vd_ti96_tmp[k_96];
        end

        for (k_48=0;k_48<48;k_48=k_48+1) begin
            vd_ti48[k_48] <= vd_ti48_tmp[k_48];
        end
    end

    assign ADC_CLK500M = clk_500M_ti96;
    assign ADC48_CLK500M = clk_500M_ti48;
    assign CLK200M = clk_200M;

    assign sine_wave = sine_lut[phase];

    assign ADC_DATA_0  = vd_ti96[0];
    assign ADC_DATA_1  = vd_ti96[1];
    assign ADC_DATA_2  = vd_ti96[2];
    assign ADC_DATA_3  = vd_ti96[3];
    assign ADC_DATA_4  = vd_ti96[4];
    assign ADC_DATA_5  = vd_ti96[5];
    assign ADC_DATA_6  = vd_ti96[6];
    assign ADC_DATA_7  = vd_ti96[7];
    assign ADC_DATA_8  = vd_ti96[8];
    assign ADC_DATA_9  = vd_ti96[9];
    assign ADC_DATA_10 = vd_ti96[10];
    assign ADC_DATA_11 = vd_ti96[11];
    assign ADC_DATA_12 = vd_ti96[12];
    assign ADC_DATA_13 = vd_ti96[13];
    assign ADC_DATA_14 = vd_ti96[14];
    assign ADC_DATA_15 = vd_ti96[15];
    assign ADC_DATA_16 = vd_ti96[16];
    assign ADC_DATA_17 = vd_ti96[17];
    assign ADC_DATA_18 = vd_ti96[18];
    assign ADC_DATA_19 = vd_ti96[19];
    assign ADC_DATA_20 = vd_ti96[20];
    assign ADC_DATA_21 = vd_ti96[21];
    assign ADC_DATA_22 = vd_ti96[22];
    assign ADC_DATA_23 = vd_ti96[23];
    assign ADC_DATA_24 = vd_ti96[24];
    assign ADC_DATA_25 = vd_ti96[25];
    assign ADC_DATA_26 = vd_ti96[26];
    assign ADC_DATA_27 = vd_ti96[27];
    assign ADC_DATA_28 = vd_ti96[28];
    assign ADC_DATA_29 = vd_ti96[29];
    assign ADC_DATA_30 = vd_ti96[30];
    assign ADC_DATA_31 = vd_ti96[31];
    assign ADC_DATA_32 = vd_ti96[32];
    assign ADC_DATA_33 = vd_ti96[33];
    assign ADC_DATA_34 = vd_ti96[34];
    assign ADC_DATA_35 = vd_ti96[35];
    assign ADC_DATA_36 = vd_ti96[36];
    assign ADC_DATA_37 = vd_ti96[37];
    assign ADC_DATA_38 = vd_ti96[38];
    assign ADC_DATA_39 = vd_ti96[39];
    assign ADC_DATA_40 = vd_ti96[40];
    assign ADC_DATA_41 = vd_ti96[41];
    assign ADC_DATA_42 = vd_ti96[42];
    assign ADC_DATA_43 = vd_ti96[43];
    assign ADC_DATA_44 = vd_ti96[44];
    assign ADC_DATA_45 = vd_ti96[45];
    assign ADC_DATA_46 = vd_ti96[46];
    assign ADC_DATA_47 = vd_ti96[47];
    assign ADC_DATA_48 = vd_ti96[48];
    assign ADC_DATA_49 = vd_ti96[49];
    assign ADC_DATA_50 = vd_ti96[50];
    assign ADC_DATA_51 = vd_ti96[51];
    assign ADC_DATA_52 = vd_ti96[52];
    assign ADC_DATA_53 = vd_ti96[53];
    assign ADC_DATA_54 = vd_ti96[54];
    assign ADC_DATA_55 = vd_ti96[55];
    assign ADC_DATA_56 = vd_ti96[56];
    assign ADC_DATA_57 = vd_ti96[57];
    assign ADC_DATA_58 = vd_ti96[58];
    assign ADC_DATA_59 = vd_ti96[59];
    assign ADC_DATA_60 = vd_ti96[60];
    assign ADC_DATA_61 = vd_ti96[61];
    assign ADC_DATA_62 = vd_ti96[62];
    assign ADC_DATA_63 = vd_ti96[63];
    assign ADC_DATA_64 = vd_ti96[64];
    assign ADC_DATA_65 = vd_ti96[65];
    assign ADC_DATA_66 = vd_ti96[66];
    assign ADC_DATA_67 = vd_ti96[67];
    assign ADC_DATA_68 = vd_ti96[68];
    assign ADC_DATA_69 = vd_ti96[69];
    assign ADC_DATA_70 = vd_ti96[70];
    assign ADC_DATA_71 = vd_ti96[71];
    assign ADC_DATA_72 = vd_ti96[72];
    assign ADC_DATA_73 = vd_ti96[73];
    assign ADC_DATA_74 = vd_ti96[74];
    assign ADC_DATA_75 = vd_ti96[75];
    assign ADC_DATA_76 = vd_ti96[76];
    assign ADC_DATA_77 = vd_ti96[77];
    assign ADC_DATA_78 = vd_ti96[78];
    assign ADC_DATA_79 = vd_ti96[79];
    assign ADC_DATA_80 = vd_ti96[80];
    assign ADC_DATA_81 = vd_ti96[81];
    assign ADC_DATA_82 = vd_ti96[82];
    assign ADC_DATA_83 = vd_ti96[83];
    assign ADC_DATA_84 = vd_ti96[84];
    assign ADC_DATA_85 = vd_ti96[85];
    assign ADC_DATA_86 = vd_ti96[86];
    assign ADC_DATA_87 = vd_ti96[87];
    assign ADC_DATA_88 = vd_ti96[88];
    assign ADC_DATA_89 = vd_ti96[89];
    assign ADC_DATA_90 = vd_ti96[90];
    assign ADC_DATA_91 = vd_ti96[91];
    assign ADC_DATA_92 = vd_ti96[92];
    assign ADC_DATA_93 = vd_ti96[93];
    assign ADC_DATA_94 = vd_ti96[94];
    assign ADC_DATA_95 = vd_ti96[95];

    assign ADC48_DATA_0  = vd_ti48[0];
    assign ADC48_DATA_1  = vd_ti48[1];
    assign ADC48_DATA_2  = vd_ti48[2];
    assign ADC48_DATA_3  = vd_ti48[3];
    assign ADC48_DATA_4  = vd_ti48[4];
    assign ADC48_DATA_5  = vd_ti48[5];
    assign ADC48_DATA_6  = vd_ti48[6];
    assign ADC48_DATA_7  = vd_ti48[7];
    assign ADC48_DATA_8  = vd_ti48[8];
    assign ADC48_DATA_9  = vd_ti48[9];
    assign ADC48_DATA_10 = vd_ti48[10];
    assign ADC48_DATA_11 = vd_ti48[11];
    assign ADC48_DATA_12 = vd_ti48[12];
    assign ADC48_DATA_13 = vd_ti48[13];
    assign ADC48_DATA_14 = vd_ti48[14];
    assign ADC48_DATA_15 = vd_ti48[15];
    assign ADC48_DATA_16 = vd_ti48[16];
    assign ADC48_DATA_17 = vd_ti48[17];
    assign ADC48_DATA_18 = vd_ti48[18];
    assign ADC48_DATA_19 = vd_ti48[19];
    assign ADC48_DATA_20 = vd_ti48[20];
    assign ADC48_DATA_21 = vd_ti48[21];
    assign ADC48_DATA_22 = vd_ti48[22];
    assign ADC48_DATA_23 = vd_ti48[23];
    assign ADC48_DATA_24 = vd_ti48[24];
    assign ADC48_DATA_25 = vd_ti48[25];
    assign ADC48_DATA_26 = vd_ti48[26];
    assign ADC48_DATA_27 = vd_ti48[27];
    assign ADC48_DATA_28 = vd_ti48[28];
    assign ADC48_DATA_29 = vd_ti48[29];
    assign ADC48_DATA_30 = vd_ti48[30];
    assign ADC48_DATA_31 = vd_ti48[31];
    assign ADC48_DATA_32 = vd_ti48[32];
    assign ADC48_DATA_33 = vd_ti48[33];
    assign ADC48_DATA_34 = vd_ti48[34];
    assign ADC48_DATA_35 = vd_ti48[35];
    assign ADC48_DATA_36 = vd_ti48[36];
    assign ADC48_DATA_37 = vd_ti48[37];
    assign ADC48_DATA_38 = vd_ti48[38];
    assign ADC48_DATA_39 = vd_ti48[39];
    assign ADC48_DATA_40 = vd_ti48[40];
    assign ADC48_DATA_41 = vd_ti48[41];
    assign ADC48_DATA_42 = vd_ti48[42];
    assign ADC48_DATA_43 = vd_ti48[43];
    assign ADC48_DATA_44 = vd_ti48[44];
    assign ADC48_DATA_45 = vd_ti48[45];
    assign ADC48_DATA_46 = vd_ti48[46];
    assign ADC48_DATA_47 = vd_ti48[47];
`endif
endmodule
