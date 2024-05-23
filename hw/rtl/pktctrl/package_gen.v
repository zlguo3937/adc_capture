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
//  2024-05-06    zlguo         1.0         package_gen
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module package_gen
(
    output  wire    [35:0]  pkt_gen_data_0,
    output  wire    [35:0]  pkt_gen_data_1,
    output  wire    [35:0]  pkt_gen_data_2,
    output  wire    [35:0]  pkt_gen_data_3,
    output  wire    [35:0]  pkt_gen_data_4,
    output  wire    [35:0]  pkt_gen_data_5,
    output  wire    [35:0]  pkt_gen_data_6,
    output  wire    [35:0]  pkt_gen_data_7,
    output  wire    [35:0]  pkt_gen_data_8,
    output  wire    [35:0]  pkt_gen_data_9,
    output  wire    [35:0]  pkt_gen_data_10,
    output  wire    [35:0]  pkt_gen_data_11,
    output  wire    [35:0]  pkt_gen_data_12,
    output  wire    [35:0]  pkt_gen_data_13,
    output  wire    [35:0]  pkt_gen_data_14,
    output  wire    [35:0]  pkt_gen_data_15,
    output  wire    [35:0]  pkt_gen_data_16,
    output  wire    [35:0]  pkt_gen_data_17,
    output  wire    [35:0]  pkt_gen_data_18,
    output  wire    [35:0]  pkt_gen_data_19,
    output  wire    [35:0]  pkt_gen_data_20,
    output  wire    [35:0]  pkt_gen_data_21,
    output  wire    [35:0]  pkt_gen_data_22,
    output  wire    [35:0]  pkt_gen_data_23,

    output  wire    [35:0]  pkt_gen_48data_0,
    output  wire    [35:0]  pkt_gen_48data_1,
    output  wire    [35:0]  pkt_gen_48data_2,
    output  wire    [35:0]  pkt_gen_48data_3,
    output  wire    [35:0]  pkt_gen_48data_4,
    output  wire    [35:0]  pkt_gen_48data_5,
    output  wire    [35:0]  pkt_gen_48data_6,
    output  wire    [35:0]  pkt_gen_48data_7,
    output  wire    [35:0]  pkt_gen_48data_8,
    output  wire    [35:0]  pkt_gen_48data_9,
    output  wire    [35:0]  pkt_gen_48data_10,
    output  wire    [35:0]  pkt_gen_48data_11

);

    wire    [35:0]  sin_data_0  = {9'h131, 9'h121, 9'h110, 9'h0FF};
    wire    [35:0]  sin_data_1  = {9'h171, 9'h162, 9'h152, 9'h142};
    wire    [35:0]  sin_data_2  = {9'h1A9, 9'h19C, 9'h18E, 9'h180};
    wire    [35:0]  sin_data_3  = {9'h1D4, 9'h1CB, 9'h1C0, 9'h1B5};
    wire    [35:0]  sin_data_4  = {9'h1F2, 9'h1EC, 9'h1E5, 9'h1DD};
    wire    [35:0]  sin_data_5  = {9'h1FE, 9'h1FC, 9'h1FA, 9'h1F6};
    wire    [35:0]  sin_data_6  = {9'h1F8, 9'h1FB, 9'h1FD, 9'h1FE};
    wire    [35:0]  sin_data_7  = {9'h1E1, 9'h1E9, 9'h1EF, 9'h1F4};
    wire    [35:0]  sin_data_8  = {9'h1BB, 9'h1C6, 9'h1D0, 9'h1D9};
    wire    [35:0]  sin_data_9  = {9'h187, 9'h195, 9'h1A2, 9'h1AF};
    wire    [35:0]  sin_data_10 = {9'h14A, 9'h15A, 9'h169, 9'h178};
    wire    [35:0]  sin_data_11 = {9'h107, 9'h118, 9'h129, 9'h13A};
    wire    [35:0]  sin_data_12 = {9'h0C4, 9'h0D5, 9'h0E6, 9'h0F7};
    wire    [35:0]  sin_data_13 = {9'h086, 9'h095, 9'h0A4, 9'h0B4};
    wire    [35:0]  sin_data_14 = {9'h04F, 9'h05C, 9'h069, 9'h077};
    wire    [35:0]  sin_data_15 = {9'h025, 9'h02E, 9'h038, 9'h043};
    wire    [35:0]  sin_data_16 = {9'h00A, 9'h00F, 9'h015, 9'h01D};
    wire    [35:0]  sin_data_17 = {9'h000, 9'h001, 9'h003, 9'h006};
    wire    [35:0]  sin_data_18 = {9'h008, 9'h004, 9'h002, 9'h000};
    wire    [35:0]  sin_data_19 = {9'h021, 9'h019, 9'h012, 9'h00C};
    wire    [35:0]  sin_data_20 = {9'h049, 9'h03E, 9'h033, 9'h02A};
    wire    [35:0]  sin_data_21 = {9'h07E, 9'h070, 9'h062, 9'h055};
    wire    [35:0]  sin_data_22 = {9'h0BC, 9'h0AC, 9'h09C, 9'h08D};
    wire    [35:0]  sin_data_23 = {9'h0FF, 9'h0EE, 9'h0DD, 9'h0CD};

    wire    [35:0]  sin_48data_0  = {9'h163, 9'h142, 9'h121, 9'h0FF};
    wire    [35:0]  sin_48data_1  = {9'h1CC, 9'h1B6, 9'h19D, 9'h181};
    wire    [35:0]  sin_48data_2  = {9'h1FD, 9'h1F7, 9'h1ED, 9'h1DF};
    wire    [35:0]  sin_48data_3  = {9'h1E6, 9'h1F3, 9'h1FA, 9'h1FE};
    wire    [35:0]  sin_48data_4  = {9'h18F, 9'h1AA, 9'h1C2, 9'h1D6};
    wire    [35:0]  sin_48data_5  = {9'h110, 9'h132, 9'h153, 9'h172};
    wire    [35:0]  sin_48data_6  = {9'h08C, 9'h0AB, 9'h0CC, 9'h0EE};
    wire    [35:0]  sin_48data_7  = {9'h028, 9'h03C, 9'h054, 9'h06F};
    wire    [35:0]  sin_48data_8  = {9'h000, 9'h004, 9'h00B, 9'h018};
    wire    [35:0]  sin_48data_9  = {9'h01F, 9'h011, 9'h007, 9'h001};
    wire    [35:0]  sin_48data_10 = {9'h07D, 9'h061, 9'h048, 9'h032};
    wire    [35:0]  sin_48data_11 = {9'h0FF, 9'h0DD, 9'h0BC, 9'h09B};

    assign pkt_gen_data_0  = sin_data_0 ;
    assign pkt_gen_data_1  = sin_data_1 ;
    assign pkt_gen_data_2  = sin_data_2 ;
    assign pkt_gen_data_3  = sin_data_3 ;
    assign pkt_gen_data_4  = sin_data_4 ;
    assign pkt_gen_data_5  = sin_data_5 ;
    assign pkt_gen_data_6  = sin_data_6 ;
    assign pkt_gen_data_7  = sin_data_7 ;
    assign pkt_gen_data_8  = sin_data_8 ;
    assign pkt_gen_data_9  = sin_data_9 ;
    assign pkt_gen_data_10 = sin_data_10;
    assign pkt_gen_data_11 = sin_data_11;
    assign pkt_gen_data_12 = sin_data_12;
    assign pkt_gen_data_13 = sin_data_13;
    assign pkt_gen_data_14 = sin_data_14;
    assign pkt_gen_data_15 = sin_data_15;
    assign pkt_gen_data_16 = sin_data_16;
    assign pkt_gen_data_17 = sin_data_17;
    assign pkt_gen_data_18 = sin_data_18;
    assign pkt_gen_data_19 = sin_data_19;
    assign pkt_gen_data_20 = sin_data_20;
    assign pkt_gen_data_21 = sin_data_21;
    assign pkt_gen_data_22 = sin_data_22;
    assign pkt_gen_data_23 = sin_data_23;

    assign pkt_gen_48data_0  = sin_48data_0 ;
    assign pkt_gen_48data_1  = sin_48data_1 ;
    assign pkt_gen_48data_2  = sin_48data_2 ;
    assign pkt_gen_48data_3  = sin_48data_3 ;
    assign pkt_gen_48data_4  = sin_48data_4 ;
    assign pkt_gen_48data_5  = sin_48data_5 ;
    assign pkt_gen_48data_6  = sin_48data_6 ;
    assign pkt_gen_48data_7  = sin_48data_7 ;
    assign pkt_gen_48data_8  = sin_48data_8 ;
    assign pkt_gen_48data_9  = sin_48data_9 ;
    assign pkt_gen_48data_10 = sin_48data_10;
    assign pkt_gen_48data_11 = sin_48data_11;

endmodule
