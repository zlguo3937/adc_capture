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
    input   wire            clk,
    input   wire            rstn,

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

    reg     [35:0]  sin_data_0 ;
    reg     [35:0]  sin_data_1 ;
    reg     [35:0]  sin_data_2 ;
    reg     [35:0]  sin_data_3 ;
    reg     [35:0]  sin_data_4 ;
    reg     [35:0]  sin_data_5 ;
    reg     [35:0]  sin_data_6 ;
    reg     [35:0]  sin_data_7 ;
    reg     [35:0]  sin_data_8 ;
    reg     [35:0]  sin_data_9 ;
    reg     [35:0]  sin_data_10;
    reg     [35:0]  sin_data_11;
    reg     [35:0]  sin_data_12;
    reg     [35:0]  sin_data_13;
    reg     [35:0]  sin_data_14;
    reg     [35:0]  sin_data_15;
    reg     [35:0]  sin_data_16;
    reg     [35:0]  sin_data_17;
    reg     [35:0]  sin_data_18;
    reg     [35:0]  sin_data_19;
    reg     [35:0]  sin_data_20;
    reg     [35:0]  sin_data_21;
    reg     [35:0]  sin_data_22;
    reg     [35:0]  sin_data_23;

    reg     [35:0]  sin_48data_0 ;
    reg     [35:0]  sin_48data_1 ;
    reg     [35:0]  sin_48data_2 ;
    reg     [35:0]  sin_48data_3 ;
    reg     [35:0]  sin_48data_4 ;
    reg     [35:0]  sin_48data_5 ;
    reg     [35:0]  sin_48data_6 ;
    reg     [35:0]  sin_48data_7 ;
    reg     [35:0]  sin_48data_8 ;
    reg     [35:0]  sin_48data_9 ;
    reg     [35:0]  sin_48data_10;
    reg     [35:0]  sin_48data_11;

    reg             sel;

    always @ (posedge clk or negedge rstn) begin
        if (!rstn)
            sel <= 1'b0;
        else
            sel <= ~sel;
    end

    always @ (posedge clk or negedge rstn) begin
        if (!rstn) begin
            sin_data_0  <= 36'h0;
            sin_data_1  <= 36'h0;
            sin_data_2  <= 36'h0;
            sin_data_3  <= 36'h0;
            sin_data_4  <= 36'h0;
            sin_data_5  <= 36'h0;
            sin_data_6  <= 36'h0;
            sin_data_7  <= 36'h0;
            sin_data_8  <= 36'h0;
            sin_data_9  <= 36'h0;
            sin_data_10 <= 36'h0;
            sin_data_11 <= 36'h0;
            sin_data_12 <= 36'h0;
            sin_data_13 <= 36'h0;
            sin_data_14 <= 36'h0;
            sin_data_15 <= 36'h0;
            sin_data_16 <= 36'h0;
            sin_data_17 <= 36'h0;
            sin_data_18 <= 36'h0;
            sin_data_19 <= 36'h0;
            sin_data_20 <= 36'h0;
            sin_data_21 <= 36'h0;
            sin_data_22 <= 36'h0;
            sin_data_23 <= 36'h0;
        end
        else begin
            sin_data_0  <= sel ? {9'h131, 9'h121, 9'h110, 9'h0FF} : {9'h131-1'b1, 9'h121-1'b1, 9'h110-1'b1, 9'h0FF-1'b1};
            sin_data_1  <= sel ? {9'h171, 9'h162, 9'h152, 9'h142} : {9'h171-1'b1, 9'h162-1'b1, 9'h152-1'b1, 9'h142-1'b1};
            sin_data_2  <= sel ? {9'h1A9, 9'h19C, 9'h18E, 9'h180} : {9'h1A9-1'b1, 9'h19C-1'b1, 9'h18E-1'b1, 9'h180-1'b1};
            sin_data_3  <= sel ? {9'h1D4, 9'h1CB, 9'h1C0, 9'h1B5} : {9'h1D4-1'b1, 9'h1CB-1'b1, 9'h1C0-1'b1, 9'h1B5-1'b1};
            sin_data_4  <= sel ? {9'h1F2, 9'h1EC, 9'h1E5, 9'h1DD} : {9'h1F2-1'b1, 9'h1EC-1'b1, 9'h1E5-1'b1, 9'h1DD-1'b1};
            sin_data_5  <= sel ? {9'h1FE, 9'h1FC, 9'h1FA, 9'h1F6} : {9'h1FE-1'b1, 9'h1FC-1'b1, 9'h1FA-1'b1, 9'h1F6-1'b1};
            sin_data_6  <= sel ? {9'h1F8, 9'h1FB, 9'h1FD, 9'h1FE} : {9'h1F8-1'b1, 9'h1FB-1'b1, 9'h1FD-1'b1, 9'h1FE-1'b1};
            sin_data_7  <= sel ? {9'h1E1, 9'h1E9, 9'h1EF, 9'h1F4} : {9'h1E1-1'b1, 9'h1E9-1'b1, 9'h1EF-1'b1, 9'h1F4-1'b1};
            sin_data_8  <= sel ? {9'h1BB, 9'h1C6, 9'h1D0, 9'h1D9} : {9'h1BB-1'b1, 9'h1C6-1'b1, 9'h1D0-1'b1, 9'h1D9-1'b1};
            sin_data_9  <= sel ? {9'h187, 9'h195, 9'h1A2, 9'h1AF} : {9'h187-1'b1, 9'h195-1'b1, 9'h1A2-1'b1, 9'h1AF-1'b1};
            sin_data_10 <= sel ? {9'h14A, 9'h15A, 9'h169, 9'h178} : {9'h14A-1'b1, 9'h15A-1'b1, 9'h169-1'b1, 9'h178-1'b1};
            sin_data_11 <= sel ? {9'h107, 9'h118, 9'h129, 9'h13A} : {9'h107-1'b1, 9'h118-1'b1, 9'h129-1'b1, 9'h13A-1'b1};
            sin_data_12 <= sel ? {9'h0C4, 9'h0D5, 9'h0E6, 9'h0F7} : {9'h0C4-1'b1, 9'h0D5-1'b1, 9'h0E6-1'b1, 9'h0F7-1'b1};
            sin_data_13 <= sel ? {9'h086, 9'h095, 9'h0A4, 9'h0B4} : {9'h086-1'b1, 9'h095-1'b1, 9'h0A4-1'b1, 9'h0B4-1'b1};
            sin_data_14 <= sel ? {9'h04F, 9'h05C, 9'h069, 9'h077} : {9'h04F-1'b1, 9'h05C-1'b1, 9'h069-1'b1, 9'h077-1'b1};
            sin_data_15 <= sel ? {9'h025, 9'h02E, 9'h038, 9'h043} : {9'h025-1'b1, 9'h02E-1'b1, 9'h038-1'b1, 9'h043-1'b1};
            sin_data_16 <= sel ? {9'h00A, 9'h00F, 9'h015, 9'h01D} : {9'h00A-1'b1, 9'h00F-1'b1, 9'h015-1'b1, 9'h01D-1'b1};
            sin_data_17 <= sel ? {9'h000, 9'h001, 9'h003, 9'h006} : {9'h000     , 9'h001-1'b1, 9'h003-1'b1, 9'h006-1'b1};
            sin_data_18 <= sel ? {9'h008, 9'h004, 9'h002, 9'h000} : {9'h008-1'b1, 9'h004-1'b1, 9'h002-1'b1, 9'h000     };
            sin_data_19 <= sel ? {9'h021, 9'h019, 9'h012, 9'h00C} : {9'h021-1'b1, 9'h019-1'b1, 9'h012-1'b1, 9'h00C-1'b1};
            sin_data_20 <= sel ? {9'h049, 9'h03E, 9'h033, 9'h02A} : {9'h049-1'b1, 9'h03E-1'b1, 9'h033-1'b1, 9'h02A-1'b1};
            sin_data_21 <= sel ? {9'h07E, 9'h070, 9'h062, 9'h055} : {9'h07E-1'b1, 9'h070-1'b1, 9'h062-1'b1, 9'h055-1'b1};
            sin_data_22 <= sel ? {9'h0BC, 9'h0AC, 9'h09C, 9'h08D} : {9'h0BC-1'b1, 9'h0AC-1'b1, 9'h09C-1'b1, 9'h08D-1'b1};
            sin_data_23 <= sel ? {9'h0FF, 9'h0EE, 9'h0DD, 9'h0CD} : {9'h0FF-1'b1, 9'h0EE-1'b1, 9'h0DD-1'b1, 9'h0CD-1'b1};
        end
    end

    always @ (posedge clk or negedge rstn) begin
        if (!rstn) begin
            sin_48data_0  <= 36'h0;
            sin_48data_1  <= 36'h0;
            sin_48data_2  <= 36'h0;
            sin_48data_3  <= 36'h0;
            sin_48data_4  <= 36'h0;
            sin_48data_5  <= 36'h0;
            sin_48data_6  <= 36'h0;
            sin_48data_7  <= 36'h0;
            sin_48data_8  <= 36'h0;
            sin_48data_9  <= 36'h0;
            sin_48data_10 <= 36'h0;
            sin_48data_11 <= 36'h0;
        end
        else begin
            sin_48data_0  <= sel ? {9'h163, 9'h142, 9'h121, 9'h0FF} : {9'h163-1'b1, 9'h142-1'b1, 9'h121-1'b1, 9'h0FF-1'b1};
            sin_48data_1  <= sel ? {9'h1CC, 9'h1B6, 9'h19D, 9'h181} : {9'h1CC-1'b1, 9'h1B6-1'b1, 9'h19D-1'b1, 9'h181-1'b1};
            sin_48data_2  <= sel ? {9'h1FD, 9'h1F7, 9'h1ED, 9'h1DF} : {9'h1FD-1'b1, 9'h1F7-1'b1, 9'h1ED-1'b1, 9'h1DF-1'b1};
            sin_48data_3  <= sel ? {9'h1E6, 9'h1F3, 9'h1FA, 9'h1FE} : {9'h1E6-1'b1, 9'h1F3-1'b1, 9'h1FA-1'b1, 9'h1FE-1'b1};
            sin_48data_4  <= sel ? {9'h18F, 9'h1AA, 9'h1C2, 9'h1D6} : {9'h18F-1'b1, 9'h1AA-1'b1, 9'h1C2-1'b1, 9'h1D6-1'b1};
            sin_48data_5  <= sel ? {9'h110, 9'h132, 9'h153, 9'h172} : {9'h110-1'b1, 9'h132-1'b1, 9'h153-1'b1, 9'h172-1'b1};
            sin_48data_6  <= sel ? {9'h08C, 9'h0AB, 9'h0CC, 9'h0EE} : {9'h08C-1'b1, 9'h0AB-1'b1, 9'h0CC-1'b1, 9'h0EE-1'b1};
            sin_48data_7  <= sel ? {9'h028, 9'h03C, 9'h054, 9'h06F} : {9'h028-1'b1, 9'h03C-1'b1, 9'h054-1'b1, 9'h06F-1'b1};
            sin_48data_8  <= sel ? {9'h000, 9'h004, 9'h00B, 9'h018} : {9'h000-1'b1, 9'h004-1'b1, 9'h00B-1'b1, 9'h018-1'b1};
            sin_48data_9  <= sel ? {9'h01F, 9'h011, 9'h007, 9'h001} : {9'h01F-1'b1, 9'h011-1'b1, 9'h007-1'b1, 9'h001-1'b1};
            sin_48data_10 <= sel ? {9'h07D, 9'h061, 9'h048, 9'h032} : {9'h07D-1'b1, 9'h061-1'b1, 9'h048-1'b1, 9'h032-1'b1};
            sin_48data_11 <= sel ? {9'h0FF, 9'h0DD, 9'h0BC, 9'h09B} : {9'h0FF-1'b1, 9'h0DD-1'b1, 9'h0BC-1'b1, 9'h09B-1'b1};
        end
    end

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
