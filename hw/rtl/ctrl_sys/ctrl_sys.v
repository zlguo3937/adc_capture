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

    // Analog register
    input   wire    [14:0]   SAR_PVSENSOR_CNT,
    output  wire             BG25M_TEST_EN,
    output  wire             SAR_BUFFER_PD,
    output  wire             SAR_CKBUF_PD,
    output  wire             SAR_CLK_EN,
    output  wire             SAR_DELAY,
    output  wire             SAR_PU_LDOADC,
    output  wire             SAR_PU_SENSOR,
    output  wire             SAR_PVSENSOR_CNT_EN,
    output  wire             SAR_REVERSE,
    output  wire             SAR_RSTN,
    output  wire             SAR_SF_ST1_PD,
    output  wire             SAR_SKEWGEN_EN,
    output  wire             SAR_TEST_EN,
    output  wire             SAR_VREF_PD,
    output  wire    [15:0]   SAR_RESVD1,
    output  wire    [1:0]    SAR_CKBUF_ISEL,
    output  wire    [1:0]    SAR_ISEL,
    output  wire    [1:0]    SAR_REFSEL,
    output  wire    [1:0]    SAR_SF_ST1_ISEL,
    output  wire    [2:0]    BG25M_TEST_SEL,
    output  wire    [2:0]    SAR_CMSEL,
    output  wire    [2:0]    SAR_LDO_ADCSEL,
    output  wire    [2:0]    SAR_LDO_BUFFERSEL,
    output  wire    [2:0]    SAR_LDO_CKSEL,
    output  wire    [2:0]    SAR_TEST_SEL,
    output  wire    [5:0]    SAR_CKCALBUF_DELAY,
    output  wire    [5:0]    SAR_DAC0_COARSE,
    output  wire    [5:0]    SAR_DAC0_FINE,
    output  wire    [5:0]    SAR_DAC1_COARSE,
    output  wire    [5:0]    SAR_DAC1_FINE,
    output  wire    [5:0]    SAR_DAC2_COARSE,
    output  wire    [5:0]    SAR_DAC2_FINE,
    output  wire    [5:0]    SAR_DAC3_COARSE,
    output  wire    [5:0]    SAR_DAC3_FINE,
    output  wire    [5:0]    SAR_DAC4_COARSE,
    output  wire    [5:0]    SAR_DAC4_FINE,
    output  wire    [5:0]    SAR_DAC5_COARSE,
    output  wire    [5:0]    SAR_DAC5_FINE,
    output  wire    [5:0]    SAR_DAC6_COARSE,
    output  wire    [5:0]    SAR_DAC6_FINE,
    output  wire    [5:0]    SAR_DAC7_COARSE,
    output  wire    [5:0]    SAR_DAC7_FINE

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

    .SAR_PVSENSOR_CNT_wdata     (SAR_PVSENSOR_CNT           ),
    .BG25M_TEST_EN_rdata        (BG25M_TEST_EN              ),
    .SAR_BUFFER_PD_rdata        (SAR_BUFFER_PD              ),
    .SAR_CKBUF_PD_rdata         (SAR_CKBUF_PD               ),
    .SAR_CLK_EN_rdata           (SAR_CLK_EN                 ),
    .SAR_DELAY_rdata            (SAR_DELAY                  ),
    .SAR_PU_LDOADC_rdata        (SAR_PU_LDOADC              ),
    .SAR_PU_SENSOR_rdata        (SAR_PU_SENSOR              ),
    .SAR_PVSENSOR_CNT_EN_rdata  (SAR_PVSENSOR_CNT_EN        ),
    .SAR_REVERSE_rdata          (SAR_REVERSE                ),
    .SAR_RSTN_rdata             (SAR_RSTN                   ),
    .SAR_SF_ST1_PD_rdata        (SAR_SF_ST1_PD              ),
    .SAR_SKEWGEN_EN_rdata       (SAR_SKEWGEN_EN             ),
    .SAR_TEST_EN_rdata          (SAR_TEST_EN                ),
    .SAR_VREF_PD_rdata          (SAR_VREF_PD                ),
    .SAR_RESVD1_rdata           (SAR_RESVD1                 ),
    .SAR_CKBUF_ISEL_rdata       (SAR_CKBUF_ISEL             ),
    .SAR_ISEL_rdata             (SAR_ISEL                   ),
    .SAR_REFSEL_rdata           (SAR_REFSEL                 ),
    .SAR_SF_ST1_ISEL_rdata      (SAR_SF_ST1_ISEL            ),
    .BG25M_TEST_SEL_rdata       (BG25M_TEST_SEL             ),
    .SAR_CMSEL_rdata            (SAR_CMSEL                  ),
    .SAR_LDO_ADCSEL_rdata       (SAR_LDO_ADCSEL             ),
    .SAR_LDO_BUFFERSEL_rdata    (SAR_LDO_BUFFERSEL          ),
    .SAR_LDO_CKSEL_rdata        (SAR_LDO_CKSEL              ),
    .SAR_TEST_SEL_rdata         (SAR_TEST_SEL               ),
    .SAR_CKCALBUF_DELAY_rdata   (SAR_CKCALBUF_DELAY         ),
    .SAR_DAC0_COARSE_rdata      (SAR_DAC0_COARSE            ),
    .SAR_DAC0_FINE_rdata        (SAR_DAC0_FINE              ),
    .SAR_DAC1_COARSE_rdata      (SAR_DAC1_COARSE            ),
    .SAR_DAC1_FINE_rdata        (SAR_DAC1_FINE              ),
    .SAR_DAC2_COARSE_rdata      (SAR_DAC2_COARSE            ),
    .SAR_DAC2_FINE_rdata        (SAR_DAC2_FINE              ),
    .SAR_DAC3_COARSE_rdata      (SAR_DAC3_COARSE            ),
    .SAR_DAC3_FINE_rdata        (SAR_DAC3_FINE              ),
    .SAR_DAC4_COARSE_rdata      (SAR_DAC4_COARSE            ),
    .SAR_DAC4_FINE_rdata        (SAR_DAC4_FINE              ),
    .SAR_DAC5_COARSE_rdata      (SAR_DAC5_COARSE            ),
    .SAR_DAC5_FINE_rdata        (SAR_DAC5_FINE              ),
    .SAR_DAC6_COARSE_rdata      (SAR_DAC6_COARSE            ),
    .SAR_DAC6_FINE_rdata        (SAR_DAC6_FINE              ),
    .SAR_DAC7_COARSE_rdata      (SAR_DAC7_COARSE            ),
    .SAR_DAC7_FINE_rdata        (SAR_DAC7_FINE              )
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
