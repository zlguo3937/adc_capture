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
#(
    parameter ADDR_WIDTH    = 21,
    parameter DATA_WIDTH    = 16,
    parameter CFG_TIMEOUT   = 16
)
(
    input   wire                        clk_200m,
    input   wire                        rstn_200m,

    input   wire                        pktctrl_clk,
    input   wire                        pktctrl_rstn,

    input   wire                        mdio_in,
    input   wire                        mdc,
    output  wire                        mdio_out,
    output  wire                        mdio_oen,

    /* -----------------------------
     apb interface
     ---------------------------- */
    input   wire    [31:0]              apb_paddr,
    input   wire                        apb_penable,
    input   wire                        apb_psel,
    input   wire                        apb_pwrite,
    input   wire    [31:0]              apb_pwdata,
    output  wire                        apb_pready,
    output  wire    [31:0]              apb_prdata,

    /* -----------------------------
     regmapping interface
     ---------------------------- */
    output  wire    [ADDR_WIDTH-1:0]    bp_req_addr ,
    input   wire                        bp_req_ready,
    input   wire    [DATA_WIDTH-1:0]    bp_req_rdata,
    output  wire                        bp_req_write,
    output  wire                        bp_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    bp_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    bw_req_addr ,
    input   wire                        bw_req_ready,
    input   wire    [DATA_WIDTH-1:0]    bw_req_rdata,
    output  wire                        bw_req_write,
    output  wire                        bw_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    bw_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    mem_req_addr ,
    input   wire                        mem_req_ready,
    input   wire    [DATA_WIDTH-1:0]    mem_req_rdata,
    output  wire                        mem_req_write,
    output  wire                        mem_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    mem_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    pma_req_addr ,
    input   wire                        pma_req_ready,
    input   wire    [DATA_WIDTH-1:0]    pma_req_rdata,
    output  wire                        pma_req_write,
    output  wire                        pma_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    pma_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    dbg_req_addr ,
    input   wire                        dbg_req_ready,
    input   wire    [DATA_WIDTH-1:0]    dbg_req_rdata,
    output  wire                        dbg_req_write,
    output  wire                        dbg_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    dbg_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    pktbist_req_addr ,
    input   wire                        pktbist_req_ready,
    input   wire    [DATA_WIDTH-1:0]    pktbist_req_rdata,
    output  wire                        pktbist_req_write,
    output  wire                        pktbist_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    pktbist_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    serdes_req_addr ,
    input   wire                        serdes_req_ready,
    input   wire    [DATA_WIDTH-1:0]    serdes_req_rdata,
    output  wire                        serdes_req_write,
    output  wire                        serdes_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    serdes_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    xmii_bdg_req_addr ,
    input   wire                        xmii_bdg_req_ready,
    input   wire    [DATA_WIDTH-1:0]    xmii_bdg_req_rdata,
    output  wire                        xmii_bdg_req_write,
    output  wire                        xmii_bdg_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    xmii_bdg_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    rgmii_req_addr ,
    input   wire                        rgmii_req_ready,
    input   wire    [DATA_WIDTH-1:0]    rgmii_req_rdata,
    output  wire                        rgmii_req_write,
    output  wire                        rgmii_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    rgmii_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    ptp_req_addr ,
    input   wire                        ptp_req_ready,
    input   wire    [DATA_WIDTH-1:0]    ptp_req_rdata,
    output  wire                        ptp_req_write,
    output  wire                        ptp_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    ptp_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    xmii_rmtcg_req_addr ,
    input   wire                        xmii_rmtcg_req_ready,
    input   wire    [DATA_WIDTH-1:0]    xmii_rmtcg_req_rdata,
    output  wire                        xmii_rmtcg_req_write,
    output  wire                        xmii_rmtcg_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    xmii_rmtcg_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    iopad_req_addr ,
    input   wire                        iopad_req_ready,
    input   wire    [DATA_WIDTH-1:0]    iopad_req_rdata,
    output  wire                        iopad_req_write,
    output  wire                        iopad_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    iopad_req_wdata,

    output  wire    [ADDR_WIDTH-1:0]    analog_req_addr ,
    input   wire                        analog_req_ready,
    input   wire    [DATA_WIDTH-1:0]    analog_req_rdata,
    output  wire                        analog_req_write,
    output  wire                        analog_req_sel  ,
    output  wire    [DATA_WIDTH-1:0]    analog_req_wdata,

    // config register
    output  wire                        rf_pktctrl_clk_en,
    output  wire                        rf_pktctrl_sw_rstn,

    output  wire                        rf_self_test_mode_sync,

    output  wire                        rf_capture_mode_sync,
    output  wire                        rf_capture_start_sync,
    output  wire                        rf_capture_again_sync,

    output  wire                        rf_96path_en_sync,
    output  wire    [1:0]               rf_pkt_data_length_sync,
    output  wire    [15:0]              rf_pkt_idle_length_sync,

    output  wire    [8:0]               rf_pktctrl_gap_sync,
    output  wire    [8:0]               rf_pktctrl_phase_sync,

    output  wire    [6:0]               rf_mdio_data_sel_sync,
    output  wire    [14:0]              rf_mdio_memory_addr_sync,

    input   wire    [8:0]               rf_mdio_pkt_data

);

    wire    [15:0]              cfg_timeout_rdata;

    wire    [4 :0]              legal_phy_addr;
    wire    [4 :0]              legal_phy_addr_mask;
    wire    [4 :0]              broadcast_addr;
    wire                        broadcast_mode;
    wire                        non_zero_detect;
    wire                        opendrain_mode;
    wire                        watchdog_enable;
    wire                        sync_select;

    wire                        rf_self_test_mode;

    wire                        rf_capture_mode;
    wire                        rf_capture_start;
    wire                        rf_capture_again;

    wire                        rf_96path_en;
    wire    [1:0]               rf_pkt_data_length;
    wire    [15:0]              rf_pkt_idle_length;

    wire    [8:0]               rf_pktctrl_gap;
    wire    [8:0]               rf_pktctrl_phase;

    wire    [6:0]               rf_mdio_data_sel;
    wire    [14:0]              rf_mdio_memory_addr;

    wire    [8:0]               rf_mdio_pkt_data_sync;
    wire                        rf_mdio_pkt_data_we;

    wire    [ADDR_WIDTH-1:0]    mdio_paddr;
    wire                        mdio_penable;
    wire                        mdio_psel;
    wire                        mdio_pwrite;
    wire    [DATA_WIDTH-1:0]    mdio_pwdata;
    wire                        mdio_pready;
    wire    [DATA_WIDTH-1:0]    mdio_prdata;

    wire    [ADDR_WIDTH-1:0]    cpu_paddr;
    wire                        cpu_penable;
    wire                        cpu_psel;
    wire                        cpu_pwrite;
    wire    [DATA_WIDTH-1:0]    cpu_pwdata;
    wire                        cpu_pready;
    wire    [DATA_WIDTH-1:0]    cpu_prdata;

    wire    [ADDR_WIDTH-1:0]    top_req_addr ;
    wire                        top_req_ready;
    wire    [DATA_WIDTH-1:0]    top_req_rdata;
    wire                        top_req_write;
    wire                        top_req_sel  ;
    wire    [DATA_WIDTH-1:0]    top_req_wdata;

    apb_mapper #(21,16,16)
    u_apb_mapper(
    .clk                        (clk                        ),
    .rstn                       (rstn                       ),

    .cfg_timeout                (cfg_timeout_rdata          ),

    .mdio_paddr                 (mdio_paddr                 ),
    .mdio_penable               (mdio_penable               ),
    .mdio_psel                  (mdio_psel                  ),
    .mdio_pwrite                (mdio_pwrite                ),
    .mdio_pwdata                (mdio_pwdata                ),
    .mdio_pready                (mdio_pready                ),
    .mdio_prdata                (mdio_prdata                ),
                                                            
    .cpu_paddr                  (cpu_paddr                  ),
    .cpu_penable                (cpu_penable                ),
    .cpu_psel                   (cpu_psel                   ),
    .cpu_pwrite                 (cpu_pwrite                 ),
    .cpu_pwdata                 (cpu_pwdata                 ),
    .cpu_pready                 (cpu_pready                 ),
    .cpu_prdata                 (cpu_prdata                 ),
                                                            
    .apb_paddr                  (apb_paddr                  ),
    .apb_penable                (apb_penable                ),
    .apb_psel                   (apb_psel                   ),
    .apb_pwrite                 (apb_pwrite                 ),
    .apb_pwdata                 (apb_pwdata                 ),
    .apb_pready                 (apb_pready                 ),
    .apb_prdata                 (apb_prdata                 ),
                                                            
    .top_req_addr               (top_req_addr               ),
    .top_req_ready              (top_req_ready              ),
    .top_req_rdata              (top_req_rdata              ),
    .top_req_write              (top_req_write              ),
    .top_req_sel                (top_req_sel                ),
    .top_req_wdata              (top_req_wdata              ),
                                                            
    .bp_req_addr                (bp_req_addr                ),
    .bp_req_ready               (bp_req_ready               ),
    .bp_req_rdata               (bp_req_rdata               ),
    .bp_req_write               (bp_req_write               ),
    .bp_req_sel                 (bp_req_sel                 ),
    .bp_req_wdata               (bp_req_wdata               ),
                                                            
    .bw_req_addr                (bw_req_addr                ),
    .bw_req_ready               (bw_req_ready               ),
    .bw_req_rdata               (bw_req_rdata               ),
    .bw_req_write               (bw_req_write               ),
    .bw_req_sel                 (bw_req_sel                 ),
    .bw_req_wdata               (bw_req_wdata               ),
                                                            
    .mem_req_addr               (mem_req_addr               ),
    .mem_req_ready              (mem_req_ready              ),
    .mem_req_rdata              (mem_req_rdata              ),
    .mem_req_write              (mem_req_write              ),
    .mem_req_sel                (mem_req_sel                ),
    .mem_req_wdata              (mem_req_wdata              ),
                                                            
    .pma_req_addr               (pma_req_addr               ),
    .pma_req_ready              (pma_req_ready              ),
    .pma_req_rdata              (pma_req_rdata              ),
    .pma_req_write              (pma_req_write              ),
    .pma_req_sel                (pma_req_sel                ),
    .pma_req_wdata              (pma_req_wdata              ),
                                                            
    .dbg_req_addr               (dbg_req_addr               ),
    .dbg_req_ready              (dbg_req_ready              ),
    .dbg_req_rdata              (dbg_req_rdata              ),
    .dbg_req_write              (dbg_req_write              ),
    .dbg_req_sel                (dbg_req_sel                ),
    .dbg_req_wdata              (dbg_req_wdata              ),
                                                            
    .pktbist_req_addr           (pktbist_req_addr           ),
    .pktbist_req_ready          (pktbist_req_ready          ),
    .pktbist_req_rdata          (pktbist_req_rdata          ),
    .pktbist_req_write          (pktbist_req_write          ),
    .pktbist_req_sel            (pktbist_req_sel            ),
    .pktbist_req_wdata          (pktbist_req_wdata          ),
                                                            
    .serdes_req_addr            (serdes_req_addr            ),
    .serdes_req_ready           (serdes_req_ready           ),
    .serdes_req_rdata           (serdes_req_rdata           ),
    .serdes_req_write           (serdes_req_write           ),
    .serdes_req_sel             (serdes_req_sel             ),
    .serdes_req_wdata           (serdes_req_wdata           ),
                                                            
    .xmii_bdg_req_addr          (xmii_bdg_req_addr          ),
    .xmii_bdg_req_ready         (xmii_bdg_req_ready         ),
    .xmii_bdg_req_rdata         (xmii_bdg_req_rdata         ),
    .xmii_bdg_req_write         (xmii_bdg_req_write         ),
    .xmii_bdg_req_sel           (xmii_bdg_req_sel           ),
    .xmii_bdg_req_wdata         (xmii_bdg_req_wdata         ),
                                                            
    .rgmii_req_addr             (rgmii_req_addr             ),
    .rgmii_req_ready            (rgmii_req_ready            ),
    .rgmii_req_rdata            (rgmii_req_rdata            ),
    .rgmii_req_write            (rgmii_req_write            ),
    .rgmii_req_sel              (rgmii_req_sel              ),
    .rgmii_req_wdata            (rgmii_req_wdata            ),
                                                            
    .ptp_req_addr               (ptp_req_addr               ),
    .ptp_req_ready              (ptp_req_ready              ),
    .ptp_req_rdata              (ptp_req_rdata              ),
    .ptp_req_write              (ptp_req_write              ),
    .ptp_req_sel                (ptp_req_sel                ),
    .ptp_req_wdata              (ptp_req_wdata              ),
                                                            
    .xmii_rmtcg_req_addr        (xmii_rmtcg_req_addr        ),
    .xmii_rmtcg_req_ready       (xmii_rmtcg_req_ready       ),
    .xmii_rmtcg_req_rdata       (xmii_rmtcg_req_rdata       ),
    .xmii_rmtcg_req_write       (xmii_rmtcg_req_write       ),
    .xmii_rmtcg_req_sel         (xmii_rmtcg_req_sel         ),
    .xmii_rmtcg_req_wdata       (xmii_rmtcg_req_wdata       ),

    .iopad_req_addr             (iopad_req_addr             ),
    .iopad_req_ready            (iopad_req_ready            ),
    .iopad_req_rdata            (iopad_req_rdata            ),
    .iopad_req_write            (iopad_req_write            ),
    .iopad_req_sel              (iopad_req_sel              ),
    .iopad_req_wdata            (iopad_req_wdata            ),

    .analog_req_addr            (analog_req_addr            ),
    .analog_req_ready           (analog_req_ready           ),
    .analog_req_rdata           (analog_req_rdata           ),
    .analog_req_write           (analog_req_write           ),
    .analog_req_sel             (analog_req_sel             ),
    .analog_req_wdata           (analog_req_wdata           )
    );

    mdio_top
    u_mdio
    (
    .clk_200m                   (clk_200m                   ),
    .rstn_200m                  (rstn_200m                  ),
    .clk_100m                   (clk_200m                   ),
    .rstn_100m                  (rstn_200m                  ),
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

    .req_paddr                  (mdio_paddr                 ),
    .req_pwrite                 (mdio_pwrite                ),
    .req_psel                   (mdio_psel                  ),
    .req_penable                (mdio_penable               ),
    .req_pwdata                 (mdio_pwdata                ),
    .req_pready                 (mdio_pready                ),
    .req_prdata                 (mdio_prdata                )
    );

    /* -----------------------------
     cpu interface
     ---------------------------- */    
    cpu_top
    u_cpu_top(
    .req_paddr                  (cpu_paddr                  ),
    .req_penable                (cpu_penable                ),
    .req_psel                   (cpu_psel                   ),
    .req_pwrite                 (cpu_pwrite                 ),
    .req_pwdata                 (cpu_pwdata                 ),
    .req_pready                 (cpu_pready                 ),
    .req_prdata                 (cpu_prdata                 )
    );

    top_regfile
    u_top_regfile
    (
    .clk                        (clk_200m                   ),
    .rstn                       (rstn_200m                  ),
    .req_addr                   (top_req_addr               ),
    .req_ready                  (top_req_ready              ),
    .req_rdata                  (top_req_rdata              ),
    .req_write                  (top_req_write              ),
    .req_sel                    (top_req_sel                ),
    .req_wdata                  (top_req_wdata              ),

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
