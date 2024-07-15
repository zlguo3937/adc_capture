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
//  2024-07-06    mhyang        1.0         cap_src_gen
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module cap_src_gen
(
    input   wire            clk             ,
    input   wire            rst_n           ,

    // input mode
    input   wire    [3:0]   capture_mode    ,

    // input capture data
    input   wire    [15:0]  write_info      , // write_en + waddr --> 1bit + 15bit
    input   wire            write_done      , // write_done

    input   wire    [12:0]  pkt_ctrl_info   , // main_fsm: 1bit-write_en + 1bit-wr_done + 1bit-fast_read_en + 5bit-curr_sta + 5bit-next_sta
    input   wire    [15:0]  fast_info       , // fast_read_en + fast_raddr --> 1bit + 15bit
    input   wire            fast_rd_done    , // fast_rd_done

    input   wire    [13:0]  fast_main_fsm   , // 7bit-curr_sta + 7bit-next_sta
    input   wire    [5:0]   fast_pkt_fsm    , // pkt_en + read_en + 2bit-curr_sta + 2bit-next_sta
    input   wire    [15:0]  idle_cnt        , // idle_cnt
    input   wire    [9:0]   RD_info         , // RD + RD_CNT

    output  reg     [31:0]  cap_data        ,
    output  reg             cap_data_vld    ,
    output  reg             cap_mode_vld
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cap_data        <= 32'h0;
            cap_data_vld    <= 1'b0;
            cap_mode_vld    <= 1'b0;
        end
        else if (capture_mode == 4'b0000) begin
            cap_data        <= 32'h0;
            cap_data_vld    <= 1'b0;
            cap_mode_vld    <= 1'b0;
        end
        else if (capture_mode == 4'b0000) begin
            cap_data        <= { 2'b0, pkt_ctrl_info, fast_info, fast_rd_done };
            cap_data_vld    <= write_en | fast_read_en;
            cap_mode_vld    <= 1'b1;
        end
        else if (capture_mode == 4'b0001) begin
            cap_data        <= { 12'b0, fast_main_fsm, fast_pkt_fsm };
            cap_data_vld    <= fast_read_en;
            cap_mode_vld    <= 1'b1;
        end
        else if (capture_mode == 4'b0010) begin
            cap_data        <= { 6'b0, idle_cnt, RD_info };
            cap_data_vld    <= fast_read_en;
            cap_mode_vld    <= 1'b1;
        end
        else begin
            cap_data        <= 32'h0;
            cap_data_vld    <= 1'b0;
            cap_mode_vld    <= 1'b0;
        end
    end

endmodule
