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
    output  wire    [8:0]   rf_pktctrl_clk_div,
    output  wire    [8:0]   rf_pktctrl_clk_phase,

    output  wire            rf_pktctrl_clk_en,
    output  wire            rf_pktctrl_sw_rstn,
    output  wire            rf_regfile_sw_rstn,

    output  wire            rf_self_test_mode_sync,

    output  wire            rf_capture_mode_sync,
    output  wire            rf_capture_start_sync,
    output  wire            rf_capture_again_sync,

    output  wire            rf_96path_en_sync,
    output  wire    [1:0]   rf_pkt_data_length_sync,
    output  wire    [15:0]  rf_pkt_idle_length_sync,

    output  wire            rf_mdio_read_pulse_sync,
    output  wire    [6:0]   rf_mdio_data_sel_sync,
    output  wire    [14:0]  rf_mdio_memory_addr_sync,

    input   wire            mdio_read_pulse_r,
    input   wire    [8:0]   rf_mdio_pkt_data

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
    wire            req_pslverr;

    wire            rf_self_test_mode;

    wire            rf_capture_mode;
    wire            rf_capture_start;
    wire            rf_capture_again;

    wire            rf_96path_en;
    wire    [1:0]   rf_pkt_data_length;
    wire    [15:0]  rf_pkt_idle_length;

    wire            rf_mdio_read_pulse;
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
    .req_penable                (req_penable                ),
    .req_pwdata                 (req_pwdata                 ),
    .req_pready                 (req_pready                 ),
    .req_prdata                 (req_prdata                 )
    );

    top_regfile
    u_top_regfile
    (
    .clk                        (clk_200m                   ),
    .rstn                       (rstn_200m                  ),
    .req_paddr                  (req_paddr                  ),
    .req_pwrite                 (req_pwrite                 ),
    .req_psel                   (req_psel                   ),
    .req_penable                (req_penable                ),
    .req_pwdata                 (req_pwdata                 ),
    .req_pready                 (req_pready                 ),
    .req_prdata                 (req_prdata                 ),

    .legal_phy_addr             (legal_phy_addr             ),
    .legal_phy_addr_mask        (legal_phy_addr_mask        ),
    .broadcast_addr             (broadcast_addr             ),
    .broadcast_mode             (broadcast_mode             ),
    .non_zero_detect            (non_zero_detect            ),
    .opendrain_mode             (opendrain_mode             ),
    .watchdog_enable            (watchdog_enable            ),
    .sync_select                (sync_select                ),

    .rf_pktctrl_clk_div         (rf_pktctrl_clk_div         ),
    .rf_pktctrl_clk_phase       (rf_pktctrl_clk_phase       ),
    .rf_pktctrl_clk_en          (rf_pktctrl_clk_en          ),
    .rf_pktctrl_sw_rstn         (rf_pktctrl_sw_rstn         ),
    .rf_regfile_sw_rstn         (rf_regfile_sw_rstn         ),
    .rf_self_test_mode          (rf_self_test_mode          ),
    .rf_capture_mode            (rf_capture_mode            ),
    .rf_capture_start           (rf_capture_start           ),
    .rf_capture_again           (rf_capture_again           ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_pkt_data_length         (rf_pkt_data_length         ),
    .rf_pkt_idle_length         (rf_pkt_idle_length         ),
    .rf_mdio_read_pulse         (rf_mdio_read_pulse         ),
    .rf_mdio_data_sel           (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr        (rf_mdio_memory_addr        ),
    .rf_mdio_pkt_data           (rf_mdio_pkt_data_sync      ),
    .rf_mdio_pkt_data_we        (rf_mdio_pkt_data_we        )
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
    .rf_mdio_read_pulse         (rf_mdio_read_pulse         ),
    .rf_mdio_data_sel           (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr        (rf_mdio_memory_addr        ),

    .mdio_read_pulse_r          (mdio_read_pulse_r          ),
    .rf_mdio_pkt_data           (rf_mdio_pkt_data           ),

    .rf_self_test_mode_sync     (rf_self_test_mode_sync     ),
    .rf_capture_mode_sync       (rf_capture_mode_sync       ),
    .rf_capture_start_sync      (rf_capture_start_sync      ),
    .rf_capture_again_sync      (rf_capture_again_sync      ),
    .rf_96path_en_sync          (rf_96path_en_sync          ),
    .rf_pkt_data_length_sync    (rf_pkt_data_length_sync    ),
    .rf_pkt_idle_length_sync    (rf_pkt_idle_length_sync    ),
    .rf_mdio_read_pulse_sync    (rf_mdio_read_pulse_sync    ),
    .rf_mdio_data_sel_sync      (rf_mdio_data_sel_sync      ),
    .rf_mdio_memory_addr_sync   (rf_mdio_memory_addr_sync   ),

    .rf_mdio_pkt_data_sync      (rf_mdio_pkt_data_sync      ),
    .rf_mdio_pkt_data_we        (rf_mdio_pkt_data_we        )
    );

endmodule
