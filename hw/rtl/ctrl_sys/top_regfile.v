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
    output  wire            sync_select,

    // Digital config register
    output  wire    [8:0]   rf_pktctrl_clk_div,
    output  wire    [8:0]   rf_pktctrl_clk_phase,

    output  wire            rf_pktctrl_clk_en,
    output  wire            rf_pktctrl_sw_rstn,

    output  wire            rf_self_test_mode,

    output  wire            rf_capture_mode,
    output  wire            rf_capture_start,
    output  wire            rf_capture_again,

    output  wire            rf_96path_en,
    output  wire    [1:0]   rf_pkt_data_length,
    output  wire    [15:0]  rf_pkt_idle_length,

    output  wire            rf_mdio_read_pulse,
    output  wire    [6:0]   rf_mdio_data_sel,
    output  wire    [14:0]  rf_mdio_memory_addr,
    output  wire    [8:0]   rf_mdio_pkt_data
);

    assign legal_phy_addr = 0;
    assign legal_phy_addr_mask = 0;
    assign broadcast_addr = 0;
    assign broadcast_mode = 0;
    assign non_zero_detect = 0;
    assign opendrain_mode = 0;
    assign watchdog_enable = 0;
    assign sync_select = 0;

    assign req_pready = 0;
    assign req_prdata = 0;
    assign req_pslverr = 0;

    assign rf_pktctrl_clk_div = 0;
    assign rf_pktctrl_clk_phase = 0;

    assign rf_pktctrl_clk_en = 0;
    assign rf_pktctrl_sw_rstn = 0;

    assign rf_self_test_mode = 0;

    assign rf_capture_mode = 0;
    assign rf_capture_start = 0;
    assign rf_capture_again = 0;

    assign rf_96path_en = 0;
    assign rf_pkt_data_length = 0;
    assign rf_pkt_idle_length = 0;

    assign rf_mdio_read_pulse = 0;
    assign rf_mdio_data_sel = 0;
    assign rf_mdio_memory_addr = 0;
    assign rf_mdio_pkt_data = 0;

endmodule
