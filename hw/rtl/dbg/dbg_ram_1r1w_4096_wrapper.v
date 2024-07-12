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
//  2024-07-06    mhyang        1.0         dbg_ram_1r1w_4096_wrapper
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module dbg_ram_1r1w_4096_wrapper
#(
    parameter RAM_DEPTH     = 4096,
    parameter ADDR_WIDTH    = 12,
    parameter DATA_WIDTH    = 16,
    parameter READ_LATENCY  = 1
)
(
    input   wire                    clka,
    input   wire                    csa,
    input   wire                    wra,
    input   wire    [ADDR_WIDTH:0]  addra,
    input   wire    [DATA_WIDTH:0]  dina,

    input   wire                    clkb,
    input   wire                    csb,
    input   wire                    rdb,
    input   wire    [ADDR_WIDTH:0]  addrb,

    output  wire    [DATA_WIDTH:0]  doutb
);

`ifndef FPGA
    TSDN28HPCPA4096x16M8MS
    u_ram_1r1w
    (
    .SLP    (1'b0   ),//TODO
    .WTSEL  (2'b01  ),
    .RTSEL  (2'b01  ),
    .VG     (1'b1   ),
    .VS     (1'b1   ),
    .AA     (addra  ),
    .DA     (dina   ),
    .WEBA   (~wra   ),
    .CEBA   (~csa   ),
    .CLKA   (clka   ),
    .AB     (addrb  ),
    .DB     (16'b0  ),
    .WEBB   (1'b1   ),
    .CEBB   (~csb   ),
    .CLKB   (clkb   ),
    .QA     (       ), // spyglass disable W287b
    .QB     (doutb  )
    );
`else
    dbg_ram_1r1w_4096_x16
    u_ram_1r1w
    (
    .clka   (clka   ),
    .ena    (csa    ),
    .wea    (wra    ),
    .addra  (addra  ),
    .dina   (dina   ), 
    .clkb   (clkb   ),
    .enb    (csb    ),
    .addrb  (addrb  ),
    .doutb  (doutb  )
    );
`endif

endmodule
