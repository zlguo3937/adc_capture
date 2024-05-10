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
//  2024-05-06    zlguo         1.0         ASIC
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module ASIC
(
    inout   wire    PAD1_RSTN,
    inout   wire    PAD2_CLK_RD
);

    wire    ANA_CLK200M;
    wire    ANA_CLK500M;

    DIGITAL_WRAPPER
    u_digital_top
    (
    .ANA_CLK200M    (ANA_CLK200M    ),
    .ANA_CLK500M    (ANA_CLK500M    ),
    .PAD1_RSTN      (PAD1_RSTN      ),
    .PAD2_CLK_RD    (PAD2_CLK_RD    )
    );

    ANALOG_WRAPPER
    u_analog_top
    (
    .CLK200M        (ANA_CLK200M    ),
    .CLK500M        (ANA_CLK500M    )
    );

endmodule
