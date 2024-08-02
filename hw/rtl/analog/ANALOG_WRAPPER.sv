`timescale 10ps/10ps

module ANALOG_WRAPPER
#(
    parameter WIDTH = 9
)
(
    output  wire            SAR_200M_REG_CLK,
    output  wire            HSAR_CLK_ASSO,
    output  wire            SAR_CLK_ASSO,

    output  wire    [8:0]   HSAR_DATA_0_0,
    output  wire    [8:0]   HSAR_DATA_0_1,
    output  wire    [8:0]   HSAR_DATA_0_2,
    output  wire    [8:0]   HSAR_DATA_0_3,
    output  wire    [8:0]   HSAR_DATA_0_4,
    output  wire    [8:0]   HSAR_DATA_0_5,
    output  wire    [8:0]   HSAR_DATA_0_6,
    output  wire    [8:0]   HSAR_DATA_0_7,
    output  wire    [8:0]   HSAR_DATA_0_8,
    output  wire    [8:0]   HSAR_DATA_0_9,
    output  wire    [8:0]   HSAR_DATA_1_0,
    output  wire    [8:0]   HSAR_DATA_1_1,
    output  wire    [8:0]   HSAR_DATA_1_2,
    output  wire    [8:0]   HSAR_DATA_1_3,
    output  wire    [8:0]   HSAR_DATA_1_4,
    output  wire    [8:0]   HSAR_DATA_1_5,
    output  wire    [8:0]   HSAR_DATA_1_6,
    output  wire    [8:0]   HSAR_DATA_1_7,
    output  wire    [8:0]   HSAR_DATA_1_8,
    output  wire    [8:0]   HSAR_DATA_1_9,
    output  wire    [8:0]   HSAR_DATA_2_0,
    output  wire    [8:0]   HSAR_DATA_2_1,
    output  wire    [8:0]   HSAR_DATA_2_2,
    output  wire    [8:0]   HSAR_DATA_2_3,
    output  wire    [8:0]   HSAR_DATA_2_4,
    output  wire    [8:0]   HSAR_DATA_2_5,
    output  wire    [8:0]   HSAR_DATA_2_6,
    output  wire    [8:0]   HSAR_DATA_2_7,
    output  wire    [8:0]   HSAR_DATA_2_8,
    output  wire    [8:0]   HSAR_DATA_2_9,
    output  wire    [8:0]   HSAR_DATA_3_0,
    output  wire    [8:0]   HSAR_DATA_3_1,
    output  wire    [8:0]   HSAR_DATA_3_2,
    output  wire    [8:0]   HSAR_DATA_3_3,
    output  wire    [8:0]   HSAR_DATA_3_4,
    output  wire    [8:0]   HSAR_DATA_3_5,
    output  wire    [8:0]   HSAR_DATA_3_6,
    output  wire    [8:0]   HSAR_DATA_3_7,
    output  wire    [8:0]   HSAR_DATA_3_8,
    output  wire    [8:0]   HSAR_DATA_3_9,
    output  wire    [8:0]   HSAR_DATA_4_0,
    output  wire    [8:0]   HSAR_DATA_4_1,
    output  wire    [8:0]   HSAR_DATA_4_2,
    output  wire    [8:0]   HSAR_DATA_4_3,
    output  wire    [8:0]   HSAR_DATA_4_4,
    output  wire    [8:0]   HSAR_DATA_4_5,
    output  wire    [8:0]   HSAR_DATA_4_6,
    output  wire    [8:0]   HSAR_DATA_4_7,
    output  wire    [8:0]   HSAR_DATA_4_8,
    output  wire    [8:0]   HSAR_DATA_4_9,
    output  wire    [8:0]   HSAR_DATA_5_0,
    output  wire    [8:0]   HSAR_DATA_5_1,
    output  wire    [8:0]   HSAR_DATA_5_2,
    output  wire    [8:0]   HSAR_DATA_5_3,
    output  wire    [8:0]   HSAR_DATA_5_4,
    output  wire    [8:0]   HSAR_DATA_5_5,
    output  wire    [8:0]   HSAR_DATA_5_6,
    output  wire    [8:0]   HSAR_DATA_5_7,
    output  wire    [8:0]   HSAR_DATA_5_8,
    output  wire    [8:0]   HSAR_DATA_5_9,
    output  wire    [8:0]   HSAR_DATA_6_0,
    output  wire    [8:0]   HSAR_DATA_6_1,
    output  wire    [8:0]   HSAR_DATA_6_2,
    output  wire    [8:0]   HSAR_DATA_6_3,
    output  wire    [8:0]   HSAR_DATA_6_4,
    output  wire    [8:0]   HSAR_DATA_6_5,
    output  wire    [8:0]   HSAR_DATA_6_6,
    output  wire    [8:0]   HSAR_DATA_6_7,
    output  wire    [8:0]   HSAR_DATA_6_8,
    output  wire    [8:0]   HSAR_DATA_6_9,
    output  wire    [8:0]   HSAR_DATA_7_0,
    output  wire    [8:0]   HSAR_DATA_7_1,
    output  wire    [8:0]   HSAR_DATA_7_2,
    output  wire    [8:0]   HSAR_DATA_7_3,
    output  wire    [8:0]   HSAR_DATA_7_4,
    output  wire    [8:0]   HSAR_DATA_7_5,
    output  wire    [8:0]   HSAR_DATA_7_6,
    output  wire    [8:0]   HSAR_DATA_7_7,
    output  wire    [8:0]   HSAR_DATA_7_8,
    output  wire    [8:0]   HSAR_DATA_7_9,
    output  wire    [8:0]   HSAR_DATA_8_0,
    output  wire    [8:0]   HSAR_DATA_8_1,
    output  wire    [8:0]   HSAR_DATA_8_2,
    output  wire    [8:0]   HSAR_DATA_8_3,
    output  wire    [8:0]   HSAR_DATA_8_4,
    output  wire    [8:0]   HSAR_DATA_8_5,
    output  wire    [8:0]   HSAR_DATA_8_6,
    output  wire    [8:0]   HSAR_DATA_8_7,
    output  wire    [8:0]   HSAR_DATA_8_8,
    output  wire    [8:0]   HSAR_DATA_8_9,
    output  wire    [8:0]   HSAR_DATA_9_0,
    output  wire    [8:0]   HSAR_DATA_9_1,
    output  wire    [8:0]   HSAR_DATA_9_2,
    output  wire    [8:0]   HSAR_DATA_9_3,
    output  wire    [8:0]   HSAR_DATA_9_4,
    output  wire    [8:0]   HSAR_DATA_9_5,
    output  wire    [8:0]   SAR_DATA_0_0,
    output  wire    [8:0]   SAR_DATA_0_1,
    output  wire    [8:0]   SAR_DATA_0_2,
    output  wire    [8:0]   SAR_DATA_0_3,
    output  wire    [8:0]   SAR_DATA_0_4,
    output  wire    [8:0]   SAR_DATA_0_5,
    output  wire    [8:0]   SAR_DATA_0_6,
    output  wire    [8:0]   SAR_DATA_0_7,
    output  wire    [8:0]   SAR_DATA_0_8,
    output  wire    [8:0]   SAR_DATA_0_9,
    output  wire    [8:0]   SAR_DATA_1_0,
    output  wire    [8:0]   SAR_DATA_1_1,
    output  wire    [8:0]   SAR_DATA_1_2,
    output  wire    [8:0]   SAR_DATA_1_3,
    output  wire    [8:0]   SAR_DATA_1_4,
    output  wire    [8:0]   SAR_DATA_1_5,
    output  wire    [8:0]   SAR_DATA_1_6,
    output  wire    [8:0]   SAR_DATA_1_7,
    output  wire    [8:0]   SAR_DATA_1_8,
    output  wire    [8:0]   SAR_DATA_1_9,
    output  wire    [8:0]   SAR_DATA_2_0,
    output  wire    [8:0]   SAR_DATA_2_1,
    output  wire    [8:0]   SAR_DATA_2_2,
    output  wire    [8:0]   SAR_DATA_2_3,
    output  wire    [8:0]   SAR_DATA_2_4,
    output  wire    [8:0]   SAR_DATA_2_5,
    output  wire    [8:0]   SAR_DATA_2_6,
    output  wire    [8:0]   SAR_DATA_2_7,
    output  wire    [8:0]   SAR_DATA_2_8,
    output  wire    [8:0]   SAR_DATA_2_9,
    output  wire    [8:0]   SAR_DATA_3_0,
    output  wire    [8:0]   SAR_DATA_3_1,
    output  wire    [8:0]   SAR_DATA_3_2,
    output  wire    [8:0]   SAR_DATA_3_3,
    output  wire    [8:0]   SAR_DATA_3_4,
    output  wire    [8:0]   SAR_DATA_3_5,
    output  wire    [8:0]   SAR_DATA_3_6,
    output  wire    [8:0]   SAR_DATA_3_7,
    output  wire    [8:0]   SAR_DATA_3_8,
    output  wire    [8:0]   SAR_DATA_3_9,
    output  wire    [8:0]   SAR_DATA_4_0,
    output  wire    [8:0]   SAR_DATA_4_1,
    output  wire    [8:0]   SAR_DATA_4_2,
    output  wire    [8:0]   SAR_DATA_4_3,
    output  wire    [8:0]   SAR_DATA_4_4,
    output  wire    [8:0]   SAR_DATA_4_5,
    output  wire    [8:0]   SAR_DATA_4_6,
    output  wire    [8:0]   SAR_DATA_4_7,

    output  wire    [14:0]  SAR_PVSENSOR_CNT,
    input   wire            BG25M_TEST_EN,
    input   wire            SAR_BUFFER_PD,
    input   wire            SAR_CKBUF_PD,
    input   wire            SAR_CLK_EN,
    input   wire            SAR_DELAY,
    input   wire            SAR_PU_LDOADC,
    input   wire            SAR_PU_SENSOR,
    input   wire            SAR_PVSENSOR_CNT_EN,
    input   wire            SAR_REVERSE,
    input   wire            SAR_RSTN,
    input   wire            SAR_SF_ST1_PD,
    input   wire            SAR_SKEWGEN_EN,
    input   wire            SAR_TEST_EN,
    input   wire            SAR_VREF_PD,
    input   wire    [15:0]  SAR_RESVD1,
    input   wire    [1:0]   SAR_CKBUF_ISEL,
    input   wire    [1:0]   SAR_ISEL,
    input   wire    [1:0]   SAR_REFSEL,
    input   wire    [1:0]   SAR_SF_ST1_ISEL,
    input   wire    [2:0]   BG25M_TEST_SEL,
    input   wire    [2:0]   SAR_CMSEL,
    input   wire    [2:0]   SAR_LDO_ADCSEL,
    input   wire    [2:0]   SAR_LDO_BUFFERSEL,
    input   wire    [2:0]   SAR_LDO_CKSEL,
    input   wire    [2:0]   SAR_TEST_SEL,
    input   wire    [5:0]   SAR_CKCALBUF_DELAY,
    input   wire    [5:0]   SAR_DAC0_COARSE,
    input   wire    [5:0]   SAR_DAC0_FINE,
    input   wire    [5:0]   SAR_DAC1_COARSE,
    input   wire    [5:0]   SAR_DAC1_FINE,
    input   wire    [5:0]   SAR_DAC2_COARSE,
    input   wire    [5:0]   SAR_DAC2_FINE,
    input   wire    [5:0]   SAR_DAC3_COARSE,
    input   wire    [5:0]   SAR_DAC3_FINE,
    input   wire    [5:0]   SAR_DAC4_COARSE,
    input   wire    [5:0]   SAR_DAC4_FINE,
    input   wire    [5:0]   SAR_DAC5_COARSE,
    input   wire    [5:0]   SAR_DAC5_FINE,
    input   wire    [5:0]   SAR_DAC6_COARSE,
    input   wire    [5:0]   SAR_DAC6_FINE,
    input   wire    [5:0]   SAR_DAC7_COARSE,
    input   wire    [5:0]   SAR_DAC7_FINE,

    inout   wire            SAR_VINP      ,
    inout   wire            SAR_VINN      ,
    inout   wire            SAR_CLK_12G_IN,
    inout   wire            SAR_CLK_200M  ,
    inout   wire            SAR_DVDD09    ,
    inout   wire            SAR_AVDD25_BUF,
    inout   wire            SAR_AVDD25_CK ,
    inout   wire            SAR_AVDD25_ADC,
    inout   wire            SAR_AVDD25    ,
    inout   wire            SAR_AGND      ,
    inout   wire            SAR_DVSS      ,
    inout   wire            SAR_ATEST
);
`ifdef SYNTHESIS
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
        for (i=0;i<SIZE;i=i+1) begin: GEN_SINE_LUT
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

    assign HSAR_CLK_ASSO = clk_500M_ti96;
    assign SAR_CLK_ASSO = clk_500M_ti48;
    assign SAR_200M_REG_CLK = clk_200M;

    assign sine_wave = sine_lut[phase];

    assign HSAR_DATA_0_0  = vd_ti96[0];
    assign HSAR_DATA_0_1  = vd_ti96[1];
    assign HSAR_DATA_0_2  = vd_ti96[2];
    assign HSAR_DATA_0_3  = vd_ti96[3];
    assign HSAR_DATA_0_4  = vd_ti96[4];
    assign HSAR_DATA_0_5  = vd_ti96[5];
    assign HSAR_DATA_0_6  = vd_ti96[6];
    assign HSAR_DATA_0_7  = vd_ti96[7];
    assign HSAR_DATA_0_8  = vd_ti96[8];
    assign HSAR_DATA_0_9  = vd_ti96[9];
    assign HSAR_DATA_1_0 = vd_ti96[10];
    assign HSAR_DATA_1_1 = vd_ti96[11];
    assign HSAR_DATA_1_2 = vd_ti96[12];
    assign HSAR_DATA_1_3 = vd_ti96[13];
    assign HSAR_DATA_1_4 = vd_ti96[14];
    assign HSAR_DATA_1_5 = vd_ti96[15];
    assign HSAR_DATA_1_6 = vd_ti96[16];
    assign HSAR_DATA_1_7 = vd_ti96[17];
    assign HSAR_DATA_1_8 = vd_ti96[18];
    assign HSAR_DATA_1_9 = vd_ti96[19];
    assign HSAR_DATA_2_0 = vd_ti96[20];
    assign HSAR_DATA_2_1 = vd_ti96[21];
    assign HSAR_DATA_2_2 = vd_ti96[22];
    assign HSAR_DATA_2_3 = vd_ti96[23];
    assign HSAR_DATA_2_4 = vd_ti96[24];
    assign HSAR_DATA_2_5 = vd_ti96[25];
    assign HSAR_DATA_2_6 = vd_ti96[26];
    assign HSAR_DATA_2_7 = vd_ti96[27];
    assign HSAR_DATA_2_8 = vd_ti96[28];
    assign HSAR_DATA_2_9 = vd_ti96[29];
    assign HSAR_DATA_3_0 = vd_ti96[30];
    assign HSAR_DATA_3_1 = vd_ti96[31];
    assign HSAR_DATA_3_2 = vd_ti96[32];
    assign HSAR_DATA_3_3 = vd_ti96[33];
    assign HSAR_DATA_3_4 = vd_ti96[34];
    assign HSAR_DATA_3_5 = vd_ti96[35];
    assign HSAR_DATA_3_6 = vd_ti96[36];
    assign HSAR_DATA_3_7 = vd_ti96[37];
    assign HSAR_DATA_3_8 = vd_ti96[38];
    assign HSAR_DATA_3_9 = vd_ti96[39];
    assign HSAR_DATA_4_0 = vd_ti96[40];
    assign HSAR_DATA_4_1 = vd_ti96[41];
    assign HSAR_DATA_4_2 = vd_ti96[42];
    assign HSAR_DATA_4_3 = vd_ti96[43];
    assign HSAR_DATA_4_4 = vd_ti96[44];
    assign HSAR_DATA_4_5 = vd_ti96[45];
    assign HSAR_DATA_4_6 = vd_ti96[46];
    assign HSAR_DATA_4_7 = vd_ti96[47];
    assign HSAR_DATA_4_8 = vd_ti96[48];
    assign HSAR_DATA_4_9 = vd_ti96[49];
    assign HSAR_DATA_5_0 = vd_ti96[50];
    assign HSAR_DATA_5_1 = vd_ti96[51];
    assign HSAR_DATA_5_2 = vd_ti96[52];
    assign HSAR_DATA_5_3 = vd_ti96[53];
    assign HSAR_DATA_5_4 = vd_ti96[54];
    assign HSAR_DATA_5_5 = vd_ti96[55];
    assign HSAR_DATA_5_6 = vd_ti96[56];
    assign HSAR_DATA_5_7 = vd_ti96[57];
    assign HSAR_DATA_5_8 = vd_ti96[58];
    assign HSAR_DATA_5_9 = vd_ti96[59];
    assign HSAR_DATA_6_0 = vd_ti96[60];
    assign HSAR_DATA_6_1 = vd_ti96[61];
    assign HSAR_DATA_6_2 = vd_ti96[62];
    assign HSAR_DATA_6_3 = vd_ti96[63];
    assign HSAR_DATA_6_4 = vd_ti96[64];
    assign HSAR_DATA_6_5 = vd_ti96[65];
    assign HSAR_DATA_6_6 = vd_ti96[66];
    assign HSAR_DATA_6_7 = vd_ti96[67];
    assign HSAR_DATA_6_8 = vd_ti96[68];
    assign HSAR_DATA_6_9 = vd_ti96[69];
    assign HSAR_DATA_7_0 = vd_ti96[70];
    assign HSAR_DATA_7_1 = vd_ti96[71];
    assign HSAR_DATA_7_2 = vd_ti96[72];
    assign HSAR_DATA_7_3 = vd_ti96[73];
    assign HSAR_DATA_7_4 = vd_ti96[74];
    assign HSAR_DATA_7_5 = vd_ti96[75];
    assign HSAR_DATA_7_6 = vd_ti96[76];
    assign HSAR_DATA_7_7 = vd_ti96[77];
    assign HSAR_DATA_7_8 = vd_ti96[78];
    assign HSAR_DATA_7_9 = vd_ti96[79];
    assign HSAR_DATA_8_0 = vd_ti96[80];
    assign HSAR_DATA_8_1 = vd_ti96[81];
    assign HSAR_DATA_8_2 = vd_ti96[82];
    assign HSAR_DATA_8_3 = vd_ti96[83];
    assign HSAR_DATA_8_4 = vd_ti96[84];
    assign HSAR_DATA_8_5 = vd_ti96[85];
    assign HSAR_DATA_8_6 = vd_ti96[86];
    assign HSAR_DATA_8_7 = vd_ti96[87];
    assign HSAR_DATA_8_8 = vd_ti96[88];
    assign HSAR_DATA_8_9 = vd_ti96[89];
    assign HSAR_DATA_9_0 = vd_ti96[90];
    assign HSAR_DATA_9_1 = vd_ti96[91];
    assign HSAR_DATA_9_2 = vd_ti96[92];
    assign HSAR_DATA_9_3 = vd_ti96[93];
    assign HSAR_DATA_9_4 = vd_ti96[94];
    assign HSAR_DATA_9_5 = vd_ti96[95];

    assign SAR_DATA_0_0  = vd_ti48[0];
    assign SAR_DATA_0_1  = vd_ti48[1];
    assign SAR_DATA_0_2  = vd_ti48[2];
    assign SAR_DATA_0_3  = vd_ti48[3];
    assign SAR_DATA_0_4  = vd_ti48[4];
    assign SAR_DATA_0_5  = vd_ti48[5];
    assign SAR_DATA_0_6  = vd_ti48[6];
    assign SAR_DATA_0_7  = vd_ti48[7];
    assign SAR_DATA_0_8  = vd_ti48[8];
    assign SAR_DATA_0_9  = vd_ti48[9];
    assign SAR_DATA_1_0 = vd_ti48[10];
    assign SAR_DATA_1_1 = vd_ti48[11];
    assign SAR_DATA_1_2 = vd_ti48[12];
    assign SAR_DATA_1_3 = vd_ti48[13];
    assign SAR_DATA_1_4 = vd_ti48[14];
    assign SAR_DATA_1_5 = vd_ti48[15];
    assign SAR_DATA_1_6 = vd_ti48[16];
    assign SAR_DATA_1_7 = vd_ti48[17];
    assign SAR_DATA_1_8 = vd_ti48[18];
    assign SAR_DATA_1_9 = vd_ti48[19];
    assign SAR_DATA_2_0 = vd_ti48[20];
    assign SAR_DATA_2_1 = vd_ti48[21];
    assign SAR_DATA_2_2 = vd_ti48[22];
    assign SAR_DATA_2_3 = vd_ti48[23];
    assign SAR_DATA_2_4 = vd_ti48[24];
    assign SAR_DATA_2_5 = vd_ti48[25];
    assign SAR_DATA_2_6 = vd_ti48[26];
    assign SAR_DATA_2_7 = vd_ti48[27];
    assign SAR_DATA_2_8 = vd_ti48[28];
    assign SAR_DATA_2_9 = vd_ti48[29];
    assign SAR_DATA_3_0 = vd_ti48[30];
    assign SAR_DATA_3_1 = vd_ti48[31];
    assign SAR_DATA_3_2 = vd_ti48[32];
    assign SAR_DATA_3_3 = vd_ti48[33];
    assign SAR_DATA_3_4 = vd_ti48[34];
    assign SAR_DATA_3_5 = vd_ti48[35];
    assign SAR_DATA_3_6 = vd_ti48[36];
    assign SAR_DATA_3_7 = vd_ti48[37];
    assign SAR_DATA_3_8 = vd_ti48[38];
    assign SAR_DATA_3_9 = vd_ti48[39];
    assign SAR_DATA_4_0 = vd_ti48[40];
    assign SAR_DATA_4_1 = vd_ti48[41];
    assign SAR_DATA_4_2 = vd_ti48[42];
    assign SAR_DATA_4_3 = vd_ti48[43];
    assign SAR_DATA_4_4 = vd_ti48[44];
    assign SAR_DATA_4_5 = vd_ti48[45];
    assign SAR_DATA_4_6 = vd_ti48[46];
    assign SAR_DATA_4_7 = vd_ti48[47];
`endif
endmodule
