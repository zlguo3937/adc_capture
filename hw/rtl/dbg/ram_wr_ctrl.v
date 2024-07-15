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
    input   wire    [ADDR_WIDTH-1:0]    cap_data            ,
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

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            capture_done <= 1'b0;
        else if (capture_mode == cap_dbg_mode) begin
            if (dbg_in_wr_vld && (dbg_in_wr_addr == capture_max_addr))
                capture_done <= 1'b1;
            else if (dbg_in_wr_vld && (dbg_in_wr_addr == {(ADDR_WIDTH){1'b0}}))
                capture_done <= 1'b0;
        end
        else
            capture_done <= 1'b0;
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n) begin
            ram_wr_addr <= {(ADDR_WIDTH){1'b0}};
            ram_wr_data <= {(DATA_WIDTH){1'b0}};
            ram_wr_vld  <= 1'b0;
        end
        else if (capture_mode == cap_dbg_mode) begin
            ram_wr_addr <= dbg_in_wr_addr;
            ram_wr_data <= dbg_in_wr_data;
            ram_wr_vld  <= dbg_in_wr_vld;
        end
        else begin
            ram_wr_addr <= tri_wr_addr;
            ram_wr_data <= tri_wr_data;
            ram_wr_vld  <= tri_wr_vld;
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n) begin
            ram0_waddr <= {(ADDR_WIDTH-1){1'b0}};
            ram0_wdata <= {(DATA_WIDTH/2){1'b0}};
        end
        else if (ram_wr_vld) begin // 8K
            ram0_waddr <= ram_wr_addr[ADDR_WIDTH-2:0];
            ram0_wdata <= ram_wr_data[DATA_WIDTH/2-1:0];
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram0_wr_en <= 1'b0;
        else if (store_mode) // 8K
            ram0_wr_en <= ram_wr_vld;
        else // 16K
            ram0_wr_en <= ram_wr_vld & (~ram_wr_addr[ADDR_WIDTH-1]);
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n) begin
            ram1_waddr <= {(ADDR_WIDTH-1){1'b0}};
            ram1_wdata <= {(DATA_WIDTH/2){1'b0}};
        end
        else if(ram_wr_vld) begin // 8K
            ram1_waddr <= ram_wr_addr[ADDR_WIDTH-2:0];
            if (store_mode) begin
                ram1_wdata <= ram_wr_data[DATA_WIDTH-1:DATA_WIDTH/2];
            end
            else begin
                ram1_wdata <= ram_wr_data[DATA_WIDTH/2-1:0];
            end
        end
    end

    always @(posedge clk or posedge rst_n) begin
        if (~rst_n)
            ram1_wr_en <= 1'b0;
        else if (store_mode) // 8K
            ram1_wr_en <= ram_wr_vld;
        else // 16K
            ram1_wr_en <= ram_wr_vld & ram_wr_addr[ADDR_WIDTH-1];
    end

    trigger #(
        .DATA_WIDTH         (DATA_WIDTH         ),
        .ADDR_WIDTH         (ADDR_WIDTH         ),
        .CNT_WIDTH          (CNT_WIDTH          )
    ) u_trigger
    (
    .clk                            (clk                            ),
    .rst_n                          (rst_n                          ),
// cpu interface
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
// test data
    .cap_data                       (cap_data                       ),
    .cap_data_vld                   (cap_data_vld                   ),
    .cap_mode_vld                   (cap_mode_vld                   ),
// trigger result
    .tri_succeed                    (tri_succeed                    ),
    .tri_data                       (tri_data                       ),
    .tri_data_vld                   (tri_data_vld                   ),
    .tri_addr                       (tri_addr                       ),
// ram_wr
    .tri_wr_vld                     (tri_wr_vld                     ),
    .tri_wr_addr                    (tri_wr_addr                    ),
    .tri_wr_data                    (tri_wr_data                    ),
// dbg
    .tri_done_rd                    (capture_done_rd                ),
    .tri_done                       (tri_done                       )
    );

endmodule
