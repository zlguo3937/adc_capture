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
//  2024-05-06    zlguo         1.0         gen_read_logic_fast
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module gen_read_logic_fast
(
    input   wire            clk,
    input   wire            rstn,

    input   wire            rf_capture_start,
    input   wire            rf_capture_again,
    input   wire            rf_96path_en,
    input   wire    [1:0]   rf_pkt_data_length,
    input   wire    [15:0]  rf_pkt_idle_length,

    input   wire            DATA_RD_EN,
    input   wire            fast_read_en,

    input   wire    [35:0]  fast_din_0,
    input   wire    [35:0]  fast_din_1,
    input   wire    [35:0]  fast_din_2,
    input   wire    [35:0]  fast_din_3,
    input   wire    [35:0]  fast_din_4,
    input   wire    [35:0]  fast_din_5,
    input   wire    [35:0]  fast_din_6,
    input   wire    [35:0]  fast_din_7,
    input   wire    [35:0]  fast_din_8,
    input   wire    [35:0]  fast_din_9,
    input   wire    [35:0]  fast_din_10,
    input   wire    [35:0]  fast_din_11,
    input   wire    [35:0]  fast_din_12,
    input   wire    [35:0]  fast_din_13,
    input   wire    [35:0]  fast_din_14,
    input   wire    [35:0]  fast_din_15,
    input   wire    [35:0]  fast_din_16,
    input   wire    [35:0]  fast_din_17,
    input   wire    [35:0]  fast_din_18,
    input   wire    [35:0]  fast_din_19,
    input   wire    [35:0]  fast_din_20,
    input   wire    [35:0]  fast_din_21,
    input   wire    [35:0]  fast_din_22,
    input   wire    [35:0]  fast_din_23,

    output  reg             fast_chip_en_0,
    output  reg             fast_chip_en_1,
    output  reg             fast_chip_en_2,
    output  reg             fast_chip_en_3,
    output  reg             fast_chip_en_4,
    output  reg             fast_chip_en_5,
    output  reg             fast_chip_en_6,
    output  reg             fast_chip_en_7,
    output  reg             fast_chip_en_8,
    output  reg             fast_chip_en_9,
    output  reg             fast_chip_en_10,
    output  reg             fast_chip_en_11,
    output  reg             fast_chip_en_12,
    output  reg             fast_chip_en_13,
    output  reg             fast_chip_en_14,
    output  reg             fast_chip_en_15,
    output  reg             fast_chip_en_16,
    output  reg             fast_chip_en_17,
    output  reg             fast_chip_en_18,
    output  reg             fast_chip_en_19,
    output  reg             fast_chip_en_20,
    output  reg             fast_chip_en_21,
    output  reg             fast_chip_en_22,
    output  reg             fast_chip_en_23,

    output  wire    [14:0]  fast_addr,

    output  reg             fast_rd_done,

    output  reg     [17:0]  ADC_DATA,
    output  reg             ADC_DATA_VALID
);

    // DATA READ FSM
    localparam      READ_IDLE       = 7'b000_0001,
                    READ_ALWAYS     = 7'b000_0010,
                    READ_216BYTE    = 7'b000_0100,
                    READ_432BYTE    = 7'b000_1000,
                    READ_864BYTE    = 7'b001_0000,
                    READ_1728BYTE   = 7'b010_0000,
                    READ_DONE       = 7'b100_0000;

    reg     [6:0]   curr_sta;
    reg     [6:0]   next_sta;

    // PKT FSM
    localparam      PKT_IDLE    = 2'b01,
                    PKT_VALID   = 2'b10;

    reg     [1:0]   pkt_curr_sta;
    reg     [1:0]   pkt_next_sta;

    // ctrl logic
    reg             RD;
    reg     [8:0]   RD_CNT;

    reg     [35:0]  PKT_DATA;

    reg     [15:0]  idle_cnt;
    reg             pkt_en;
    reg     [14:0]  addr;

    reg             pkt_en_r;
    reg             RD_EN;
    reg             DATA_SEL;

    reg             read_en;
    reg     [8:0]   RD_CNT_r;

    reg     [8:0]   rd_cnt;
    reg     [8:0]   rd_cnt_r;

    /* -----------------------------------------------------------------
     Gen data cnt and addr cnt
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            RD <= 1'b0;
        else if (DATA_RD_EN)
            RD <= 1'b1;
        else
            RD <= 1'b0;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            RD_EN <= 1'b1;
        else if (read_en) begin
            if (DATA_RD_EN)
                RD_EN <= RD_EN + 1'b1;
        end
        else
            RD_EN <= 1'b1;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            DATA_SEL <= 1'b1;
        else if (pkt_en) begin
            if (RD & RD_EN)
                DATA_SEL <= DATA_SEL + 1'b1;
        end
        else
            DATA_SEL <= 1'b1;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            RD_CNT <= 9'd0;
        else if (curr_sta != READ_IDLE) begin
            if (pkt_en) begin
                if (rf_96path_en) begin
                    if ((RD_CNT == 9'd47) && (RD == 1'b1) && (RD_EN == 1'b1))
                        RD_CNT <= 9'd0;
                    else if (RD & RD_EN)
                        RD_CNT <= RD_CNT + 1;
                end
                else begin
                    if ((RD_CNT == 9'd23) && (RD == 1'b1) && (RD_EN == 1'b1))
                        RD_CNT <= 9'd0;
                    else if (RD & RD_EN)
                        RD_CNT <= RD_CNT + 1;
                end
            end
            else
                RD_CNT <= 9'd0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            RD_CNT_r <= 9'd0;
        else if (RD & RD_EN)
            RD_CNT_r <= RD_CNT;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            rd_cnt <= 0;
        else if (RD_CNT <= 47)
            rd_cnt <= RD_CNT;
        else if (47 < RD_CNT <= 95)
            rd_cnt <= RD_CNT - 48;
        else if (95 < RD_CNT <= 143)
            rd_cnt <= RD_CNT - 96;
        else if (143 < RD_CNT <= 191)
            rd_cnt <= RD_CNT - 144;
        else if (191 < RD_CNT <= 239)
            rd_cnt <= RD_CNT - 192;
        else if (239 < RD_CNT <= 287)
            rd_cnt <= RD_CNT - 240;
        else if (287 < RD_CNT <= 335)
            rd_cnt <= RD_CNT - 288;
        else if (335 < RD_CNT <= 383)
            rd_cnt <= RD_CNT - 336;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            rd_cnt_r <= 0;
        else if (RD & RD_EN)
            rd_cnt_r <= rd_cnt;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pkt_en_r <= 1'b0;
        else if (RD & RD_EN)
            pkt_en_r <= pkt_en;
    end

    /* -----------------------------------------------------------------
     Gen ADC_DATA_VALID
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            ADC_DATA_VALID <= 1'b0;
        else if (pkt_en_r) begin
            if (RD_EN & RD)
                ADC_DATA_VALID <= 1'b1;
        end
        else if (RD_EN & RD) begin
            ADC_DATA_VALID <= 1'b0;
        end
    end

    /* -----------------------------------------------------------------
     Gen ADC_DATA
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            ADC_DATA <= 18'h0;
        else if (pkt_en_r) begin
            if (RD_EN & RD) begin
                if (DATA_SEL)
                    ADC_DATA <= PKT_DATA[35:18];
                else
                    ADC_DATA <= PKT_DATA[17:0];
            end
        end
        else if (RD_EN & RD) begin
            ADC_DATA <= 18'h0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            PKT_DATA <= 36'h0;
        else if (curr_sta != READ_IDLE) begin
            if (rd_cnt_r%2 == 0) begin
                case(rd_cnt_r >> 1)
                    0:  PKT_DATA <= fast_din_0;  1:  PKT_DATA <= fast_din_1;  2:  PKT_DATA <= fast_din_2;
                    3:  PKT_DATA <= fast_din_3;  4:  PKT_DATA <= fast_din_4;  5:  PKT_DATA <= fast_din_5;
                    6:  PKT_DATA <= fast_din_6;  7:  PKT_DATA <= fast_din_7;  8:  PKT_DATA <= fast_din_8;
                    9:  PKT_DATA <= fast_din_9;  10: PKT_DATA <= fast_din_10; 11: PKT_DATA <= fast_din_11;
                    12: PKT_DATA <= fast_din_12; 13: PKT_DATA <= fast_din_13; 14: PKT_DATA <= fast_din_14;
                    15: PKT_DATA <= fast_din_15; 16: PKT_DATA <= fast_din_16; 17: PKT_DATA <= fast_din_17;
                    18: PKT_DATA <= fast_din_18; 19: PKT_DATA <= fast_din_19; 20: PKT_DATA <= fast_din_20;
                    21: PKT_DATA <= fast_din_21; 22: PKT_DATA <= fast_din_22; 23: PKT_DATA <= fast_din_23;
                    default: PKT_DATA <= 36'h0;
                endcase
            end
        end
        else
            PKT_DATA <= 36'h0;
    end

    /* -----------------------------------------------------------------
     Gen fast_chip_en
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
            fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
            fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
            fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
            fast_chip_en_12 <= 1'b0; fast_chip_en_13 <= 1'b0; fast_chip_en_14 <= 1'b0;
            fast_chip_en_15 <= 1'b0; fast_chip_en_16 <= 1'b0; fast_chip_en_17 <= 1'b0;
            fast_chip_en_18 <= 1'b0; fast_chip_en_19 <= 1'b0; fast_chip_en_20 <= 1'b0;
            fast_chip_en_21 <= 1'b0; fast_chip_en_22 <= 1'b0; fast_chip_en_23 <= 1'b0;
        end
        else if (rf_96path_en) begin
            if (pkt_en) begin
                fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
                fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
                fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
                fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
                fast_chip_en_12 <= 1'b0; fast_chip_en_13 <= 1'b0; fast_chip_en_14 <= 1'b0;
                fast_chip_en_15 <= 1'b0; fast_chip_en_16 <= 1'b0; fast_chip_en_17 <= 1'b0;
                fast_chip_en_18 <= 1'b0; fast_chip_en_19 <= 1'b0; fast_chip_en_20 <= 1'b0;
                fast_chip_en_21 <= 1'b0; fast_chip_en_22 <= 1'b0; fast_chip_en_23 <= 1'b0;

                if (rd_cnt%2 == 0) begin
                    if (RD & RD_EN) begin
                        case(rd_cnt >> 1)
                            0:  fast_chip_en_0  <= 1'b1; 1:  fast_chip_en_1  <= 1'b1; 2:  fast_chip_en_2  <= 1'b1;
                            3:  fast_chip_en_3  <= 1'b1; 4:  fast_chip_en_4  <= 1'b1; 5:  fast_chip_en_5  <= 1'b1;
                            6:  fast_chip_en_6  <= 1'b1; 7:  fast_chip_en_7  <= 1'b1; 8:  fast_chip_en_8  <= 1'b1;
                            9:  fast_chip_en_9  <= 1'b1; 10: fast_chip_en_10 <= 1'b1; 11: fast_chip_en_11 <= 1'b1;
                            12: fast_chip_en_12 <= 1'b1; 13: fast_chip_en_13 <= 1'b1; 14: fast_chip_en_14 <= 1'b1;
                            15: fast_chip_en_15 <= 1'b1; 16: fast_chip_en_16 <= 1'b1; 17: fast_chip_en_17 <= 1'b1;
                            18: fast_chip_en_18 <= 1'b1; 19: fast_chip_en_19 <= 1'b1; 20: fast_chip_en_20 <= 1'b1;
                            21: fast_chip_en_21 <= 1'b1; 22: fast_chip_en_22 <= 1'b1; 23: fast_chip_en_23 <= 1'b1;

                            default: begin
                                fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
                                fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
                                fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
                                fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
                                fast_chip_en_12 <= 1'b0; fast_chip_en_13 <= 1'b0; fast_chip_en_14 <= 1'b0;
                                fast_chip_en_15 <= 1'b0; fast_chip_en_16 <= 1'b0; fast_chip_en_17 <= 1'b0;
                                fast_chip_en_18 <= 1'b0; fast_chip_en_19 <= 1'b0; fast_chip_en_20 <= 1'b0;
                                fast_chip_en_21 <= 1'b0; fast_chip_en_22 <= 1'b0; fast_chip_en_23 <= 1'b0;
                            end
                        endcase
                    end
                end
            end
            else if (RD & RD_EN) begin
                fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
                fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
                fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
                fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
                fast_chip_en_12 <= 1'b0; fast_chip_en_13 <= 1'b0; fast_chip_en_14 <= 1'b0;
                fast_chip_en_15 <= 1'b0; fast_chip_en_16 <= 1'b0; fast_chip_en_17 <= 1'b0;
                fast_chip_en_18 <= 1'b0; fast_chip_en_19 <= 1'b0; fast_chip_en_20 <= 1'b0;
                fast_chip_en_21 <= 1'b0; fast_chip_en_22 <= 1'b0; fast_chip_en_23 <= 1'b0;
            end
        end
        else begin
            fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
            fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
            fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
            fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
            fast_chip_en_12 <= 1'b0; fast_chip_en_13 <= 1'b0; fast_chip_en_14 <= 1'b0;
            fast_chip_en_15 <= 1'b0; fast_chip_en_16 <= 1'b0; fast_chip_en_17 <= 1'b0;
            fast_chip_en_18 <= 1'b0; fast_chip_en_19 <= 1'b0; fast_chip_en_20 <= 1'b0;
            fast_chip_en_21 <= 1'b0; fast_chip_en_22 <= 1'b0; fast_chip_en_23 <= 1'b0;

            if (pkt_en) begin
                if (rd_cnt%2 == 0) begin
                    if (RD & RD_EN) begin
                        case(rd_cnt >> 1)
                            0:  fast_chip_en_0  <= 1'b1; 1:  fast_chip_en_1  <= 1'b1; 2:  fast_chip_en_2  <= 1'b1;
                            3:  fast_chip_en_3  <= 1'b1; 4:  fast_chip_en_4  <= 1'b1; 5:  fast_chip_en_5  <= 1'b1;
                            6:  fast_chip_en_6  <= 1'b1; 7:  fast_chip_en_7  <= 1'b1; 8:  fast_chip_en_8  <= 1'b1;
                            9:  fast_chip_en_9  <= 1'b1; 10: fast_chip_en_10 <= 1'b1; 11: fast_chip_en_11 <= 1'b1;

                            default: begin
                                fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
                                fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
                                fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
                                fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
                            end
                        endcase
                    end
                end
            end
            else if (RD & RD_EN) begin
                fast_chip_en_0  <= 1'b0; fast_chip_en_1  <= 1'b0; fast_chip_en_2  <= 1'b0;
                fast_chip_en_3  <= 1'b0; fast_chip_en_4  <= 1'b0; fast_chip_en_5  <= 1'b0;
                fast_chip_en_6  <= 1'b0; fast_chip_en_7  <= 1'b0; fast_chip_en_8  <= 1'b0;
                fast_chip_en_9  <= 1'b0; fast_chip_en_10 <= 1'b0; fast_chip_en_11 <= 1'b0;
            end
        end
    end

    /* -----------------------------------------------------------------
     Gen fast_addr
     ----------------------------------------------------------------- */
    assign  fast_addr = addr;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr         <= 0;
            fast_rd_done <= 1'b0;
        end
        else if (curr_sta == READ_IDLE) begin
            if (rf_capture_start | rf_capture_again)
                fast_rd_done <= 1'b0;
        end
        else begin
            if (rf_96path_en) begin
                if ((RD_CNT_r == 9'd47) & RD & RD_EN & DATA_SEL) begin
                    if (&addr) begin
                        addr         <= 0;
                        fast_rd_done <= 1'b1;
                    end
                    else begin
                        addr <= addr + 1;
                    end
                end
            end
            else begin
                if ((RD_CNT_r == 9'd23) & RD & RD_EN & DATA_SEL) begin
                    if (&addr) begin
                        addr         <= 0;
                        fast_rd_done <= 1'b1;
                    end
                    else begin
                        addr <= addr + 1;
                    end
                end
            end
        end
    end

    /* -----------------------------------------------------------------
     DATA READ FSM logic
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            curr_sta <= READ_IDLE;
        else
            curr_sta <= next_sta;
    end

    always @(*) begin
        next_sta = curr_sta;
        read_en = 1'b0;
        case(curr_sta)
            READ_IDLE: begin
                if (fast_read_en) begin
                    if (rf_pkt_idle_length == 0)
                        next_sta = READ_ALWAYS;
                    else if (rf_pkt_data_length == 2'b00)
                        next_sta = READ_216BYTE;
                    else if (rf_pkt_data_length == 2'b01)
                        next_sta = READ_432BYTE;
                    else if (rf_pkt_data_length == 2'b10)
                        next_sta = READ_864BYTE;
                    else if (rf_pkt_data_length == 2'b11)
                        next_sta = READ_1728BYTE;
                end
            end

            READ_ALWAYS: begin
                read_en = 1'b1;
                if (fast_rd_done)
                    next_sta = READ_IDLE;
            end

            READ_216BYTE: begin
                read_en = 1'b1;
                if (fast_rd_done)
                    next_sta = READ_IDLE;
            end

            READ_432BYTE: begin
                read_en = 1'b1;
                if (fast_rd_done)
                    next_sta = READ_IDLE;
            end

            READ_864BYTE: begin
                read_en = 1'b1;
                if (fast_rd_done)
                    next_sta = READ_IDLE;
            end

            READ_1728BYTE: begin
                read_en = 1'b1;
                if (fast_rd_done)
                    next_sta = READ_IDLE;
            end

            default:next_sta = READ_IDLE;
        endcase
    end

    /* -----------------------------------------------------------------
     PKT FSM logic
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pkt_curr_sta <= PKT_IDLE;
        else
            pkt_curr_sta <= pkt_next_sta;
    end

    always @(*) begin
        begin
            pkt_next_sta = pkt_curr_sta;
        end
        case(pkt_curr_sta)
            PKT_IDLE: begin
                if (read_en) begin
                    if ((idle_cnt == rf_pkt_idle_length) & RD)
                        pkt_next_sta = PKT_VALID;
                end
            end

            PKT_VALID: begin
                if (curr_sta == READ_ALWAYS) begin
                    if (fast_rd_done)
                        pkt_next_sta = PKT_IDLE;
                end
                else if (curr_sta == READ_216BYTE) begin
                    if (addr%2 == 1) begin
                        if (rf_96path_en) begin
                            if ((RD_CNT_r == 9'd47) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if ((RD_CNT_r == 9'd23) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
                else if (curr_sta == READ_432BYTE) begin
                    if (addr%4 == 3) begin
                        if (rf_96path_en) begin
                            if ((RD_CNT_r == 9'd47) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if ((RD_CNT_r == 9'd23) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
                else if (curr_sta == READ_864BYTE) begin
                    if (addr%8 == 7) begin
                        if (rf_96path_en) begin
                            if ((RD_CNT_r == 9'd47) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if ((RD_CNT_r == 9'd23) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
                else if (READ_1728BYTE) begin
                    if (addr%16 == 15) begin
                        if (rf_96path_en) begin
                            if ((RD_CNT_r == 9'd47) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if ((RD_CNT_r == 9'd23) & RD)
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
            end

            default:next_sta = PKT_IDLE;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            idle_cnt <= 0;
        else if (pkt_next_sta == PKT_IDLE)
            pkt_en <= 1'b0;
        else
            pkt_en <= 1'b1;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            idle_cnt <= 0;
        else if ((idle_cnt == rf_pkt_idle_length) && (RD == 1'b1))
            idle_cnt <= 0;
        else if (read_en) begin
            if (pkt_curr_sta == PKT_IDLE) begin
                if (RD) 
                    idle_cnt <= idle_cnt + 1;
            end
        end
        else
            idle_cnt <= 0;
    end

endmodule
