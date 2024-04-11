// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2024-03-08                  1.0         spsram32768x9_wrapper
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module spsram32768x9_wrapper
(
    // Input-Output declarations
    input           CLK,
    input           CEB,
    input           WEB,
    input   [14:0]  A,
    input   [8:0]   D,
    output  [8:0]   Q
);

    TSMC28HPCPHVT32768x9M16S_SPSRAM
    u_TSMC28HPCPHVT32768x9M16S_SPSRAM
    (
    .CLK  (CLK  ),
    .CEB  (CEB  ),
    .WEB  (WEB  ),
    .A    (A    ),
    .D    (D    ),
    .Q    (Q    )
    );

endmodule
