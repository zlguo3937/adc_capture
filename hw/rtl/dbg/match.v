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
//  2024-07-06    mhyang        1.0         match
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module match
#(
    parameter DATA_WIDTH     = 32
)
(
    input   wire                        clk             ,
    input   wire                        rst_n           ,

    input   wire    [DATA_WIDTH-1:0]    trigger_pattern ,
    input   wire    [DATA_WIDTH-1:0]    trigger_logic   ,
    input   wire    [DATA_WIDTH*3-1:0]  trigger_mode    ,

    // test data
    input   wire    [DATA_WIDTH-1:0]    cap_data        ,
    input   wire                        cap_data_vld    ,
    input   wire                        trigger_enable  ,

    // trigger result
    output  reg                         tri_succeed     ,
    output  reg     [DATA_WIDTH-1:0]    tri_data        ,
    output  reg                         tri_data_vld
);

    wire    [DATA_WIDTH-1:0]    trigger_bit_succeed;
    wire    [DATA_WIDTH-1:0]    trigger_bit_data_out;
    wire    [DATA_WIDTH-1:0]    trigger_bit_data_out_vld; // spyglass disable W111
    wire    [DATA_WIDTH-1:0]    mismatch_bit_abstract;
    wire    [DATA_WIDTH-1:0]    match_bit_abstract;

    reg                         trigger_succeed_flag;
    reg                         tri_succeed_temp;
    reg     [DATA_WIDTH-1:0]    tri_data_temp;
    reg                         tri_data_vld_temp;

    // Generate loop to instantiate DATA_WIDTH times
    genvar i;
    generate
        for (i=0; i<DATA_WIDTH; i=i+1) begin: GEN_TRIGGER_BIT
            trigger_bit
            u_trigger_bit
            (
            .clk                            (clk                            ),
            .rst_n                          (rst_n                          ),
            // configuration
            .trigger_pattern                (trigger_pattern[i]             ),
            .trigger_mode                   (trigger_mode[3*i+2 : 3*i]      ),
            .trigger_data                   (cap_data[i]                    ),
            .trigger_data_vld               (cap_data_vld & trigger_enable  ),
            // trigger result
            .trigger_succeed                (trigger_bit_succeed[i]         ),
            .trigger_data_out               (trigger_bit_data_out[i]        ),
            .trigger_data_out_vld           (trigger_bit_data_out_vld[i]    )
            );
        end
    endgenerate

    assign mismatch_bit_abstract = trigger_bit_succeed & trigger_logic;
    assign match_bit_abstract    = trigger_bit_succeed | trigger_logic;

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            trigger_succeed_flag <= 1'b0;
        else if (tri_succeed_temp && trigger_enable)
            trigger_succeed_flag <= 1'b1;
        else if (!trigger_enable)
            trigger_succeed_flag <= 1'b0;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_succeed_temp <= 1'b0;
        else if (|trigger_logic==1'b0)
            tri_succeed_temp <= &match_bit_abstract;
        else
            tri_succeed_temp <= (|mismatch_bit_abstract) & (&match_bit_abstract);
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_succeed <= 1'b0;
        else
            tri_succeed <= tri_succeed_temp & (~trigger_succeed_flag) & trigger_enable;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_data_vld_temp <= 1'b0;
        else
            tri_data_vld_temp <= trigger_bit_data_out_vld[0];
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_data_temp <= {(DATA_WIDTH){1'b0}};
        else if (trigger_bit_data_out_vld[0])
            tri_data_temp <= trigger_bit_data_out;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_data_vld <= 1'b0;
        else
            tri_data_vld <= tri_data_vld_temp;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            tri_data <= {(DATA_WIDTH){1'b0}};
        else if (tri_data_vld_temp)
            tri_data <= tri_data_temp;
    end

endmodule
