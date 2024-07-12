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
    parameter ADDR_WIDTH    = 13,
    parameter DATA_WIDTH    = 32
)
(
    input   wire                    slp,
    input   wire                    clka,
    input   wire                    csa,
    input   wire                    wra,
    input   wire    [ADDR_WIDTH:0]  addra,
    input   wire    [DATA_WIDTH:0]  dina,

    input   wire                    clkb,
    input   wire                    csb,
    input   wire                    wrb,
    input   wire    [ADDR_WIDTH:0]  addrb,
    input   wire    [DATA_WIDTH:0]  dinb,

    output  wire    [DATA_WIDTH:0]  doutb
);
