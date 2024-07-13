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
//  2024-07-06    mhyang        1.0         ram_wr_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module ram_wr_ctrl
#(
    parameter DATA_WIDTH     = 32,
    parameter ADDR_WIDTH     = 14,
    parameter CNT_WIDTH      = 8,
    parameter MODE_WIDTH     = 4
)
(
    input   wire                        clk                 ,
    input   wire                        rst_n               ,

    // ****************************************************************
    // input capture data
    // ****************************************************************
    input   wire    [MODE_WIDTH-1:0]    cap_dbg_mode        ,
    input   wire    [ADDR_WIDTH-1:0]    cap_dada            ,
    input   wire                        cap_data_vld        ,
    input   wire                        cap_mode_vld        ,

    // ****************************************************************
    // output trigger result
    // ****************************************************************
    output  wire                        tri_succeed         ,
    output  wire    [DATA_WIDTH-1:0]    tri_data            ,
    output  wire                        tri_data_vld        ,

    // ****************************************************************
    // config interface
    // ****************************************************************
    input   wire                        capture_enable      ,
    input   wire                        capture_start       ,

    input   wire    [MODE_WIDTH-1:0]    capture_mode        ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr    ,
    input   wire    [ADDR_WIDTH-1:0]    pre_trigger_num     ,

    input   wire    [DATA_WIDTH-1:0]    trigger_pattern     ,
    input   wire    [DATA_WIDTH-1:0]    trigger_logic       ,
    input   wire    [DATA_WIDTH*3-1:0]  trigger_mode        ,
    input   wire                        store_mode          ,

    input   wire    [DATA_WIDTH-1:0]    dbg_in_wr_data      ,
    input   wire    [ADDR_WIDTH-1:0]    dbg_in_wr_addr      ,
    input   wire                        dbg_in_wr_vld       ,

    output  wire    [ADDR_WIDTH-1:0]    read_start_addr     ,
    output  wire    [ADDR_WIDTH-1:0]    tri_addr            ,

    input   wire                        capture_done_rd     ,
    output  reg                         capture_done        ,

    input   wire                        tri_succeed_cnt_rd_en,
    input   wire                        tri_succeed_cnt_rd_mode,
    input   wire                        tri_succeed_cnt_overflow_mode,
    input   wire                        tri_succeed_cnt_clr ,
    output  wire    [CNT_WIDTH-1:0]     tri_succeed_cnt     ,



    input   wire                        dbg_in_rd_en        ,
    input   wire                        capture_rd_en       ,
    input   wire    [ADDR_WIDTH-1:0]    capture_rd_addr     ,
    output  wire    [DATA_WIDTH-1:0]    capture_rd_data     ,

    // ram0 interface
    output  reg     [ADDR_WIDTH-2:0]    ram0_waddr          ,
    output  reg     [DATA_WIDTH/2-1:0]  ram0_wdata          ,
    output  reg                         ram0_wr_en          ,

    // ram1 interface
    output  reg     [ADDR_WIDTH-2:0]    ram1_waddr          ,
    output  reg     [DATA_WIDTH/2-1:0]  ram1_wdata          ,
    output  reg                         ram1_wr_en
);

    wire                        tri_wr_vld;
    wire    [ADDR_WIDTH-1:0]    tri_wr_addr;
    wire    [DATA_WIDTH-1:0]    tri_wr_data;
    wire                        tri_done;

    reg     [ADDR_WIDTH-1:0]    ram_wr_addr;
    reg     [DATA_WIDTH-1:0]    ram_wr_data;
    reg                         ram_wr_vld;


    trigger #(
        .DATA_WIDTH         (DATA_WIDTH         ),
        .ADDR_WIDTH         (ADDR_WIDTH         ),
        .CNT_WIDTH          (CNT_WIDTH          )
    ) u_trigger
    (
    .clk                            (clk                            ),
    .rst_n                          (rst_n                          ),

    .capture_enable                 (capture_enable                 ),
    .capture_start                  (capture_start                  ),
    .capture_max_addr               (capture_max_addr               ),
    .pre_trigger_num                (pre_trigger_num                ),
    .trigger_pattern                (trigger_pattern                ),
    .trigger_mode                   (trigger_mode                   ),
    .trigger_logic                  (trigger_logic                  ),
    .read_start_addr                (read_start_addr                ),
    .tri_succeed_cnt_rd_en          (tri_succeed_cnt_rd_en          ),
    .tri_succeed_cnt_rd_mode        (tri_succeed_cnt_rd_mode        ),
    .tri_succeed_cnt_overflow_mode  (tri_succeed_cnt_overflow_mode  ),
    .tri_succeed_cnt_clr            (tri_succeed_cnt_clr            ),
    .tri_succeed_cnt                (tri_succeed_cnt                ),

    .cap_data                       (cap_data                       ),
    .cap_data_vld                   (cap_data_vld                   ),
    .cap_mode_vld                   (cap_mode_vld                   ),

    .tri_succeed                    (tri_succeed                    ),
    .tri_data                       (tri_data                       ),
    .tri_data_vld                   (tri_data_vld                   ),

    .ram0_waddr                     (dbg_ram0_waddr                 ),
    .ram0_wdata                     (dbg_ram0_wdata                 ),
    .ram0_wr_en                     (dbg_ram0_wr_en                 ),

    .ram1_waddr                     (dbg_ram1_waddr                 ),
    .ram1_wdata                     (dbg_ram1_wdata                 ),
    .ram1_wr_en                     (dbg_ram1_wr_en                 )
    );

endmodule
