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
//  2024-05-06    zlguo         1.0         iopad_pdu_inst
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module iopad_pdu_inst
(
    input   wire    I,
    input   wire    OEN,
    input   wire    REN,

    inout   wire    PAD,

    output  wire    C
);

    PDUW16SDGZ_H_G
    U_DONTTOUCH_IO_CELL
    (
    .I   (I   ),
    .OEN (OEN ),
    .REN (REN ),
    .PAD (PAD ),
    .C   (C   )
    );

endmodule
