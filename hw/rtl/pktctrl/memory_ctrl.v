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
//  2024-05-06    zlguo         1.0         memory_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module memory_ctrl
(
    input   wire                clk,

    input   wire    [95:0]      chip_en;
    input   wire    [95:0]      wr_en;

    input   wire    [15*96-1:0] addr;

    input   wire    [9*96-1:0]  data_in
    output  wire    [9*96-1:0]  data_out

);

    genvar i;
    generate
        for (i=0;i<96;i=i+1) begin: MEMORY_UNIT
            memory_inst
            u_memory_inst
            (
            .CLK    (clk                ),
            .CEB    (~chip_en[i]        ),
            .WEB    (~wr_en[i]          ),
            .A      (addr[15*i+:15]     ),
            .D      (data_in[9*i+:9]    ),
            .Q      (data_out[9*i+:9]   )
            );
        end
    endgenerate

endmodule
