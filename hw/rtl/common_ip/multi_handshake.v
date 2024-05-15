// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
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
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2024-05-14    zlguo         1.0         multi_handshake
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module multi_handshake
#(
    parameter DATA_WIDTH = 32
)
(
    input   wire                        clk_in,
    input   wire                        rstn_in,
    input   wire                        vld_in,
    input   wire    [DATA_WIDTH-1:0]    din,

    input   wire                        clk_out,
    input   wire                        rstn_out,
    output  wire                        vld_out,
    output  reg     [DATA_WIDTH-1:0]    dout

);

assign
endmodule
