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
//  2024-05-06    zlguo         1.0         iopad_top
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module iopad_top
(
    inout   wire    PAD1_RSTN,
    inout   wire    PAD2_CLK_RD,

    // Register config inout direction
    input   wire    rf_RSTN_OEN,
    input   wire    rf_RSTN_REN
);

    iopad_pdd_inst
    u_PAD1_RSTN
    (
    .I          (RSTN_I         ),
    .OEN        (rf_RSTN_OEN    ),
    .REN        (rf_RSTN_REN    ),
    .PAD        (RSTN_PAD       ),
    .C          (RSTN           )
    );

    iopad_pdd_inst
    u_PAD2_CLK_RD
    (
    .I          (CLK_RD_I       ),
    .OEN        (rf_CLK_RD_OEN  ),
    .REN        (rf_CLK_RD_REN  ),
    .PAD        (CLK_RD_PAD     ),
    .C          (CLK_RD         )
    );

endmodule
