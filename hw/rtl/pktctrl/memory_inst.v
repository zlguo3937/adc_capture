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
`timescale 1ns/1ns
module memory_inst
#(
    parameter   ADDR_WIDTH = 15,
    parameter   DATA_WIDTH = 36
)(
    input   wire                        CLK,
    input   wire                        CEB,
    input   wire                        WEB,
    input   wire    [ADDR_WIDTH-1:0]    A,
    input   wire    [DATA_WIDTH-1:0]    D,
    output  wire    [DATA_WIDTH-1:0]    Q
);

`ifndef FPGA
    TS1N28HPCPSVTB32768X36M16SWSO
    u_memory_32768x36
    (
    .SLP    (1'b0       ),
    .SD     (1'b0       ),
    .CLK    (CLK        ),
    .CEB    (CEB        ),
    .WEB    (WEB        ),
    .BWEB   (36'b0      ),
    .A      (A          ),
    .D      (D          ),
    .Q      (Q          )
    );
`else
    blk_mem_gen_0
    u_memory_32768x36 (
    .clka(CLK),    // input wire clka
    .ena(CEB),      // input wire ena
    .wea(WEB),      // input wire [0 : 0] wea
    .addra(A),  // input wire [14 : 0] addra
    .dina(D),    // input wire [35 : 0] dina
    .douta(Q)  // output wire [35 : 0] douta
    );
`endif

endmodule
