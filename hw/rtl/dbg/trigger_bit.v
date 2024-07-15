// Copyright (c) 2024 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-07-06    mhyang        1.0         trigger_bit
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module trigger_bit
(
    input   wire            clk             ,
    input   wire            rst_n           ,

    input   wire            trigger_pattern ,
    input   wire    [2:0]   trigger_mode    , // 000-mask, 001-match, 010-mismatch, 011-rising edge, 100-falling edge, 101-both edge

    // test data
    input   wire            trigger_data    ,
    input   wire            trigger_data_vld,

    // trigger result
    output  reg             trigger_succeed ,
    output  reg             trigger_data_out,
    output  reg             trigger_data_out_vld
);

    reg     trigger_data_d1;
    reg     trigger_data_vld_d1;
    reg     p_flag;
    wire    n_flag;

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_data_d1 <= 1'b0;
        else
            trigger_data_d1 <= trigger_data;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_data_vld_d1 <= 1'b0;
        else
            trigger_data_vld_d1 <= trigger_data_vld;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            p_flag <= 1'b0;
        else
            p_flag <= trigger_data & (~trigger_data_d1);
    end

    assign n_flag = ~trigger_data & trigger_data_d1;

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_succeed_ <= 1'b0;
        else if (trigger_data_vld_d1) begin
            if (trigger_mode == 3'b000)
                trigger_succeed <= 1'b1;
            else if (trigger_mode == 3'b001)
                trigger_succeed <= trigger_data_d1 == trigger_pattern;
            else if (trigger_mode == 3'b010)
                trigger_succeed <= trigger_data_d1 != trigger_pattern;
            else if (trigger_mode == 3'b011)
                trigger_succeed <= p_flag;
            else if (trigger_mode == 3'b100)
                trigger_succeed <= n_flag;
            else if (trigger_mode == 3'b101)
                trigger_succeed <= p_flag | n_flag;
            else
                trigger_succeed <= 1'b0;
        end
        else
            trigger_succeed <= 1'b0;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_data_out <= 1'b0;
        else
            trigger_data_out <=  trigger_data_d1;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_data_out_vld <= 1'b0;
        else
            trigger_data_out_vld <=  trigger_data_vld_d1;
    end

endmodule
