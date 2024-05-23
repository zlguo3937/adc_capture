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
//  2024-05-15    zlguo         1.0         regsync_500_100
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module cdc_500_200
(

    input   wire            clk_200m,
    input   wire            pktctrl_clk,

    input   wire            rstn_200m,
    input   wire            pktctrl_rstn,

    input   wire            rf_self_test_mode,
    input   wire            rf_capture_mode,
    input   wire            rf_capture_start,
    input   wire            rf_capture_again,
    input   wire            rf_96path_en,
    input   wire    [1:0]   rf_pkt_data_length,
    input   wire    [15:0]  rf_pkt_idle_length,
    input   wire    [8:0]   rf_pktctrl_gap,
    input   wire    [8:0]   rf_pktctrl_phase,
    input   wire            rf_mdio_read_pulse,
    input   wire    [6:0]   rf_mdio_data_sel,
    input   wire    [14:0]  rf_mdio_memory_addr,

    input   wire            mdio_read_pulse_r,
    input   wire    [8:0]   rf_mdio_pkt_data,

    output  wire            rf_self_test_mode_sync,
    output  wire            rf_capture_mode_sync,
    output  wire            rf_capture_start_sync,
    output  wire            rf_capture_again_sync,
    output  wire            rf_96path_en_sync,
    output  wire    [1:0]   rf_pkt_data_length_sync,
    output  wire    [15:0]  rf_pkt_idle_length_sync,
    output  wire    [8:0]   rf_pktctrl_gap_sync,
    output  wire    [8:0]   rf_pktctrl_phase_sync,
    output  wire            rf_mdio_read_pulse_sync,
    output  wire    [6:0]   rf_mdio_data_sel_sync,
    output  wire    [14:0]  rf_mdio_memory_addr_sync,

    output  wire    [8:0]   rf_mdio_pkt_data_sync,
    output  wire            rf_mdio_pkt_data_we

);

    jlsemi_util_sync_pos_with_rst_low
    u_sync_rf_self_test_mode
    (
    .clk                        (pktctrl_clk                ),
    .rst_n                      (pktctrl_rstn               ),
    .din                        (rf_self_test_mode          ),
    .dout                       (rf_self_test_mode_sync     )
    );

    jlsemi_util_sync_pos_with_rst_low
    u_sync_rf_capture_mode
    (
    .clk                        (pktctrl_clk                ),
    .rst_n                      (pktctrl_rstn               ),
    .din                        (rf_capture_mode            ),
    .dout                       (rf_capture_mode_sync       )
    );

    pulse_handshake
    u_sync_rf_capture_start
    (
    .src_clk                    (clk_200m                   ),
    .src_rstn                   (rstn_200m                  ),
    .src_pulse                  (rf_capture_start           ),
    .dst_clk                    (pktctrl_clk                ),
    .dst_rstn                   (pktctrl_rstn               ),
    .dst_pulse                  (rf_capture_start_sync      )
    );

    pulse_handshake
    u_sync_rf_capture_again
    (
    .src_clk                    (clk_200m                   ),
    .src_rstn                   (rstn_200m                  ),
    .src_pulse                  (rf_capture_again           ),
    .dst_clk                    (pktctrl_clk                ),
    .dst_rstn                   (pktctrl_rstn               ),
    .dst_pulse                  (rf_capture_again_sync      )
    );

    //jlsemi_util_sync_pos_with_rst_low
    //u_sync_rf_96path_en
    //(
    //.clk                        (pktctrl_clk                ),
    //.rst_n                      (pktctrl_rstn               ),
    //.din                        (rf_96path_en               ),
    //.dout                       (rf_96path_en_sync          )
    //);
    assign rf_96path_en_sync = rf_96path_en;

    pulse_handshake
    u_sync_rf_mdio_read_pulse
    (
    .src_clk                    (clk_200m                   ),
    .src_rstn                   (rstn_200m                  ),
    .src_pulse                  (rf_mdio_read_pulse         ),
    .dst_clk                    (pktctrl_clk                ),
    .dst_rstn                   (pktctrl_rstn               ),
    .dst_pulse                  (rf_mdio_read_pulse_sync    )
    );

    synchronizer#(
        .DATA_WIDTH (1+1 ),
        .INIT_VALUE (0   ))
    u_sync_rf_pkt_data_length
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .din                        (rf_pkt_data_length         ),
    .dout                       (rf_pkt_data_length_sync    )
    );

    synchronizer#(
        .DATA_WIDTH (15+1),
        .INIT_VALUE (0   ))
    u_sync_rf_pkt_idle_length
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .din                        (rf_pkt_idle_length         ),
    .dout                       (rf_pkt_idle_length_sync    )
    );

    synchronizer#(
        .DATA_WIDTH (9   ),
        .INIT_VALUE (0   ))
    u_sync_rf_pktctrl_gap
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .din                        (rf_pktctrl_gap             ),
    .dout                       (rf_pktctrl_gap_sync        )
    );

    synchronizer#(
        .DATA_WIDTH (9   ),
        .INIT_VALUE (0   ))
    u_sync_rf_pktctrl_phase
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .din                        (rf_pktctrl_phase           ),
    .dout                       (rf_pktctrl_phase_sync      )
    );

    synchronizer#(
        .DATA_WIDTH (6+1 ),
        .INIT_VALUE (0   ))
    u_sync_rf_mdio_data_sel
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .din                        (rf_mdio_data_sel           ),
    .dout                       (rf_mdio_data_sel_sync      )
    );

    synchronizer#(
        .DATA_WIDTH (14+1),
        .INIT_VALUE (0   ))
    u_sync_rf_mdio_memory_addr
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .din                        (rf_mdio_memory_addr        ),
    .dout                       (rf_mdio_memory_addr_sync   )
    );

    multi_handshake#(
        .DATA_WIDTH (9)
    )u_sync_rf_mdio_pkt_data
    (
    .src_clk                    (pktctrl_clk                ),
    .src_rstn                   (pktctrl_rstn               ),
    .vld_in                     (mdio_read_pulse_r          ),
    .din                        (rf_mdio_pkt_data           ),

    .dst_clk                    (clk_200m                   ),
    .dst_rstn                   (rstn_200m                  ),
    .vld_out                    (rf_mdio_pkt_data_we        ),
    .dout                       (rf_mdio_pkt_data_sync      )
    );

endmodule
