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
    input   wire                        wr_clk                  ,
    input   wire                        wr_rst_n                ,
    input   wire                        rd_clk                  ,
    input   wire                        rd_rst_n                ,

    // ****************************************************************
    // input capture data
    // ****************************************************************
    //TODO TODO




    // ****************************************************************
    // output trigger result
    // ****************************************************************
    output  wire                        tri_succeed             ,
    output  wire    [DATA_WIDTH-1:0]    tri_data                ,
    output  wire                        tri_data_vld            ,


    // ****************************************************************
    // config interface
    // ****************************************************************
    input   wire                        ram0_slp_rdata          ,
    input   wire                        ram1_slp_rdata          ,

    input   wire                        capture_enable_rdada    ,
    input   wire                        capture_start_rdada     ,

    input   wire    [MODE_WIDTH-1:0]    capture_mode_rdada      ,
    input   wire    [ADDR_WIDTH-1:0]    capture_max_addr_rdada  ,
    input   wire    [ADDR_WIDTH-1:0]    pre_trigger_num_rdada   ,

    input   wire    [15:0]              trigger_pattern0_rdata  ,
    input   wire    [15:0]              trigger_pattern1_rdata  ,
    input   wire    [15:0]              trigger_mode0_rdata     ,
    input   wire    [15:0]              trigger_mode1_rdata     ,
    input   wire    [15:0]              trigger_mode2_rdata     ,
    input   wire    [15:0]              trigger_mode3_rdata     ,
    input   wire    [15:0]              trigger_mode4_rdata     ,
    input   wire    [15:0]              trigger_mode5_rdata     ,
    input   wire    [15:0]              trigger_logic0_rdata    ,
    input   wire    [15:0]              trigger_logic1_rdata    ,
    input   wire                        store_mode_rdata        ,

    output  wire    [ADDR_WIDTH-1:0]    read_start_addr_wdata   ,
    output  wire    [ADDR_WIDTH-1:0]    tri_addr_wdata          ,
    input   wire                        capture_done_rd         ,
    output  wire                        capture_done_wdata      ,

    input   wire                        tri_succeed_cnt_overflow_mode_rdata,
    input   wire                        tri_succeed_cnt_clr_rdata,
    output  wire                        tri_succeed_cnt_wdata   ,


    input   wire                        capture_rd_en_rdata     ,
    input   wire    [ADDR_WIDTH-1:0]    capture_rd_addr_rdata   ,
    output  wire    [15:0]              capture_rd_data0_wdata  ,
    output  wire    [15:0]              capture_rd_data1_wdata

);


    cap_src_gen #(
        .DATA_WIDTH     (DATA_WIDTH     ),
        .MODE_WIDTH     (MODE_WIDTH     )
    ) u_cap_src_gen
    (
    );

    dbg_core #(
        .DATA_WIDTH     (DATA_WIDTH     ),
        .ADDR_WIDTH     (ADDR_WIDTH     ),
        .RAM_READ_DELAY (RAM_READ_DELAY ),
        .CNT_WIDTH      (CNT_WIDTH      ),
        .MODE_WIDTH     (MODE_WIDTH     )
    ) u_dbg_core
    (
    );


    wire                    slp;
    wire                    clka;
    wire                    csa;
    wire                    wra;
    wire    [ADDR_WIDTH:0]  addra;
    wire    [DATA_WIDTH:0]  dina;
    wire                    clkb;
    wire                    csb;
    wire                    wrb;
    wire    [ADDR_WIDTH:0]  addrb;
    wire    [DATA_WIDTH:0]  dinb;
    wire    [DATA_WIDTH:0]  doutb;

    dbg_ram_1r1w_4096_wrapper #(
        .RAM_DEPTH      (4096           ),
        .ADDR_WIDTH     (ADDR_WIDTH-1   ),
        .DATA_WIDTH     (DATA_WIDTH/2   )
    ) u_dbg_ram0
    (
    slp                 (ram0_slp       ),
    clka                (wr_clk         ),
    csa                 (dbg_ram0_wr_en ),
    wra                 (dbg_ram0_wr_en ),
    addra               (dbg_ram0_waddr ),
    dina                (dbg_ram0_wdata ),
    clkb                (rd_clk),
    csb                 (dbg_ram0_rd_en ),
    wrb                 (dbg_ram0_rd_en ),
    addrb               (dbg_ram0_raddr ),
    doutb               (dbg_ram0_rdata )
    );

    dbg_ram_1r1w_4096_wrapper #(
        .RAM_DEPTH      (4096           ),
        .ADDR_WIDTH     (ADDR_WIDTH-1   ),
        .DATA_WIDTH     (DATA_WIDTH/2   )
    ) u_dbg_ram1
    (
    );

endmodule
