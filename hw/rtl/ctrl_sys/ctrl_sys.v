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
//  2024-05-06    zlguo         1.0         ctrl_sys
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module ctrl_sys
(
    input   wire            clk_200m,
    input   wire            rstn_200m,

    input   wire            pktctrl_clk,
    input   wire            pktctrl_rstn,

    input   wire            mdio_in,
    input   wire            mdc,
    output  wire            mdio_out,
    output  wire            mdio_oen,

    // Digital config register
    output  wire            rf_pktctrl_clk_en,
    output  wire            rf_pktctrl_sw_rstn,

    output  wire            rf_self_test_mode_sync,

    output  wire            rf_capture_mode_sync,
    output  wire            rf_capture_start_sync,
    output  wire            rf_capture_again_sync,

    output  wire            rf_96path_en_sync,
    output  wire    [1:0]   rf_pkt_data_length_sync,
    output  wire    [15:0]  rf_pkt_idle_length_sync,

    output  wire    [8:0]   rf_pktctrl_gap_sync,
    output  wire    [8:0]   rf_pktctrl_phase_sync,

    output  wire    [6:0]   rf_mdio_data_sel_sync,
    output  wire    [14:0]  rf_mdio_memory_addr_sync,

    input   wire    [8:0]   rf_mdio_pkt_data,

    output  wire            capture_enable  ,
    output  wire            capture_start   ,

    output  wire    [3:0]   capture_mode    ,
    output  wire    [12:0]  capture_max_addr,
    output  wire    [12:0]  pre_trigger_num ,

    output  wire    [15:0]  trigger_pattern0,
    output  wire    [15:0]  trigger_pattern1,
    output  wire    [15:0]  trigger_mode0   ,
    output  wire    [15:0]  trigger_mode1   ,
    output  wire    [15:0]  trigger_mode2   ,
    output  wire    [15:0]  trigger_mode3   ,
    output  wire    [15:0]  trigger_mode4   ,
    output  wire    [15:0]  trigger_mode5   ,
    output  wire    [15:0]  trigger_logic0  ,
    output  wire    [15:0]  trigger_logic1  ,
    output  wire            store_mode      ,

    input   wire    [12:0]  read_start_addr ,
    input   wire    [12:0]  tri_addr        ,
    output  wire            capture_done_rd ,
    input   wire            capture_done    ,

    output  wire            tri_succeed_cnt_overflow_mode,
    output  wire            tri_succeed_cnt_clr ,
    input   wire    [7:0]   tri_succeed_cnt ,

    output  wire            capture_rd_en   ,
    output  wire    [12:0]  capture_rd_addr ,
    input   wire    [15:0]  capture_rd_data0,
    input   wire    [15:0]  capture_rd_data1

);

    wire    [4 :0]  legal_phy_addr;
    wire    [4 :0]  legal_phy_addr_mask;
    wire    [4 :0]  broadcast_addr;
    wire            broadcast_mode;
    wire            non_zero_detect;
    wire            opendrain_mode;
    wire            watchdog_enable;
    wire            sync_select;

    wire    [20:0]  req_paddr;
    wire            req_pwrite;
    wire            req_psel;
    wire            req_penable;
    wire    [15:0]  req_pwdata;

    wire            req_pready;
    wire    [15:0]  req_prdata;

    wire            rf_self_test_mode;

    wire            rf_capture_mode;
    wire            rf_capture_start;
    wire            rf_capture_again;

    wire            rf_96path_en;
    wire    [1:0]   rf_pkt_data_length;
    wire    [15:0]  rf_pkt_idle_length;

    wire    [8:0]   rf_pktctrl_gap;
    wire    [8:0]   rf_pktctrl_phase;

    wire    [6:0]   rf_mdio_data_sel;
    wire    [14:0]  rf_mdio_memory_addr;

    wire    [8:0]   rf_mdio_pkt_data_sync;
    wire            rf_mdio_pkt_data_we;

    mdio_top
    u_mdio
    (
    .clk_200m                   (clk_200m                   ),
    .rstn_200m                  (rstn_200m                  ),
    .mdio_in                    (mdio_in                    ),
    .mdc                        (mdc                        ),
    .mdio_out                   (mdio_out                   ),
    .mdio_oen                   (mdio_oen                   ),

    .legal_phy_addr             (legal_phy_addr             ),
    .legal_phy_addr_mask        (legal_phy_addr_mask        ),
    .broadcast_addr             (broadcast_addr             ),
    .broadcast_mode             (broadcast_mode             ),
    .non_zero_detect            (non_zero_detect            ),
    .opendrain_mode             (opendrain_mode             ),
    .watchdog_enable            (watchdog_enable            ),
    .sync_select                (sync_select                ),

    .req_paddr                  (req_paddr                  ),
    .req_pwrite                 (req_pwrite                 ),
    .req_psel                   (req_psel                   ),
    .req_pwdata                 (req_pwdata                 ),
    .req_pready                 (req_pready                 ),
    .req_prdata                 (req_prdata                 )
    );

    top_regfile
    u_top_regfile
    (
    .clk                        (clk_200m                   ),
    .rstn                       (rstn_200m                  ),
    .req_addr                   (req_paddr                  ),
    .req_write                  (req_pwrite                 ),
    .req_sel                    (req_psel                   ),
    .req_wdata                  (req_pwdata                 ),
    .req_ready                  (req_pready                 ),
    .req_rdata                  (req_prdata                 ),

    .legal_phy_addr_rdata       (legal_phy_addr             ),
    .legal_phy_addr_mask_rdata  (legal_phy_addr_mask        ),
    .broadcast_addr_rdata       (broadcast_addr             ),
    .broadcast_mode_rdata       (broadcast_mode             ),
    .non_zero_detect_rdata      (non_zero_detect            ),
    .opendrain_mode_rdata       (opendrain_mode             ),
    .watchdog_enable_rdata      (watchdog_enable            ),
    .sync_select_rdata          (sync_select                ),

    .rf_pktctrl_gap_rdata       (rf_pktctrl_gap             ),
    .rf_pktctrl_phase_rdata     (rf_pktctrl_phase           ),
    .rf_pktctrl_clk_en_rdata    (rf_pktctrl_clk_en          ),
    .rf_pktctrl_sw_rstn_rdata   (rf_pktctrl_sw_rstn         ),
    .rf_self_test_mode_rdata    (rf_self_test_mode          ),
    .rf_capture_mode_rdata      (rf_capture_mode            ),
    .rf_capture_start_rdata     (rf_capture_start           ),
    .rf_capture_again_rdata     (rf_capture_again           ),
    .rf_96path_en_rdata         (rf_96path_en               ),
    .rf_pkt_data_length_rdata   (rf_pkt_data_length         ),
    .rf_pkt_idle_length_rdata   (rf_pkt_idle_length         ),
    .rf_mdio_data_sel_rdata     (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr_rdata  (rf_mdio_memory_addr        ),
    .rf_mdio_pkt_data_wdata     (rf_mdio_pkt_data_sync      ),
    .rf_mdio_pkt_data_we        (rf_mdio_pkt_data_we        ),

    // dbg
    .capture_enable_rdata       (capture_enable             ),
    .capture_start_rdata        (capture_start              ),

    .capture_mode_rdata         (capture_mode               ),
    .capture_max_addr_rdata     (capture_max_addr           ),
    .pre_trigger_num_rdata      (pre_trigger_num            ),

    .trigger_pattern0_rdata     (trigger_pattern0           ),
    .trigger_pattern1_rdata     (trigger_pattern1           ),
    .trigger_mode0_rdata        (trigger_mode0              ),
    .trigger_mode1_rdata        (trigger_mode1              ),
    .trigger_mode2_rdata        (trigger_mode2              ),
    .trigger_mode3_rdata        (trigger_mode3              ),
    .trigger_mode4_rdata        (trigger_mode4              ),
    .trigger_mode5_rdata        (trigger_mode5              ),
    .trigger_logic0_rdata       (trigger_logic0             ),
    .trigger_logic1_rdata       (trigger_logic1             ),
    .store_mode_rdata           (store_mode                 ),

    .read_start_addr_wdata      (read_start_addr_sync       ),
    .read_start_addr_we         (read_start_addr_we         ),
    .tri_addr_wdata             (tri_addr_sync              ),
    .tri_addr_we                (tri_addr_we                ),
    .capture_done_rd_rdata      (capture_done_rd            ),
    .capture_done_wdata         (capture_done_sync          ),
    .capture_done_we            (capture_done_we            ),

    .tri_succeed_cnt_overflow_mode_rdata(tri_succeed_cnt_overflow_mode),
    .tri_succeed_cnt_clr_rdata  (tri_succeed_cnt_clr        ),
    .tri_succeed_cnt_wdata      (tri_succeed_cnt_sync       ),
    .tri_succeed_cnt_we         (tri_succeed_cnt_we         ),

    .capture_rd_en_rdata        (capture_rd_en              ),
    .capture_rd_addr_rdata      (capture_rd_addr            ),
    .capture_rd_data0_wdata     (capture_rd_data0_sync      ),
    .capture_rd_data0_we        (capture_rd_data0_we        ),
    .capture_rd_data1_wdata     (capture_rd_data1_sync      )
    .capture_rd_data1_we        (capture_rd_data1_we        )
    );

    cdc_500_200
    u_cdc_500_200
    (
    .clk_200m                   (clk_200m                   ),
    .pktctrl_clk                (pktctrl_clk                ),
    .rstn_200m                  (rstn_200m                  ),
    .pktctrl_rstn               (pktctrl_rstn               ),

    .rf_self_test_mode          (rf_self_test_mode          ),
    .rf_capture_mode            (rf_capture_mode            ),
    .rf_capture_start           (rf_capture_start           ),
    .rf_capture_again           (rf_capture_again           ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_pkt_data_length         (rf_pkt_data_length         ),
    .rf_pkt_idle_length         (rf_pkt_idle_length         ),
    .rf_pktctrl_gap             (rf_pktctrl_gap             ),
    .rf_pktctrl_phase           (rf_pktctrl_phase           ),
    .rf_mdio_data_sel           (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr        (rf_mdio_memory_addr        ),

    .rf_mdio_pkt_data           (rf_mdio_pkt_data           ),

    .rf_self_test_mode_sync     (rf_self_test_mode_sync     ),
    .rf_capture_mode_sync       (rf_capture_mode_sync       ),
    .rf_capture_start_sync      (rf_capture_start_sync      ),
    .rf_capture_again_sync      (rf_capture_again_sync      ),
    .rf_96path_en_sync          (rf_96path_en_sync          ),
    .rf_pkt_data_length_sync    (rf_pkt_data_length_sync    ),
    .rf_pkt_idle_length_sync    (rf_pkt_idle_length_sync    ),
    .rf_pktctrl_gap_sync        (rf_pktctrl_gap_sync        ),
    .rf_pktctrl_phase_sync      (rf_pktctrl_phase_sync      ),
    .rf_mdio_data_sel_sync      (rf_mdio_data_sel_sync      ),
    .rf_mdio_memory_addr_sync   (rf_mdio_memory_addr_sync   ),

    .rf_mdio_pkt_data_sync      (rf_mdio_pkt_data_sync      ),
    .rf_mdio_pkt_data_we        (rf_mdio_pkt_data_we        )
    );

endmodule
