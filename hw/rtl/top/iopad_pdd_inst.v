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
//  2024-05-06    zlguo         1.0         iopad_pdd_inst
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module iopad_pdd_inst
(
    input   wire    I,
    input   wire    OEN,
    input   wire    REN,

    inout   wire    PAD,

    output  wire    C
);

    PDDW16SDGZ_H_G
    U_DONT_TOUCH_IO_CELL
    (
    .I   (I   ),
    .OEN (OEN ),
    .REN (REN ),
    .PAD (PAD ),
    .C   (C   )
    );

endmodule
