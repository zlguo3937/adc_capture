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
//  2024-07-06    mhyang        1.0         stat_cnt
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module stat_cnt
#(
    parameter DATA_WIDTH     = 32,
    parameter STEP_WIDTH     = 1
)
(
    input   wire                        clk                         ,
    input   wire                        rst_n                       ,

    input   wire                        cfgmt_count_clr             , // counter clear
    input   wire                        cfgmt_count_overflow_mode   , // count_overflow_mode, 1'b1 counter turn over, 1'b0 counter keep max-value
    input   wire                        cfgmt_count_rd_mode         , // read mode, 1'b1 read clear
    input   wire                        count_rd_en                 , // read enable
    input   wire                        count_en                    , // count_enable
    input   wire    [STEP_WIDTH-1:0]    count_step                  , //
    output  wire    [DATA_WIDTH-1:0]    count_rd_out
);

    reg     [DATA_WIDTH-1:0]    count_out;
    wire    [DATA_WIDTH  :0]    count_temp;

    assign  count_temp = count_out + count_step;

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            count_out <= {(DATA_WIDTH){1'b0}};
        else if (cfgmt_count_clr)
            count_out <= {(DATA_WIDTH){1'b0}};
        else if (count_rd_en & cfgmt_count_rd_mode) begin
            if (count_en)
                count_out <= { {(DATA_WIDTH-STEP_WIDTH){1'b0}}, count_step };
            else
                count_out <= {(DATA_WIDTH){1'b0}};
        end
        else if ( (~cfgmt_count_overflow_mode) & count_en ) begin
            if (count_en)
                count_out <= {(DATA_WIDTH){1'b1}};
            else
                count_out <= count_temp[DATA_WIDTH-1:0];
        end
        else if (cfgmt_count_overflow_mode & count_en)
            count_out <= count_temp[DATA_WIDTH-1:0];
    end

    assign count_rd_out = count_out;

endmodule
