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
//  2024-05-06    zlguo         1.0         memory_wrapper
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module memory_wrapper
(
    input   wire                clk,

    input   wire    [95:0]      cen,
    input   wire    [95:0]      wen,

    input   wire    [15*96-1:0] addr, // width: [14:0]

    input   wire    [9*96-1:0]  data_in, // width: [8:0]

    output  wire    [9*96-1:0]  data_out // width: [8:0]
);
    genvar i;
    generate
        for (i=0;i<96;i=i+1) begin: MEMORY_UNIT
            TS1N28HPCPHVTB32768X9M16SSO
            u_memory_32768x9m16s
            (
            .SLP        (1'b0               ),
            .SD         (1'b0               ),
            .CLK        (clk                ),
            .CEB        (~cen[i]            ),
            .WEB        (~wen[i]            ),
            .A          (addr[15*i+:15]     ),
            .D          (data_in[9*i+:9]  ),
            .Q          (data_out[9*i+:9] )
            );
        end
    endgenerate

endmodule
