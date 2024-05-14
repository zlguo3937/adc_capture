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
//  2024-05-06    zlguo         1.0         top_regfile
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module top_regfile
(
    input   wire    [20:0]  req_paddr,
    input   wire            req_pwrite,
    input   wire            req_psel,
    input   wire            req_penable,
    input   wire    [15:0]  req_pwdata,

    output  wire            req_pready,
    output  wire    [15:0]  req_prdata,
    output  wire            req_pslverr,

    output  wire    [4 :0]  legal_phy_addr,
    output  wire    [4 :0]  legal_phy_addr_mask,
    output  wire    [4 :0]  broadcast_addr,
    output  wire            broadcast_mode,
    output  wire            non_zero_detect,
    output  wire            opendrain_mode,
    output  wire            watchdog_enable,
    output  wire            sync_select
);

    assign legal_phy_addr = 5'b0;
    assign legal_phy_addr_mask = 5'b0;
    assign broadcast_addr = 5'b0;
    assign broadcast_mode = 5'b0;
    assign non_zero_detect = 5'b0;
    assign opendrain_mode = 5'b0;
    assign watchdog_enable = 5'b0;
    assign sync_select = 5'b0;

endmodule
