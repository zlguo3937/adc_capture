// Copyright (c) 2024 by JLSemi Inc.
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
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-07-06    mhyang        1.0         trigger
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module trigger
#(
    parameter DATA_WIDTH     = 32,
    parameter ADDR_WIDTH     = 14,
    parameter CNT_WIDTH      = 8
)
(
    input   wire                        clk                             ,
    input   wire                        rst_n                           ,

    // config interface
    input   wire                        capture_enable                  ,
    input   wire                        capture_start                   ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr                ,
    input   wire    [ADDR_WIDTH-1:0]    pre_trigger_num                 ,
    input   wire    [DATA_WIDTH-1:0]    trigger_pattern                 ,
    input   wire    [DATA_WIDTH-1:0]    trigger_logic                   ,
    input   wire    [DATA_WIDTH*3-1:0]  trigger_mode                    ,
    output  wire    [ADDR_WIDTH-1:0]    read_start_addr                 ,
    input   wire                        tri_succeed_cnt_rd_en           ,
    input   wire                        tri_succeed_cnt_rd_mode         ,
    input   wire                        tri_succeed_cnt_overflow_mode   ,
    input   wire                        tri_succeed_cnt_clr             ,
    output  wire    [CNT_WIDTH-1:0]     tri_succeed_cnt                 ,

    // test data
    input   wire    [DATA_WIDTH-1:0]    cap_data                        ,
    input   wire                        cap_data_vld                    ,
    input   wire                        cap_mode_vld                    ,

    // ram_wr
    output  wire                        tri_wr_vld                      ,
    output  wire    [ADDR_WIDTH-1:0]    tri_wr_addr                     ,
    output  wire    [DATA_WIDTH-1:0]    tri_wr_data                     ,

    // trigger result
    output  wire                        tri_succeed                     ,
    output  wire    [DATA_WIDTH-1:0]    tri_data                        ,
    output  wire                        tri_data_vld                    ,
    output  wire    [ADDR_WIDTH-1:0]    tri_addr                        ,

    // dbg
    input   wire                        tri_done_rd                     ,
    output  wire                        tri_done
);

    wire    trigger_enable;


    stat_cnt #(
        .DATA_WIDTH             (CNT_WIDTH          ),
        .STEP_WIDTH             (1                  )
    ) u_tri_succeed_stat_cnt
    (
    .clk                            (clk                            ),
    .rst_n                          (rst_n                          ),
    .cfgmt_count_clr                (tri_succeed_cnt_clr            ),
    .cfgmt_count_overflow_mode      (tri_succeed_cnt_overflow_mode  ),
    .cfgmt_count_rd_mode            (tri_succeed_cnt_rd_mode        ),
    .count_rd_en                    (tri_succeed_cnt_rd_en          ),
    .count_en                       (tri_succeed                    ),
    .count_step                     (1'b1                           ),
    .count_rd_out                   (tri_succeed_cnt                )
    );


    match #(
        .DATA_WIDTH             (DATA_WIDTH         )
    ) u_match
    (
    .clk                            (clk                            ),
    .rst_n                          (rst_n                          ),

    .trigger_pattern                (trigger_pattern                ),
    .trigger_mode                   (trigger_mode                   ),
    .trigger_logic                  (trigger_logic                  ),

// test data
    .cap_data                       (cap_data                       ),
    .cap_data_vld                   (cap_data_vld                   ),
    .trigger_enable                 (trigger_enable                 ),
// trigger result
    .tri_succeed                    (tri_succeed                    ),
    .tri_data                       (tri_data                       ),
    .tri_data_vld                   (tri_data_vld                   )
    );


    wr_addr_ctrl #(
        .DATA_WIDTH         (DATA_WIDTH         ),
        .ADDR_WIDTH         (ADDR_WIDTH         )
    ) u_wr_addr_ctrl
    (
    .clk                            (clk                            ),
    .rst_n                          (rst_n                          ),
// cpu interface
    .capture_enable                 (capture_enable                 ),
    .capture_start                  (capture_start                  ),
    .capture_max_addr               (capture_max_addr               ),
    .pre_trigger_num                (pre_trigger_num                ),
    .cap_mode_vld                   (cap_mode_vld                   ),
// trigger result
    .tri_succeed                    (tri_succeed                    ),
    .tri_data                       (tri_data                       ),
    .tri_data_vld                   (tri_data_vld                   ),
// ram_wr
    .tri_wr_vld                     (tri_wr_vld                     ),
    .tri_wr_addr                    (tri_wr_addr                    ),
    .tri_wr_data                    (tri_wr_data                    ),
    .read_start_addr                (read_start_addr                ),
    .tri_addr                       (tri_addr                       ),
// dbg
    .tri_done_rd                    (capture_done_rd                ),
    .tri_done                       (tri_done                       ),
    .trigger_enable                 (trigger_enable                 )
    );

endmodule
