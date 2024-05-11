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
module memory_inst
#(
    parameter   ADDR_WIDTH = 15,
    parameter   DATA_WIDTH = 9
)(
    input   wire                        CLK,
    input   wire                        CEB,
    input   wire                        WEB,
    input   wire    [ADDR_WIDTH-1:0]    A,
    input   wire    [DATA_WIDTH-1:0]    D,
    output  wire    [DATA_WIDTH-1:0]    Q
);

    TS1N28HPCPHVTB32768X9M16SSO
    u_memory_32768x9m16s
    (
    .SLP    (1'b0       ),
    .SD     (1'b0       ),
    .CLK    (CLK        ),
    .CEB    (CEN        ),
    .WEB    (WEN        ),
    .A      (A          ),
    .D      (D          ),
    .Q      (Q          )
    );

endmodule
