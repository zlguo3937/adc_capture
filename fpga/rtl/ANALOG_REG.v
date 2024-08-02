`timescale 1ns/1ns
module ANALOG_REG(

    // Analog register
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
    input   wire    [5:0]   SAR_DAC7_FINE
);

    assign SAR_PVSENSOR_CNT = 15'h1fff;

endmodule
