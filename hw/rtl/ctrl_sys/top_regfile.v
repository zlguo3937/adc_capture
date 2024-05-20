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
    input   wire            clk,
    input   wire            rstn,

    input   wire    [20:0]  req_paddr,
    input   wire            req_pwrite,
    input   wire            req_psel,
    input   wire            req_penable,
    input   wire    [15:0]  req_pwdata,

    output  wire            req_pready,
    output  wire    [15:0]  req_prdata,

    output  wire    [4 :0]  legal_phy_addr,
    output  wire    [4 :0]  legal_phy_addr_mask,
    output  wire    [4 :0]  broadcast_addr,
    output  wire            broadcast_mode,
    output  wire            non_zero_detect,
    output  wire            opendrain_mode,
    output  wire            watchdog_enable,
    output  wire            sync_select,

    // Digital config register
    output  wire    [8:0]   rf_pktctrl_gap,
    output  wire    [8:0]   rf_pktctrl_phase,

    output  wire            rf_pktctrl_clk_en,
    output  wire            rf_pktctrl_sw_rstn,
    output  wire            rf_regfile_sw_rstn,

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

    input   wire    [8:0]   rf_mdio_pkt_data,
    input   wire            rf_mdio_pkt_data_we
);

    wire            legal_phy_addr_clk;
    wire            legal_phy_addr_mask_clk;
    wire            broadcast_addr_clk;
    wire            broadcast_mode_clk;
    wire            non_zero_detect_clk;
    wire            opendrain_mode_clk;
    wire            watchdog_enable_clk;
    wire            sync_select_clk;
    wire            rf_pktctrl_gap_clk;
    wire            rf_pktctrl_phase_clk;
    wire            rf_pktctrl_clk_en_clk;
    wire            rf_pktctrl_sw_rstn_clk;
    wire            rf_regfile_sw_rstn_clk;
    wire            rf_self_test_mode_clk;
    wire            rf_capture_mode_clk;
    wire            rf_capture_start_clk;
    wire            rf_capture_again_clk;
    wire            rf_96path_en_clk;
    wire            rf_pkt_data_length_clk;
    wire            rf_pkt_idle_length_clk;
    wire            rf_mdio_read_pulse_clk;
    wire            rf_mdio_data_sel_clk;
    wire            rf_mdio_memory_addr_clk;
    wire            rf_mdio_pkt_data_clk;

    wire            legal_phy_addr_rstn;
    wire            legal_phy_addr_mask_rstn;
    wire            broadcast_addr_rstn;
    wire            broadcast_mode_rstn;
    wire            non_zero_detect_rstn;
    wire            opendrain_mode_rstn;
    wire            watchdog_enable_rstn;
    wire            sync_select_rstn;
    wire            rf_pktctrl_gap_rstn;
    wire            rf_pktctrl_phase_rstn;
    wire            rf_pktctrl_clk_en_rstn;
    wire            rf_pktctrl_sw_rstn_rstn;
    wire            rf_regfile_sw_rstn_rstn;
    wire            rf_self_test_mode_rstn;
    wire            rf_capture_mode_rstn;
    wire            rf_capture_start_rstn;
    wire            rf_capture_again_rstn;
    wire            rf_96path_en_rstn;
    wire            rf_pkt_data_length_rstn;
    wire            rf_pkt_idle_length_rstn;
    wire            rf_mdio_read_pulse_rstn;
    wire            rf_mdio_data_sel_rstn;
    wire            rf_mdio_memory_addr_rstn;
    wire            rf_mdio_pkt_data_rstn;

    wire            addr_0x0_sel;
    wire            addr_0x1_sel;
    wire            addr_0x2_sel;
    wire            addr_0x3_sel;
    wire            addr_0x4_sel;
    wire            addr_0x5_sel;
    wire            addr_0x6_sel;
    wire            addr_0x7_sel;
    wire            addr_0x8_sel;
    wire            addr_0x9_sel;
    wire            addr_0xa_sel;
    wire            addr_0xb_sel;

    wire            legal_phy_addr_bus_we;
    wire            legal_phy_addr_mask_bus_we;
    wire            broadcast_addr_bus_we;
    wire            broadcast_mode_bus_we;
    wire            non_zero_detect_bus_we;
    wire            opendrain_mode_bus_we;
    wire            watchdog_enable_bus_we;
    wire            sync_select_bus_we;
    wire            rf_self_test_mode_bus_we;
    wire            rf_pkt_data_length_bus_we;
    wire            rf_capture_mode_bus_we;
    wire            rf_capture_start_bus_we;
    wire            rf_capture_again_bus_we;
    wire            rf_96path_en_bus_we;
    wire            rf_pkt_idle_length_bus_we;
    wire            rf_mdio_memory_addr_bus_we;
    wire            rf_mdio_data_sel_bus_we;
    wire            rf_mdio_read_pulse_bus_we;
    wire            rf_pktctrl_gap_bus_we;
    wire            rf_pktctrl_phase_bus_we;
    wire            rf_pktctrl_clk_en_bus_we;
    wire            rf_pktctrl_sw_rstn_bus_we;
    wire            rf_regfile_sw_rstn_bus_we;

    wire     [4:0]  legal_phy_addr_bus_wdata;
    wire     [4:0]  legal_phy_addr_mask_bus_wdata;
    wire     [4:0]  broadcast_addr_bus_wdata;
    wire            broadcast_mode_bus_wdata;
    wire            non_zero_detect_bus_wdata;
    wire            opendrain_mode_bus_wdata;
    wire            watchdog_enable_bus_wdata;
    wire            sync_select_bus_wdata;
    wire            rf_self_test_mode_bus_wdata;
    wire     [1:0]  rf_pkt_data_length_bus_wdata;
    wire            rf_capture_mode_bus_wdata;
    wire            rf_capture_start_bus_wdata;
    wire            rf_capture_again_bus_wdata;
    wire            rf_96path_en_bus_wdata;
    wire     [15:0] rf_pkt_idle_length_bus_wdata;
    wire     [14:0] rf_mdio_memory_addr_bus_wdata;
    wire     [6:0]  rf_mdio_data_sel_bus_wdata;
    wire            rf_mdio_read_pulse_bus_wdata;
    wire     [8:0]  rf_pktctrl_gap_bus_wdata;
    wire     [8:0]  rf_pktctrl_phase_bus_wdata;
    wire            rf_pktctrl_clk_en_bus_wdata;
    wire            rf_pktctrl_sw_rstn_bus_wdata;
    wire            rf_regfile_sw_rstn_bus_wdata;

    wire     [15:0] addr_0x0_sel_bus_rdata;
    wire     [15:0] addr_0x1_sel_bus_rdata;
    wire     [15:0] addr_0x2_sel_bus_rdata;
    wire     [15:0] addr_0x3_sel_bus_rdata;
    wire     [15:0] addr_0x4_sel_bus_rdata;
    wire     [15:0] addr_0x5_sel_bus_rdata;
    wire     [15:0] addr_0x6_sel_bus_rdata;
    wire     [15:0] addr_0x7_sel_bus_rdata;
    wire     [15:0] addr_0x8_sel_bus_rdata;
    wire     [15:0] addr_0x9_sel_bus_rdata;
    wire     [15:0] addr_0xa_sel_bus_rdata;
    wire     [15:0] addr_0xb_sel_bus_rdata;

    wire     [15:0] sel_0x0_bus_rdata;
    wire     [15:0] sel_0x1_bus_rdata;
    wire     [15:0] sel_0x2_bus_rdata;
    wire     [15:0] sel_0x3_bus_rdata;
    wire     [15:0] sel_0x4_bus_rdata;
    wire     [15:0] sel_0x5_bus_rdata;
    wire     [15:0] sel_0x6_bus_rdata;
    wire     [15:0] sel_0x7_bus_rdata;
    wire     [15:0] sel_0x8_bus_rdata;
    wire     [15:0] sel_0x9_bus_rdata;
    wire     [15:0] sel_0xa_bus_rdata;
    wire     [15:0] sel_0xb_bus_rdata;

    wire     [4:0]  legal_phy_addr_bus_rdata;
    wire     [4:0]  legal_phy_addr_mask_bus_rdata;
    wire     [4:0]  broadcast_addr_bus_rdata;
    wire            broadcast_mode_bus_rdata;
    wire            non_zero_detect_bus_rdata;
    wire            opendrain_mode_bus_rdata;
    wire            watchdog_enable_bus_rdata;
    wire            sync_select_bus_rdata;
    wire            rf_self_test_mode_bus_rdata;
    wire     [1:0]  rf_pkt_data_length_bus_rdata;
    wire            rf_capture_mode_bus_rdata;
    wire            rf_96path_en_bus_rdata;
    wire     [15:0] rf_pkt_idle_length_bus_rdata;
    wire     [14:0] rf_mdio_memory_addr_bus_rdata;
    wire     [6:0]  rf_mdio_data_sel_bus_rdata;
    wire     [8:0]  rf_mdio_pkt_data_bus_rdata;
    wire     [8:0]  rf_pktctrl_gap_bus_rdata;
    wire     [8:0]  rf_pktctrl_phase_bus_rdata;
    wire            rf_pktctrl_clk_en_bus_rdata;
    wire            rf_pktctrl_sw_rstn_bus_rdata;
    wire            rf_regfile_sw_rstn_bus_rdata;

    wire     [4:0]  legal_phy_addr_dev_rdata      ;
    wire     [4:0]  legal_phy_addr_mask_dev_rdata ;
    wire     [4:0]  broadcast_addr_dev_rdata      ;
    wire            broadcast_mode_dev_rdata      ;
    wire            non_zero_detect_dev_rdata     ;
    wire            opendrain_mode_dev_rdata      ;
    wire            watchdog_enable_dev_rdata     ;
    wire            sync_select_dev_rdata         ;
    wire            rf_self_test_mode_dev_rdata   ;
    wire            rf_capture_mode_dev_rdata     ;
    wire            rf_capture_start_dev_rdata    ;
    wire            rf_capture_again_dev_rdata    ;
    wire            rf_96path_en_dev_rdata        ;
    wire     [1:0]  rf_pkt_data_length_dev_rdata  ;
    wire     [15:0] rf_pkt_idle_length_dev_rdata  ;
    wire            rf_mdio_read_pulse_dev_rdata  ;
    wire     [6:0]  rf_mdio_data_sel_dev_rdata    ;
    wire     [14:0] rf_mdio_memory_addr_dev_rdata ;
    wire     [8:0]  rf_pktctrl_gap_dev_rdata  ;
    wire     [8:0]  rf_pktctrl_phase_dev_rdata;
    wire            rf_pktctrl_clk_en_dev_rdata   ;
    wire            rf_pktctrl_sw_rstn_dev_rdata  ;
    wire            rf_regfile_sw_rstn_dev_rdata  ;

    wire            rf_mdio_pkt_data_dev_we;
    wire    [8:0]   rf_mdio_pkt_data_dev_wdata;

    assign legal_phy_addr_clk       = clk;
    assign legal_phy_addr_mask_clk  = clk;
    assign broadcast_addr_clk       = clk;
    assign broadcast_mode_clk       = clk;
    assign non_zero_detect_clk      = clk;
    assign opendrain_mode_clk       = clk;
    assign watchdog_enable_clk      = clk;
    assign sync_select_clk          = clk;
    assign rf_pktctrl_gap_clk   = clk;
    assign rf_pktctrl_phase_clk = clk;
    assign rf_pktctrl_clk_en_clk    = clk;
    assign rf_pktctrl_sw_rstn_clk   = clk;
    assign rf_regfile_sw_rstn_clk   = clk;
    assign rf_self_test_mode_clk    = clk;
    assign rf_capture_mode_clk      = clk;
    assign rf_capture_start_clk     = clk;
    assign rf_capture_again_clk     = clk;
    assign rf_96path_en_clk         = clk;
    assign rf_pkt_data_length_clk   = clk;
    assign rf_pkt_idle_length_clk   = clk;
    assign rf_mdio_read_pulse_clk   = clk;
    assign rf_mdio_data_sel_clk     = clk;
    assign rf_mdio_memory_addr_clk  = clk;

    assign legal_phy_addr_rstn       = rstn;
    assign legal_phy_addr_mask_rstn  = rstn;
    assign broadcast_addr_rstn       = rstn;
    assign broadcast_mode_rstn       = rstn;
    assign non_zero_detect_rstn      = rstn;
    assign opendrain_mode_rstn       = rstn;
    assign watchdog_enable_rstn      = rstn;
    assign sync_select_rstn          = rstn;
    assign rf_pktctrl_gap_rstn   = rstn;
    assign rf_pktctrl_phase_rstn = rstn;
    assign rf_pktctrl_clk_en_rstn    = rstn;
    assign rf_pktctrl_sw_rstn_rstn   = rstn;
    assign rf_regfile_sw_rstn_rstn   = rstn;
    assign rf_self_test_mode_rstn    = rstn;
    assign rf_capture_mode_rstn      = rstn;
    assign rf_capture_start_rstn     = rstn;
    assign rf_capture_again_rstn     = rstn;
    assign rf_96path_en_rstn         = rstn;
    assign rf_pkt_data_length_rstn   = rstn;
    assign rf_pkt_idle_length_rstn   = rstn;
    assign rf_mdio_read_pulse_rstn   = rstn;
    assign rf_mdio_data_sel_rstn     = rstn;
    assign rf_mdio_memory_addr_rstn  = rstn;

    assign addr_0x0_sel = (req_paddr == 21'h0) & req_psel & req_penable;
    assign addr_0x1_sel = (req_paddr == 21'h1) & req_psel & req_penable;
    assign addr_0x2_sel = (req_paddr == 21'h2) & req_psel & req_penable;
    assign addr_0x3_sel = (req_paddr == 21'h3) & req_psel & req_penable;
    assign addr_0x4_sel = (req_paddr == 21'h4) & req_psel & req_penable;
    assign addr_0x5_sel = (req_paddr == 21'h5) & req_psel & req_penable;
    assign addr_0x6_sel = (req_paddr == 21'h6) & req_psel & req_penable;
    assign addr_0x7_sel = (req_paddr == 21'h7) & req_psel & req_penable;
    assign addr_0x8_sel = (req_paddr == 21'h8) & req_psel & req_penable;
    assign addr_0x9_sel = (req_paddr == 21'h9) & req_psel & req_penable;
    assign addr_0xa_sel = (req_paddr == 21'ha) & req_psel & req_penable;
    assign addr_0xb_sel = (req_paddr == 21'hb) & req_psel & req_penable;

    assign legal_phy_addr_bus_we       = addr_0x0_sel & req_pwrite;
    assign legal_phy_addr_mask_bus_we  = addr_0x0_sel & req_pwrite;
    assign broadcast_addr_bus_we       = addr_0x0_sel & req_pwrite;
    assign broadcast_mode_bus_we       = addr_0x1_sel & req_pwrite;
    assign non_zero_detect_bus_we      = addr_0x1_sel & req_pwrite;
    assign opendrain_mode_bus_we       = addr_0x1_sel & req_pwrite;
    assign watchdog_enable_bus_we      = addr_0x1_sel & req_pwrite;
    assign sync_select_bus_we          = addr_0x1_sel & req_pwrite;
    assign rf_self_test_mode_bus_we    = addr_0x2_sel & req_pwrite;
    assign rf_pkt_data_length_bus_we   = addr_0x2_sel & req_pwrite;
    assign rf_capture_mode_bus_we      = addr_0x2_sel & req_pwrite;
    assign rf_capture_start_bus_we     = addr_0x2_sel & req_pwrite;
    assign rf_capture_again_bus_we     = addr_0x2_sel & req_pwrite;
    assign rf_96path_en_bus_we         = addr_0x2_sel & req_pwrite;
    assign rf_pkt_idle_length_bus_we   = addr_0x3_sel & req_pwrite;
    assign rf_mdio_memory_addr_bus_we  = addr_0x4_sel & req_pwrite;
    assign rf_mdio_data_sel_bus_we     = addr_0x5_sel & req_pwrite;
    assign rf_mdio_read_pulse_bus_we   = addr_0x7_sel & req_pwrite;
    assign rf_pktctrl_gap_bus_we   = addr_0x8_sel & req_pwrite;
    assign rf_pktctrl_phase_bus_we = addr_0x9_sel & req_pwrite;
    assign rf_pktctrl_clk_en_bus_we    = addr_0xa_sel & req_pwrite;
    assign rf_pktctrl_sw_rstn_bus_we   = addr_0xb_sel & req_pwrite;
    assign rf_regfile_sw_rstn_bus_we   = addr_0xb_sel & req_pwrite;

    assign legal_phy_addr_bus_wdata       = req_pwdata[14:10];
    assign legal_phy_addr_mask_bus_wdata  = req_pwdata[9:5];
    assign broadcast_addr_bus_wdata       = req_pwdata[4:0];
    assign broadcast_mode_bus_wdata       = req_pwdata[4];
    assign non_zero_detect_bus_wdata      = req_pwdata[3];
    assign opendrain_mode_bus_wdata       = req_pwdata[2];
    assign watchdog_enable_bus_wdata      = req_pwdata[1];
    assign sync_select_bus_wdata          = req_pwdata[0];
    assign rf_self_test_mode_bus_wdata    = req_pwdata[6];
    assign rf_pkt_data_length_bus_wdata   = req_pwdata[5:4];
    assign rf_capture_mode_bus_wdata      = req_pwdata[3];
    assign rf_capture_start_bus_wdata     = req_pwdata[2];
    assign rf_capture_again_bus_wdata     = req_pwdata[1];
    assign rf_96path_en_bus_wdata         = req_pwdata[0];
    assign rf_pkt_idle_length_bus_wdata   = req_pwdata[15:0];
    assign rf_mdio_memory_addr_bus_wdata  = req_pwdata[14:0];
    assign rf_mdio_data_sel_bus_wdata     = req_pwdata[6:0];
    assign rf_mdio_read_pulse_bus_wdata   = req_pwdata[0];
    assign rf_pktctrl_gap_bus_wdata   = req_pwdata[8:0];
    assign rf_pktctrl_phase_bus_wdata = req_pwdata[8:0];
    assign rf_pktctrl_clk_en_bus_wdata    = req_pwdata[0];
    assign rf_pktctrl_sw_rstn_bus_wdata   = req_pwdata[1];
    assign rf_regfile_sw_rstn_bus_wdata   = req_pwdata[0];

    assign addr_0x0_sel_bus_rdata = {1'h0, legal_phy_addr_bus_rdata, legal_phy_addr_mask_bus_rdata, broadcast_addr_bus_rdata};
    assign addr_0x1_sel_bus_rdata = {11'h0, broadcast_mode_bus_rdata, non_zero_detect_bus_rdata, opendrain_mode_bus_rdata, watchdog_enable_bus_rdata, sync_select_bus_rdata};
    assign addr_0x2_sel_bus_rdata = {9'h0, rf_self_test_mode_bus_rdata, rf_pkt_data_length_bus_rdata, rf_capture_mode_bus_rdata, 1'b0, 1'b0, rf_96path_en_bus_rdata};
    assign addr_0x3_sel_bus_rdata = {rf_pkt_idle_length_bus_rdata};
    assign addr_0x4_sel_bus_rdata = {1'h0, rf_mdio_memory_addr_bus_rdata};
    assign addr_0x5_sel_bus_rdata = {9'h0, rf_mdio_data_sel_bus_rdata};
    assign addr_0x6_sel_bus_rdata = {7'h0, rf_mdio_pkt_data_bus_rdata};
    assign addr_0x7_sel_bus_rdata = {16'h0};
    assign addr_0x8_sel_bus_rdata = {7'h0, rf_pktctrl_gap_bus_rdata};
    assign addr_0x9_sel_bus_rdata = {7'h0, rf_pktctrl_phase_bus_rdata};
    assign addr_0xa_sel_bus_rdata = {15'h0, rf_pktctrl_clk_en_bus_rdata};
    assign addr_0xb_sel_bus_rdata = {14'h0, rf_pktctrl_sw_rstn_bus_rdata, rf_regfile_sw_rstn_bus_rdata};

    assign req_prdata = sel_0x0_bus_rdata;
    assign sel_0x0_bus_rdata = (addr_0x0_sel & ~req_pwrite) ? addr_0x0_sel_bus_rdata : sel_0x1_bus_rdata;
    assign sel_0x1_bus_rdata = (addr_0x1_sel & ~req_pwrite) ? addr_0x1_sel_bus_rdata : sel_0x2_bus_rdata;
    assign sel_0x2_bus_rdata = (addr_0x2_sel & ~req_pwrite) ? addr_0x2_sel_bus_rdata : sel_0x3_bus_rdata;
    assign sel_0x3_bus_rdata = (addr_0x3_sel & ~req_pwrite) ? addr_0x3_sel_bus_rdata : sel_0x4_bus_rdata;
    assign sel_0x4_bus_rdata = (addr_0x4_sel & ~req_pwrite) ? addr_0x4_sel_bus_rdata : sel_0x5_bus_rdata;
    assign sel_0x5_bus_rdata = (addr_0x5_sel & ~req_pwrite) ? addr_0x5_sel_bus_rdata : sel_0x6_bus_rdata;
    assign sel_0x6_bus_rdata = (addr_0x6_sel & ~req_pwrite) ? addr_0x6_sel_bus_rdata : sel_0x7_bus_rdata;
    assign sel_0x7_bus_rdata = (addr_0x7_sel & ~req_pwrite) ? addr_0x7_sel_bus_rdata : sel_0x8_bus_rdata;
    assign sel_0x8_bus_rdata = (addr_0x8_sel & ~req_pwrite) ? addr_0x8_sel_bus_rdata : sel_0x9_bus_rdata;
    assign sel_0x9_bus_rdata = (addr_0x9_sel & ~req_pwrite) ? addr_0x9_sel_bus_rdata : sel_0xa_bus_rdata;
    assign sel_0xa_bus_rdata = (addr_0xa_sel & ~req_pwrite) ? addr_0xa_sel_bus_rdata : sel_0xb_bus_rdata;
    assign sel_0xb_bus_rdata = (addr_0xb_sel & ~req_pwrite) ? addr_0xb_sel_bus_rdata : 16'h0;

    assign legal_phy_addr       = legal_phy_addr_dev_rdata      ;
    assign legal_phy_addr_mask  = legal_phy_addr_mask_dev_rdata ;
    assign broadcast_addr       = broadcast_addr_dev_rdata      ;
    assign broadcast_mode       = broadcast_mode_dev_rdata      ;
    assign non_zero_detect      = non_zero_detect_dev_rdata     ;
    assign opendrain_mode       = opendrain_mode_dev_rdata      ;
    assign watchdog_enable      = watchdog_enable_dev_rdata     ;
    assign sync_select          = sync_select_dev_rdata         ;
    assign rf_pktctrl_gap   = rf_pktctrl_gap_dev_rdata  ;
    assign rf_pktctrl_phase = rf_pktctrl_phase_dev_rdata;
    assign rf_pktctrl_clk_en    = rf_pktctrl_clk_en_dev_rdata   ;
    assign rf_pktctrl_sw_rstn   = rf_pktctrl_sw_rstn_dev_rdata  ;
    assign rf_regfile_sw_rstn   = rf_regfile_sw_rstn_dev_rdata  ;
    assign rf_self_test_mode    = rf_self_test_mode_dev_rdata   ;
    assign rf_capture_mode      = rf_capture_mode_dev_rdata     ;
    assign rf_capture_start     = rf_capture_start_dev_rdata    ;
    assign rf_capture_again     = rf_capture_again_dev_rdata    ;
    assign rf_96path_en         = rf_96path_en_dev_rdata        ;
    assign rf_pkt_data_length   = rf_pkt_data_length_dev_rdata  ;
    assign rf_pkt_idle_length   = rf_pkt_idle_length_dev_rdata  ;
    assign rf_mdio_read_pulse   = rf_mdio_read_pulse_dev_rdata  ;
    assign rf_mdio_data_sel     = rf_mdio_data_sel_dev_rdata    ;
    assign rf_mdio_memory_addr  = rf_mdio_memory_addr_dev_rdata ;

    assign rf_mdio_pkt_data_dev_wdata = rf_mdio_pkt_data;
    assign rf_mdio_pkt_data_dev_we = rf_mdio_pkt_data_we;

    Cell_RWR#(
        .DATA_WIDTH (5      ),
        .INIT       (5'h1f  ))
    u_legal_phy_addr
    (
    .clk            (legal_phy_addr_clk      ),
    .rstn           (legal_phy_addr_rstn     ),
    .bus_we         (legal_phy_addr_bus_we   ),
    .bus_wdata      (legal_phy_addr_bus_wdata),
    .bus_rdata      (legal_phy_addr_bus_rdata),
    .dev_rdata      (legal_phy_addr_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (5      ),
        .INIT       (5'h1f  ))
    u_legal_phy_addr_mask
    (
    .clk            (legal_phy_addr_mask_clk      ),
    .rstn           (legal_phy_addr_mask_rstn     ),
    .bus_we         (legal_phy_addr_mask_bus_we   ),
    .bus_wdata      (legal_phy_addr_mask_bus_wdata),
    .bus_rdata      (legal_phy_addr_mask_bus_rdata),
    .dev_rdata      (legal_phy_addr_mask_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (5      ),
        .INIT       (5'h1f  ))
    u_broadcast_addr
    (
    .clk            (broadcast_addr_clk      ),
    .rstn           (broadcast_addr_rstn     ),
    .bus_we         (broadcast_addr_bus_we   ),
    .bus_wdata      (broadcast_addr_bus_wdata),
    .bus_rdata      (broadcast_addr_bus_rdata),
    .dev_rdata      (broadcast_addr_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h1   ))
    u_broadcast_mode
    (
    .clk            (broadcast_mode_clk      ),
    .rstn           (broadcast_mode_rstn     ),
    .bus_we         (broadcast_mode_bus_we   ),
    .bus_wdata      (broadcast_mode_bus_wdata),
    .bus_rdata      (broadcast_mode_bus_rdata),
    .dev_rdata      (broadcast_mode_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h0   ))
    u_non_zero_detect
    (
    .clk            (non_zero_detect_clk      ),
    .rstn           (non_zero_detect_rstn     ),
    .bus_we         (non_zero_detect_bus_we   ),
    .bus_wdata      (non_zero_detect_bus_wdata),
    .bus_rdata      (non_zero_detect_bus_rdata),
    .dev_rdata      (non_zero_detect_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h1   ))
    u_opendrain_mode
    (
    .clk            (opendrain_mode_clk      ),
    .rstn           (opendrain_mode_rstn     ),
    .bus_we         (opendrain_mode_bus_we   ),
    .bus_wdata      (opendrain_mode_bus_wdata),
    .bus_rdata      (opendrain_mode_bus_rdata),
    .dev_rdata      (opendrain_mode_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h0   ))
    u_watchdog_enable
    (
    .clk            (watchdog_enable_clk      ),
    .rstn           (watchdog_enable_rstn     ),
    .bus_we         (watchdog_enable_bus_we   ),
    .bus_wdata      (watchdog_enable_bus_wdata),
    .bus_rdata      (watchdog_enable_bus_rdata),
    .dev_rdata      (watchdog_enable_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h0   ))
    u_sync_select
    (
    .clk            (sync_select_clk      ),
    .rstn           (sync_select_rstn     ),
    .bus_we         (sync_select_bus_we   ),
    .bus_wdata      (sync_select_bus_wdata),
    .bus_rdata      (sync_select_bus_rdata),
    .dev_rdata      (sync_select_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h0   ))
    u_rf_self_test_mode
    (
    .clk            (rf_self_test_mode_clk      ),
    .rstn           (rf_self_test_mode_rstn     ),
    .bus_we         (rf_self_test_mode_bus_we   ),
    .bus_wdata      (rf_self_test_mode_bus_wdata),
    .bus_rdata      (rf_self_test_mode_bus_rdata),
    .dev_rdata      (rf_self_test_mode_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (2      ),
        .INIT       (2'h0   ))
    u_rf_pkt_data_length    
    (
    .clk            (rf_pkt_data_length_clk      ),
    .rstn           (rf_pkt_data_length_rstn     ),
    .bus_we         (rf_pkt_data_length_bus_we   ),
    .bus_wdata      (rf_pkt_data_length_bus_wdata),
    .bus_rdata      (rf_pkt_data_length_bus_rdata),
    .dev_rdata      (rf_pkt_data_length_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h0   ))
    u_rf_capture_mode    
    (
    .clk            (rf_capture_mode_clk      ),
    .rstn           (rf_capture_mode_rstn     ),
    .bus_we         (rf_capture_mode_bus_we   ),
    .bus_wdata      (rf_capture_mode_bus_wdata),
    .bus_rdata      (rf_capture_mode_bus_rdata),
    .dev_rdata      (rf_capture_mode_dev_rdata)
    );

    Cell_SC
    u_rf_capture_start
    (
    .clk            (rf_capture_start_clk      ),
    .rstn           (rf_capture_start_rstn     ),
    .bus_we         (rf_capture_start_bus_we   ),
    .bus_wdata      (rf_capture_start_bus_wdata),
    .dev_rdata      (rf_capture_start_dev_rdata)
    );

    Cell_SC
    u_rf_capture_again
    (
    .clk            (rf_capture_again_clk      ),
    .rstn           (rf_capture_again_rstn     ),
    .bus_we         (rf_capture_again_bus_we   ),
    .bus_wdata      (rf_capture_again_bus_wdata),
    .dev_rdata      (rf_capture_again_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h1   ))
    u_rf_96path_en    
    (
    .clk            (rf_96path_en_clk      ),
    .rstn           (rf_96path_en_rstn     ),
    .bus_we         (rf_96path_en_bus_we   ),
    .bus_wdata      (rf_96path_en_bus_wdata),
    .bus_rdata      (rf_96path_en_bus_rdata),
    .dev_rdata      (rf_96path_en_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (16      ),
        .INIT       (16'h7fff))
    u_rf_pkt_idle_length        
    (
    .clk            (rf_pkt_idle_length_clk      ),
    .rstn           (rf_pkt_idle_length_rstn     ),
    .bus_we         (rf_pkt_idle_length_bus_we   ),
    .bus_wdata      (rf_pkt_idle_length_bus_wdata),
    .bus_rdata      (rf_pkt_idle_length_bus_rdata),
    .dev_rdata      (rf_pkt_idle_length_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (15     ),
        .INIT       (15'h0  ))
    u_rf_mdio_memory_addr
    (
    .clk            (rf_mdio_memory_addr_clk      ),
    .rstn           (rf_mdio_memory_addr_rstn     ),
    .bus_we         (rf_mdio_memory_addr_bus_we   ),
    .bus_wdata      (rf_mdio_memory_addr_bus_wdata),
    .bus_rdata      (rf_mdio_memory_addr_bus_rdata),
    .dev_rdata      (rf_mdio_memory_addr_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (7      ),
        .INIT       (7'h0   ))
    u_rf_mdio_data_sel
    (
    .clk            (rf_mdio_data_sel_clk      ),
    .rstn           (rf_mdio_data_sel_rstn     ),
    .bus_we         (rf_mdio_data_sel_bus_we   ),
    .bus_wdata      (rf_mdio_data_sel_bus_wdata),
    .bus_rdata      (rf_mdio_data_sel_bus_rdata),
    .dev_rdata      (rf_mdio_data_sel_dev_rdata)
    );

    Cell_RODEV#(
        .DATA_WIDTH (9      ),
        .INIT       (9'h0   ))
    u_rf_mdio_pkt_data
    (
    .clk            (rf_mdio_pkt_data_clk      ),
    .rstn           (rf_mdio_pkt_data_rstn     ),
    .bus_rdata      (rf_mdio_pkt_data_bus_rdata),
    .dev_we         (rf_mdio_pkt_data_dev_we   ),
    .dev_wdata      (rf_mdio_pkt_data_dev_wdata)
    );

    Cell_SC
    u_rf_mdio_read_pulse
    (
    .clk            (rf_mdio_read_pulse_clk      ),
    .rstn           (rf_mdio_read_pulse_rstn     ),
    .bus_we         (rf_mdio_read_pulse_bus_we   ),
    .bus_wdata      (rf_mdio_read_pulse_bus_wdata),
    .dev_rdata      (rf_mdio_read_pulse_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (9      ),
        .INIT       (9'h0   ))
    u_rf_pktctrl_gap    
    (
    .clk            (rf_pktctrl_gap_clk      ),
    .rstn           (rf_pktctrl_gap_rstn     ),
    .bus_we         (rf_pktctrl_gap_bus_we   ),
    .bus_wdata      (rf_pktctrl_gap_bus_wdata),
    .bus_rdata      (rf_pktctrl_gap_bus_rdata),
    .dev_rdata      (rf_pktctrl_gap_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (9      ),
        .INIT       (9'h0   ))
    u_rf_pktctrl_phase    
    (
    .clk            (rf_pktctrl_phase_clk      ),
    .rstn           (rf_pktctrl_phase_rstn     ),
    .bus_we         (rf_pktctrl_phase_bus_we   ),
    .bus_wdata      (rf_pktctrl_phase_bus_wdata),
    .bus_rdata      (rf_pktctrl_phase_bus_rdata),
    .dev_rdata      (rf_pktctrl_phase_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h1   ))
    u_rf_pktctrl_clk_en    
    (
    .clk            (rf_pktctrl_clk_en_clk      ),
    .rstn           (rf_pktctrl_clk_en_rstn     ),
    .bus_we         (rf_pktctrl_clk_en_bus_we   ),
    .bus_wdata      (rf_pktctrl_clk_en_bus_wdata),
    .bus_rdata      (rf_pktctrl_clk_en_bus_rdata),
    .dev_rdata      (rf_pktctrl_clk_en_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h1   ))
    u_rf_pktctrl_sw_rstn    
    (
    .clk            (rf_pktctrl_sw_rstn_clk      ),
    .rstn           (rf_pktctrl_sw_rstn_rstn     ),
    .bus_we         (rf_pktctrl_sw_rstn_bus_we   ),
    .bus_wdata      (rf_pktctrl_sw_rstn_bus_wdata),
    .bus_rdata      (rf_pktctrl_sw_rstn_bus_rdata),
    .dev_rdata      (rf_pktctrl_sw_rstn_dev_rdata)
    );

    Cell_RWR#(
        .DATA_WIDTH (1      ),
        .INIT       (1'h1   ))
    u_rf_regfile_sw_rstn    
    (
    .clk            (rf_regfile_sw_rstn_clk      ),
    .rstn           (rf_regfile_sw_rstn_rstn     ),
    .bus_we         (rf_regfile_sw_rstn_bus_we   ),
    .bus_wdata      (rf_regfile_sw_rstn_bus_wdata),
    .bus_rdata      (rf_regfile_sw_rstn_bus_rdata),
    .dev_rdata      (rf_regfile_sw_rstn_dev_rdata)
    );

endmodule
