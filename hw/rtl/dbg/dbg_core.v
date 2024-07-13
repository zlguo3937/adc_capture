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
//  2024-07-06    mhyang        1.0         dbg_core
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module dbg_core
#(
    parameter DATA_WIDTH     = 32,
    parameter ADDR_WIDTH     = 13,
    parameter RAM_READ_DELAY = 1,
    parameter CNT_WIDTH      = 8,
    parameter MODE_WIDTH     = 4
)
(
    input   wire                        rd_clk                  ,
    input   wire                        rd_rst_n                ,
    input   wire                        wr_clk                  ,
    input   wire                        wr_rst_n                ,

    // ****************************************************************
    // input capture data
    // ****************************************************************
    input   wire    [MODE_WIDTH-1:0]    cap_dbg_mode            ,
    input   wire    [ADDR_WIDTH-1:0]    cap_dada                ,
    input   wire                        cap_data_vld            ,
    input   wire                        cap_mode_vld            ,

    // ****************************************************************
    // output trigger result
    // ****************************************************************
    output  wire                        tri_succeed             ,
    output  wire    [DATA_WIDTH-1:0]    tri_data                ,
    output  wire                        tri_data_vld            ,

    // ****************************************************************
    // config interface
    // ****************************************************************
    input   wire                        capture_enable          ,
    input   wire                        capture_start           ,

    input   wire    [MODE_WIDTH-1:0]    capture_mode            ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr        ,
    input   wire    [ADDR_WIDTH-1:0]    pre_trigger_num         ,

    input   wire    [DATA_WIDTH-1:0]    trigger_pattern         ,
    input   wire    [DATA_WIDTH-1:0]    trigger_logic           ,
    input   wire    [DATA_WIDTH*3-1:0]  trigger_mode            ,
    input   wire                        store_mode              ,

    output  wire    [ADDR_WIDTH-1:0]    read_start_addr         ,
    output  wire    [ADDR_WIDTH-1:0]    tri_addr                ,
    input   wire                        capture_done_rd         ,
    output  wire                        capture_done            ,

    input   wire                        tri_succeed_cnt_overflow_mode,
    input   wire                        tri_succeed_cnt_clr     ,
    output  wire    [CNT_WIDTH-1:0]     tri_succeed_cnt         ,


    input   wire    [DATA_WIDTH-1:0]    dbg_in_wr_data          ,
    input   wire    [ADDR_WIDTH-1:0]    dbg_in_wr_addr          ,
    input   wire                        dbg_in_wr_vld           ,
    input   wire                        dbg_in_rd_en            ,
    input   wire                        capture_rd_en           ,
    input   wire    [ADDR_WIDTH-1:0]    capture_rd_addr         ,
    output  wire    [DATA_WIDTH-1:0]    capture_rd_data         ,

    // ram0 interface
    input   wire    [DATA_WIDTH/2-1:0]  dbg_ram0_rdata          ,
    output  wire    [ADDR_WIDTH-2:0]    dbg_ram0_raddr          ,
    output  wire                        dbg_ram0_rd_en          ,
    output  wire    [ADDR_WIDTH-2:0]    dbg_ram0_waddr          ,
    output  wire    [DATA_WIDTH/2-1:0]  dbg_ram0_wdata          ,
    output  wire                        dbg_ram0_wr_en          ,

    // ram1 interface
    input   wire    [DATA_WIDTH/2-1:0]  dbg_ram1_rdata          ,
    output  wire    [ADDR_WIDTH-2:0]    dbg_ram1_raddr          ,
    output  wire                        dbg_ram1_rd_en          ,
    output  wire    [ADDR_WIDTH-2:0]    dbg_ram1_waddr          ,
    output  wire    [DATA_WIDTH/2-1:0]  dbg_ram1_wdata          ,
    output  wire                        dbg_ram1_wr_en
);

    wire tri_succeed_cnt_rd_en;
    wire tri_succeed_cnt_rd_mode;

    assign tri_succeed_cnt_rd_en    = 1'b0;
    assign tri_succeed_cnt_rd_mode  = 1'b0;

    ram_wr_ctrl #(
        .DATA_WIDTH     (DATA_WIDTH     ),
        .ADDR_WIDTH     (ADDR_WIDTH     ),
        .CNT_WIDTH      (CNT_WIDTH      ),
        .MODE_WIDTH     (MODE_WIDTH     )
    ) u_ram_wr_ctrl
    (
    .clk                            (wr_clk                         ),
    .rst_n                          (wr_rst_n                       ),

    .capture_enable                 (capture_enable                 ),
    .capture_start                  (capture_start                  ),
    .capture_mode                   (capture_mode                   ),
    .capture_max_addr               (capture_max_addr               ),
    .pre_trigger_num                (pre_trigger_num                ),
    .trigger_pattern                (trigger_pattern                ),
    .trigger_mode                   (trigger_mode                   ),
    .trigger_logic                  (trigger_logic                  ),
    .store_mode                     (store_mode                     ),
    .dbg_in_wr_data                 (dbg_in_wr_data                 ),
    .dbg_in_wr_addr                 (dbg_in_wr_addr                 ),
    .dbg_in_wr_vld                  (dbg_in_wr_vld                  ),
    .read_start_addr                (read_start_addr                ),
    .tri_addr                       (tri_addr                       ),
    .capture_done_rd                (capture_done_rd                ),
    .capture_done                   (capture_done                   ),
    .tri_succeed_cnt_rd_en          (tri_succeed_cnt_rd_en          ),
    .tri_succeed_cnt_rd_mode        (tri_succeed_cnt_rd_mode        ),
    .tri_succeed_cnt_overflow_mode  (tri_succeed_cnt_overflow_mode  ),
    .tri_succeed_cnt_clr            (tri_succeed_cnt_clr            ),
    .tri_succeed_cnt                (tri_succeed_cnt                ),

    .cap_dbg_mode                   (cap_dbg_mode                   ),
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

    wire                        capture_rd_vld  ;
    wire                        dbg_in_rd_vld   ;
    wire    [DATA_WIDTH-2:0]    dbg_in_rd_data  ;

    wire    [ADDR_WIDTH-2:0]    ram0_raddr      ;
    wire    [DATA_WIDTH/2-1:0]  ram0_rdata      ;
    wire                        ram0_rd_en      ;

    wire    [ADDR_WIDTH-2:0]    ram1_raddr      ;
    wire    [DATA_WIDTH/2-1:0]  ram1_rdata      ;
    wire                        ram1_rd_en      ;

    ram_rd_ctrl #(
        .DATA_WIDTH     (DATA_WIDTH     ),
        .ADDR_WIDTH     (ADDR_WIDTH     ),
        .MODE_WIDTH     (MODE_WIDTH     ),
        .RAM_READ_DELAY (RAM_READ_DELAY )
    ) u_ram_rd_ctrl
    (
    .clk                            (rd_clk                         ),
    .rst_n                          (rd_rst_n                       ),

    .capture_mode                   (capture_mode                   ),
    .capture_max_addr               (capture_max_addr               ),
    .store_mode                     (store_mode                     ),
    .dbg_in_rd_en                   (dbg_in_rd_en                   ),
    .capture_rd_en                  (capture_rd_en                  ),
    .capture_rd_addr                (capture_rd_addr                ),
    .capture_rd_data                (capture_rd_data                ),
    .capture_rd_vld                 (capture_rd_vld                 ), //spyglass disable W528

    // ge TODO TODO
    .cap_dbg_mode                   (cap_dbg_mode                   ),
    .dbg_in_rd_vld                  (dbg_in_rd_vld                  ),
    .dbg_in_rd_data                 (dbg_in_rd_data                 ),

    .ram0_raddr                     (dbg_ram0_waddr                 ),
    .ram0_rdata                     (dbg_ram0_wdata                 ),
    .ram0_rd_en                     (dbg_ram0_wr_en                 ),

    .ram1_raddr                     (dbg_ram1_raddr                 ),
    .ram1_rdata                     (dbg_ram1_rdata                 ),
    .ram1_rd_en                     (dbg_ram1_rd_en                 )
    );

endmodule
