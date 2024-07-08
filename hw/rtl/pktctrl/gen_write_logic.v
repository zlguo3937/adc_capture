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
//  2024-05-06    zlguo         1.0         gen_write_logic
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module gen_write_logic
(
    input   wire                clk,
    input   wire                rstn,
    input   wire                rf_capture_start,
    input   wire                write_en,
    output  reg     [15-1:0]    waddr,
    output  reg                 wr_done
);

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            wr_done <= 1'b0;
        else if (rf_capture_start)
            wr_done <= 1'b0;
        else if (&waddr)
            wr_done <= 1'b1;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            waddr <= 15'b0;
        else if (&waddr)
            waddr <= 15'b0;
        else if(write_en)
            waddr <= waddr + 1'b1;
    end

endmodule
