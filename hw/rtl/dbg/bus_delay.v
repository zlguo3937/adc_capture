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
//  2024-07-06    mhyang        1.0         bus_delay
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module bus_delay
#(
    parameter DELAY_CYCLES  = 8,
    parameter BUS_WIDTH     = 8,
    parameter INIT_VAL      = 1'b0
)
(
    input   wire                    clk     ,
    input   wire                    rst_n   ,
    input   wire    [BUS_WIDTH-1:0] inbus   ,
    output  wire    [BUS_WIDTH-1:0] outbus
);

    reg     [BUS_WIDTH-1:0] delay_seq [DELAY_CYCLES:0]; //delay

    integer i;

    assign outbus = delay_seq[0];

    always @(*) begin
            delay_seq[DELAY_CYCLES] = inbus;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n) begin
            for (i=0; i<DELAY_CYCLES; i=i+1) begin
                delay_seq[i] <= {(BUS_WIDTH){INIT_VAL}};
            end
        end
        else begin
            for (i=0; i<DELAY_CYCLES; i=i+1) begin
                delay_seq[i] <= delay_seq[i+1];
            end
        end
    end

endmodule
