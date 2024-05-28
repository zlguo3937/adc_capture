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
//  2024-05-06    zlguo         1.0         gen_read_logic_mdio
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module gen_read_logic_mdio
(
    // Mdio read
    input   wire            clk,
    input   wire            rstn,
    input   wire            rf_96path_en,
    input   wire    [6:0]   rf_mdio_data_sel,
    input   wire    [14:0]  rf_mdio_memory_addr,

    input   wire            mdio_read_en,

    input   wire    [35:0]  mdio_din_0,
    input   wire    [35:0]  mdio_din_1,
    input   wire    [35:0]  mdio_din_2,
    input   wire    [35:0]  mdio_din_3,
    input   wire    [35:0]  mdio_din_4,
    input   wire    [35:0]  mdio_din_5,
    input   wire    [35:0]  mdio_din_6,
    input   wire    [35:0]  mdio_din_7,
    input   wire    [35:0]  mdio_din_8,
    input   wire    [35:0]  mdio_din_9,
    input   wire    [35:0]  mdio_din_10,
    input   wire    [35:0]  mdio_din_11,
    input   wire    [35:0]  mdio_din_12,
    input   wire    [35:0]  mdio_din_13,
    input   wire    [35:0]  mdio_din_14,
    input   wire    [35:0]  mdio_din_15,
    input   wire    [35:0]  mdio_din_16,
    input   wire    [35:0]  mdio_din_17,
    input   wire    [35:0]  mdio_din_18,
    input   wire    [35:0]  mdio_din_19,
    input   wire    [35:0]  mdio_din_20,
    input   wire    [35:0]  mdio_din_21,
    input   wire    [35:0]  mdio_din_22,
    input   wire    [35:0]  mdio_din_23,

    output  wire            mdio_chip_en_0,
    output  wire            mdio_chip_en_1,
    output  wire            mdio_chip_en_2,
    output  wire            mdio_chip_en_3,
    output  wire            mdio_chip_en_4,
    output  wire            mdio_chip_en_5,
    output  wire            mdio_chip_en_6,
    output  wire            mdio_chip_en_7,
    output  wire            mdio_chip_en_8,
    output  wire            mdio_chip_en_9,
    output  wire            mdio_chip_en_10,
    output  wire            mdio_chip_en_11,
    output  wire            mdio_chip_en_12,
    output  wire            mdio_chip_en_13,
    output  wire            mdio_chip_en_14,
    output  wire            mdio_chip_en_15,
    output  wire            mdio_chip_en_16,
    output  wire            mdio_chip_en_17,
    output  wire            mdio_chip_en_18,
    output  wire            mdio_chip_en_19,
    output  wire            mdio_chip_en_20,
    output  wire            mdio_chip_en_21,
    output  wire            mdio_chip_en_22,
    output  wire            mdio_chip_en_23,

    output  wire    [14:0]  mdio_addr,

    output  reg     [8:0]   rf_mdio_pkt_data
);

    reg [8:0]       mdio_pkt_data;

    reg [23:0]      mdio_rd_chip_en;
    reg [24*15-1:0] mdio_rd_raddr;

    genvar i;
    generate
        for (i=0;i<24;i=i+1) begin: GEN_CHIP_EN
            always @(posedge clk or negedge rstn) begin
                if (!rstn)
                    mdio_rd_chip_en[i] <= 1'b0;
                else if (mdio_read_en)
                    mdio_rd_chip_en[i] <= (rf_mdio_data_sel/4) == i;
                else
                    mdio_rd_chip_en[i] <= 1'b0;
            end
        end
    endgenerate

    assign mdio_chip_en_0  = mdio_rd_chip_en[0];
    assign mdio_chip_en_1  = mdio_rd_chip_en[1];
    assign mdio_chip_en_2  = mdio_rd_chip_en[2];
    assign mdio_chip_en_3  = mdio_rd_chip_en[3];
    assign mdio_chip_en_4  = mdio_rd_chip_en[4];
    assign mdio_chip_en_5  = mdio_rd_chip_en[5];
    assign mdio_chip_en_6  = mdio_rd_chip_en[6];
    assign mdio_chip_en_7  = mdio_rd_chip_en[7];
    assign mdio_chip_en_8  = mdio_rd_chip_en[8];
    assign mdio_chip_en_9  = mdio_rd_chip_en[9];
    assign mdio_chip_en_10 = mdio_rd_chip_en[10];
    assign mdio_chip_en_11 = mdio_rd_chip_en[11];
    assign mdio_chip_en_12 = mdio_rd_chip_en[12];
    assign mdio_chip_en_13 = mdio_rd_chip_en[13];
    assign mdio_chip_en_14 = mdio_rd_chip_en[14];
    assign mdio_chip_en_15 = mdio_rd_chip_en[15];
    assign mdio_chip_en_16 = mdio_rd_chip_en[16];
    assign mdio_chip_en_17 = mdio_rd_chip_en[17];
    assign mdio_chip_en_18 = mdio_rd_chip_en[18];
    assign mdio_chip_en_19 = mdio_rd_chip_en[19];
    assign mdio_chip_en_20 = mdio_rd_chip_en[20];
    assign mdio_chip_en_21 = mdio_rd_chip_en[21];
    assign mdio_chip_en_22 = mdio_rd_chip_en[22];
    assign mdio_chip_en_23 = mdio_rd_chip_en[23];

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            mdio_rd_raddr <= 15'h0;
        else if (mdio_read_en)
            mdio_rd_raddr <= rf_mdio_memory_addr;
        else
            mdio_rd_raddr <= 15'h0;
    end

    assign mdio_addr = mdio_rd_raddr;

    always @(*) begin
        case(rf_mdio_data_sel)
            0:  mdio_pkt_data = mdio_din_0[8:0];  1:  mdio_pkt_data = mdio_din_0[17:9];  2:  mdio_pkt_data = mdio_din_0[26:18];  3:  mdio_pkt_data = mdio_din_0[35:27]; 
            4:  mdio_pkt_data = mdio_din_1[8:0];  5:  mdio_pkt_data = mdio_din_1[17:9];  6:  mdio_pkt_data = mdio_din_1[26:18];  7:  mdio_pkt_data = mdio_din_1[35:27]; 
            8:  mdio_pkt_data = mdio_din_2[8:0];  9:  mdio_pkt_data = mdio_din_2[17:9];  10: mdio_pkt_data = mdio_din_2[26:18];  11: mdio_pkt_data = mdio_din_2[35:27]; 
            12: mdio_pkt_data = mdio_din_3[8:0];  13: mdio_pkt_data = mdio_din_3[17:9];  14: mdio_pkt_data = mdio_din_3[26:18];  15: mdio_pkt_data = mdio_din_3[35:27]; 
            16: mdio_pkt_data = mdio_din_4[8:0];  17: mdio_pkt_data = mdio_din_4[17:9];  18: mdio_pkt_data = mdio_din_4[26:18];  19: mdio_pkt_data = mdio_din_4[35:27]; 
            20: mdio_pkt_data = mdio_din_5[8:0];  21: mdio_pkt_data = mdio_din_5[17:9];  22: mdio_pkt_data = mdio_din_5[26:18];  23: mdio_pkt_data = mdio_din_5[35:27]; 
            24: mdio_pkt_data = mdio_din_6[8:0];  25: mdio_pkt_data = mdio_din_6[17:9];  26: mdio_pkt_data = mdio_din_6[26:18];  27: mdio_pkt_data = mdio_din_6[35:27]; 
            28: mdio_pkt_data = mdio_din_7[8:0];  29: mdio_pkt_data = mdio_din_7[17:9];  30: mdio_pkt_data = mdio_din_7[26:18];  31: mdio_pkt_data = mdio_din_7[35:27]; 
            32: mdio_pkt_data = mdio_din_8[8:0];  33: mdio_pkt_data = mdio_din_8[17:9];  34: mdio_pkt_data = mdio_din_8[26:18];  35: mdio_pkt_data = mdio_din_8[35:27]; 
            36: mdio_pkt_data = mdio_din_9[8:0];  37: mdio_pkt_data = mdio_din_9[17:9];  38: mdio_pkt_data = mdio_din_9[26:18];  39: mdio_pkt_data = mdio_din_9[35:27]; 
            40: mdio_pkt_data = mdio_din_10[8:0]; 41: mdio_pkt_data = mdio_din_10[17:9]; 42: mdio_pkt_data = mdio_din_10[26:18]; 43: mdio_pkt_data = mdio_din_10[35:27];
            44: mdio_pkt_data = mdio_din_11[8:0]; 45: mdio_pkt_data = mdio_din_11[17:9]; 46: mdio_pkt_data = mdio_din_11[26:18]; 47: mdio_pkt_data = mdio_din_11[35:27];
            48: mdio_pkt_data = mdio_din_12[8:0]; 49: mdio_pkt_data = mdio_din_12[17:9]; 50: mdio_pkt_data = mdio_din_12[26:18]; 51: mdio_pkt_data = mdio_din_12[35:27];
            52: mdio_pkt_data = mdio_din_13[8:0]; 53: mdio_pkt_data = mdio_din_13[17:9]; 54: mdio_pkt_data = mdio_din_13[26:18]; 55: mdio_pkt_data = mdio_din_13[35:27];
            56: mdio_pkt_data = mdio_din_14[8:0]; 57: mdio_pkt_data = mdio_din_14[17:9]; 58: mdio_pkt_data = mdio_din_14[26:18]; 59: mdio_pkt_data = mdio_din_14[35:27];
            60: mdio_pkt_data = mdio_din_15[8:0]; 61: mdio_pkt_data = mdio_din_15[17:9]; 62: mdio_pkt_data = mdio_din_15[26:18]; 63: mdio_pkt_data = mdio_din_15[35:27];
            64: mdio_pkt_data = mdio_din_16[8:0]; 65: mdio_pkt_data = mdio_din_16[17:9]; 66: mdio_pkt_data = mdio_din_16[26:18]; 67: mdio_pkt_data = mdio_din_16[35:27];
            68: mdio_pkt_data = mdio_din_17[8:0]; 69: mdio_pkt_data = mdio_din_17[17:9]; 70: mdio_pkt_data = mdio_din_17[26:18]; 71: mdio_pkt_data = mdio_din_17[35:27];
            72: mdio_pkt_data = mdio_din_18[8:0]; 73: mdio_pkt_data = mdio_din_18[17:9]; 74: mdio_pkt_data = mdio_din_18[26:18]; 75: mdio_pkt_data = mdio_din_18[35:27];
            76: mdio_pkt_data = mdio_din_19[8:0]; 77: mdio_pkt_data = mdio_din_19[17:9]; 78: mdio_pkt_data = mdio_din_19[26:18]; 79: mdio_pkt_data = mdio_din_19[35:27];
            80: mdio_pkt_data = mdio_din_20[8:0]; 81: mdio_pkt_data = mdio_din_20[17:9]; 82: mdio_pkt_data = mdio_din_20[26:18]; 83: mdio_pkt_data = mdio_din_20[35:27];
            84: mdio_pkt_data = mdio_din_21[8:0]; 85: mdio_pkt_data = mdio_din_21[17:9]; 86: mdio_pkt_data = mdio_din_21[26:18]; 87: mdio_pkt_data = mdio_din_21[35:27];
            88: mdio_pkt_data = mdio_din_22[8:0]; 89: mdio_pkt_data = mdio_din_22[17:9]; 90: mdio_pkt_data = mdio_din_22[26:18]; 91: mdio_pkt_data = mdio_din_22[35:27];
            92: mdio_pkt_data = mdio_din_23[8:0]; 93: mdio_pkt_data = mdio_din_23[17:9]; 94: mdio_pkt_data = mdio_din_23[26:18]; 95: mdio_pkt_data = mdio_din_23[35:27];
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            rf_mdio_pkt_data <= 9'h0;
        else if (mdio_read_en)
            rf_mdio_pkt_data <= mdio_pkt_data;
        else
            rf_mdio_pkt_data <= 9'h0;
    end

endmodule
