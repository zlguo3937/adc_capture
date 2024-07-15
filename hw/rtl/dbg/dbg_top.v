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
//  2024-07-06    mhyang        1.0         dbg_top
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module dbg_top
#(
    parameter DATA_WIDTH     = 32,
    parameter ADDR_WIDTH     = 13,
    parameter ADC_DATA_WIDTH = 16,
    parameter RAM_READ_DELAY = 1,
    parameter CNT_WIDTH      = 8,
    parameter MODE_WIDTH     = 4
)
(
    // ****************************************************************
    // clock and reset
    // ****************************************************************
    input   wire                        wr_clk          ,
    input   wire                        wr_rst_n        ,
    input   wire                        rd_clk          ,
    input   wire                        rd_rst_n        ,

    // ****************************************************************
    // input capture data
    // ****************************************************************
    // input capture data
    input   wire    [15:0]              write_info      , // write_en + waddr --> 1bit + 15bit
    input   wire                        write_done      , // write_done

    input   wire    [12:0]              pkt_ctrl_info   , // main_fsm: 1bit-write_en + 1bit-wr_done + 1bit-fast_read_en + 5bit-curr_sta + 5bit-next_sta
    input   wire    [15:0]              fast_info       , // fast_read_en + fast_raddr --> 1bit + 15bit
    input   wire                        fast_rd_done    , // fast_rd_done

    input   wire    [13:0]              fast_main_fsm   , // 7bit-curr_sta + 7bit-next_sta
    input   wire    [5:0]               fast_pkt_fsm    , // pkt_en + read_en + 2bit-curr_sta + 2bit-next_sta
    input   wire    [15:0]              idle_cnt        , // idle_cnt
    input   wire    [9:0]               RD_info         , // RD + RD_CNT

    // ****************************************************************
    // output trigger result
    // ****************************************************************
    output  wire                        tri_succeed     ,
    output  wire    [DATA_WIDTH-1:0]    tri_data        ,
    output  wire                        tri_data_vld    ,

    // ****************************************************************
    // config interface
    // ****************************************************************
    input   wire                        capture_enable  ,
    input   wire                        capture_start   ,

    input   wire    [MODE_WIDTH-1:0]    capture_mode    ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr,
    input   wire    [ADDR_WIDTH-1:0]    pre_trigger_num ,

    input   wire    [15:0]              trigger_pattern0,
    input   wire    [15:0]              trigger_pattern1,
    input   wire    [15:0]              trigger_mode0   ,
    input   wire    [15:0]              trigger_mode1   ,
    input   wire    [15:0]              trigger_mode2   ,
    input   wire    [15:0]              trigger_mode3   ,
    input   wire    [15:0]              trigger_mode4   ,
    input   wire    [15:0]              trigger_mode5   ,
    input   wire    [15:0]              trigger_logic0  ,
    input   wire    [15:0]              trigger_logic1  ,
    input   wire                        store_mode      ,

    output  wire    [ADDR_WIDTH-1:0]    read_start_addr ,
    output  wire    [ADDR_WIDTH-1:0]    tri_addr        ,
    input   wire                        capture_done_rd ,
    output  wire                        capture_done    ,

    input   wire                        tri_succeed_cnt_overflow_mode,
    input   wire                        tri_succeed_cnt_clr,
    output  wire    [CNT_WIDTH-1:0]     tri_succeed_cnt ,

    input   wire                        capture_rd_en   ,
    input   wire    [ADDR_WIDTH-1:0]    capture_rd_addr ,
    output  wire    [15:0]              capture_rd_data0,
    output  wire    [15:0]              capture_rd_data1

);

    wire    [ADDR_WIDTH-1:0]    cap_data    ;
    wire                        cap_data_vld;
    wire                        cap_mode_vld;

    wire    [DATA_WIDTH*3-1:0]  trigger_mode;

    wire    [DATA_WIDTH-1:0]    ge_dbg_in_wr_data; // TODO TODO
    wire    [ADDR_WIDTH-1:0]    ge_dbg_in_wr_addr;
    wire                        ge_dbg_in_wr_vld ;
    wire                        ge_dbg_in_rd_en  ;

    wire    [DATA_WIDTH-1:0]    capture_rd_data;


    wire    [DATA_WIDTH/2-1:0]  dbg_ram0_rdata;
    wire    [ADDR_WIDTH-2:0]    dbg_ram0_raddr;
    wire                        dbg_ram0_rd_en;
    wire    [ADDR_WIDTH-2:0]    dbg_ram0_waddr;
    wire    [DATA_WIDTH/2-1:0]  dbg_ram0_wdata;
    wire                        dbg_ram0_wr_en;

    wire    [DATA_WIDTH/2-1:0]  dbg_ram1_rdata;
    wire    [ADDR_WIDTH-2:0]    dbg_ram1_raddr;
    wire                        dbg_ram1_rd_en;
    wire    [ADDR_WIDTH-2:0]    dbg_ram1_waddr;
    wire    [DATA_WIDTH/2-1:0]  dbg_ram1_wdata;
    wire                        dbg_ram1_wr_en;

    assign  trigger_mode = {trigger_mode5, trigger_mode4, trigger_mode3, trigger_mode2, trigger_mode1, trigger_mode0};
    assign capture_rd_data0 = capture_rd_data[15:0];
    assign capture_rd_data1 = capture_rd_data[31:16];

    cap_src_gen
    u_cap_src_gen
    (
    .clk                            (wr_clk                         ),
    .rst_n                          (wr_rst_n                       ),
                                                                    
    .capture_mode                   (capture_mode                   ),
                                                                    
    .write_info                     (write_info                     ),
    .write_done                     (write_done                     ),
                                                                    
    .pkt_ctrl_info                  (pkt_ctrl_info                  ),
    .fast_info                      (fast_info                      ),
    .fast_rd_done                   (fast_rd_done                   ),
                                                                    
    .fast_main_fsm                  (fast_main_fsm                  ),
    .fast_pkt_fsm                   (fast_pkt_fsm                   ),
    .idle_cnt                       (idle_cnt                       ),
    .RD_info                        (RD_info                        ),
                                                                    
    .cap_data                       (cap_data                       ),
    .cap_data_vld                   (cap_data_vld                   ),
    .cap_mode_vld                   (cap_mode_vld                   )
    );

    dbg_core #(
        .DATA_WIDTH     (DATA_WIDTH     ),
        .ADDR_WIDTH     (ADDR_WIDTH     ),
        .RAM_READ_DELAY (RAM_READ_DELAY ),
        .CNT_WIDTH      (CNT_WIDTH      ),
        .MODE_WIDTH     (MODE_WIDTH     )
    ) u_dbg_core
    (
    .rd_clk                         (rd_clk                         ),
    .rd_rst_n                       (rd_rst_n                       ),
    .wr_clk                         (wr_clk                         ),
    .wr_rst_n                       (wr_rst_n                       ),

    .cap_dbg_mode                   (4'b0011                        ),
    .cap_data                       (cap_data                       ),
    .cap_data_vld                   (cap_data_vld                   ),
    .cap_mode_vld                   (cap_mode_vld                   ),
                                                                    
    .tri_succeed                    (tri_succeed                    ),
    .tri_data                       (tri_data                       ),
    .tri_data_vld                   (tri_data_vld                   ),
                                                                    
    .capture_enable                 (capture_enable                 ),
    .capture_start                  (capture_start                  ),
                                                                    
    .capture_mode                   (capture_mode                   ),
    .capture_max_addr               (capture_max_addr               ),
    .pre_trigger_num                (pre_trigger_num                ),
                                                                    
    .trigger_pattern                ({trigger_pattern1, trigger_pattern0}),
    .trigger_logic                  ({trigger_logic1, trigger_logic0}),
    .trigger_mode                   (trigger_mode                   ),
    .store_mode                     (store_mode                     ),
                                                                    
    .read_start_addr                (read_start_addr                ),
    .tri_addr                       (tri_addr                       ),
    .capture_done_rd                (capture_done_rd                ),
    .capture_done                   (capture_done                   ),
                                                                    
    .tri_succeed_cnt_overflow_mode  (tri_succeed_cnt_overflow_mode  ),
    .tri_succeed_cnt_clr            (tri_succeed_cnt_clr            ),
    .tri_succeed_cnt                (tri_succeed_cnt                ),
                                                                    
    .dbg_in_wr_data                 (ge_dbg_in_wr_data              ),
    .dbg_in_wr_addr                 (ge_dbg_in_wr_addr              ),
    .dbg_in_wr_vld                  (ge_dbg_in_wr_vld               ),
    .dbg_in_rd_en                   (ge_dbg_in_rd_en                ),
    .capture_rd_en                  (capture_rd_en                  ),
    .capture_rd_addr                (capture_rd_addr                ),
    .capture_rd_data                (capture_rd_data                ),
                                                                    
    .dbg_ram0_rdata                 (dbg_ram0_rdata                 ),
    .dbg_ram0_raddr                 (dbg_ram0_raddr                 ),
    .dbg_ram0_rd_en                 (dbg_ram0_rd_en                 ),
    .dbg_ram0_waddr                 (dbg_ram0_waddr                 ),
    .dbg_ram0_wdata                 (dbg_ram0_wdata                 ),
    .dbg_ram0_wr_en                 (dbg_ram0_wr_en                 ),
                                                                    
    .dbg_ram1_rdata                 (dbg_ram1_rdata                 ),
    .dbg_ram1_raddr                 (dbg_ram1_raddr                 ),
    .dbg_ram1_rd_en                 (dbg_ram1_rd_en                 ),
    .dbg_ram1_waddr                 (dbg_ram1_waddr                 ),
    .dbg_ram1_wdata                 (dbg_ram1_wdata                 ),
    .dbg_ram1_wr_en                 (dbg_ram1_wr_en                 )
    );

    dbg_ram_1r1w_4096_wrapper #(
        .RAM_DEPTH      (4096           ),
        .ADDR_WIDTH     (ADDR_WIDTH-1   ),
        .DATA_WIDTH     (DATA_WIDTH/2   )
    ) u_dbg_ram0
    (
    .clka                           (wr_clk                         ),  // write clock
    .csa                            (dbg_ram0_wr_en                 ),  // port a : chip select, active high
    .wra                            (dbg_ram0_wr_en                 ),  // port a : read enable, active high
    .addra                          (dbg_ram0_waddr                 ),  // port a : write address
    .dina                           (dbg_ram0_wdata                 ),  // port a : write data
    .clkb                           (rd_clk                         ),  // read clock
    .csb                            (dbg_ram0_rd_en                 ),  // port b : chip select, active high
    .rdb                            (dbg_ram0_rd_en                 ),  // port b : read enable, active high
    .addrb                          (dbg_ram0_raddr                 ),  // port b : read address
    .doutb                          (dbg_ram0_rdata                 )   // port b : read data
    );

    dbg_ram_1r1w_4096_wrapper #(
        .RAM_DEPTH      (4096           ),
        .ADDR_WIDTH     (ADDR_WIDTH-1   ),
        .DATA_WIDTH     (DATA_WIDTH/2   )
    ) u_dbg_ram1
    (
    .clka                           (wr_clk                         ),  // write clock
    .csa                            (dbg_ram1_wr_en                 ),  // port a : chip select, active high
    .wra                            (dbg_ram1_wr_en                 ),  // port a : read enable, active high
    .addra                          (dbg_ram1_waddr                 ),  // port a : write address
    .dina                           (dbg_ram1_wdata                 ),  // port a : write data
    .clkb                           (rd_clk                         ),  // read clock
    .csb                            (dbg_ram1_rd_en                 ),  // port b : chip select, active high
    .rdb                            (dbg_ram1_rd_en                 ),  // port b : read enable, active high
    .addrb                          (dbg_ram1_raddr                 ),  // port b : read address
    .doutb                          (dbg_ram1_rdata                 )   // port b : read data
    );

endmodule
