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
//  2024-07-30    zlguo         1.0         async_reset_low_sync
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module async_reset_low_sync
(
    input   wire    rst_n_i,
    input   wire    clk_i,
    output  wire    rst_n_o
);

    reg     rst_n_sync0;
    reg     rst_n_sync1;

    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            rst_n_sync0 <= 1'b0;
            rst_n_sync1 <= 1'b0;
        end
        else begin
            rst_n_sync0 <= 1'b1;
            rst_n_sync1 <= rst_n_sync0;
        end
    end

endmodule
