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
module gen_read_logic_fast
(
    input   wire            clk,
    input   wire            rstn,

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

    output  reg     [14:0]  fast_addr_0,
    output  reg     [14:0]  fast_addr_1,
    output  reg     [14:0]  fast_addr_2,
    output  reg     [14:0]  fast_addr_3,
    output  reg     [14:0]  fast_addr_4,
    output  reg     [14:0]  fast_addr_5,
    output  reg     [14:0]  fast_addr_6,
    output  reg     [14:0]  fast_addr_7,
    output  reg     [14:0]  fast_addr_8,
    output  reg     [14:0]  fast_addr_9,
    output  reg     [14:0]  fast_addr_10,
    output  reg     [14:0]  fast_addr_11,
    output  reg     [14:0]  fast_addr_12,
    output  reg     [14:0]  fast_addr_13,
    output  reg     [14:0]  fast_addr_14,
    output  reg     [14:0]  fast_addr_15,
    output  reg     [14:0]  fast_addr_16,
    output  reg     [14:0]  fast_addr_17,
    output  reg     [14:0]  fast_addr_18,
    output  reg     [14:0]  fast_addr_19,
    output  reg     [14:0]  fast_addr_20,
    output  reg     [14:0]  fast_addr_21,
    output  reg     [14:0]  fast_addr_22,
    output  reg     [14:0]  fast_addr_23,

    output  reg             fast_rd_done,

    output  reg     [17:0]  ADC_DATA,
    output  reg             ADC_DATA_VALID
);

    // DATA READ FSM
    localparam      READ_IDLE       = 6'b00_0001,
                    READ_216BYTE    = 6'b00_0010,
                    READ_432BYTE    = 6'b00_0100,
                    READ_864BYTE    = 6'b00_1000,
                    READ_1728BYTE   = 6'b01_0000,
                    READ_DONE       = 6'b10_0000;

    reg     [5:0]   curr_sta;
    reg     [5:0]   next_sta;

    // PKT FSM
    localparam      PKT_IDLE    = 2'b01,
                    PKT_VALID   = 2'b10;

    reg     [1:0]   pkt_curr_sta;
    reg     [1:0]   pkt_next_sta;

    // ctrl logic
    reg             RD;
    reg     [8:0]   RD_CNT;

    reg     [35:0]  PKT_DATA;
    reg     [35:0]  DATA_216;
    reg     [35:0]  DATA_432;
    reg     [35:0]  DATA_864;
    reg     [35:0]  DATA_1728;

    reg     [15:0]  idle_cnt;
    reg             pkt_en;
    reg     [14:0]  addr;

    reg             fast_chip_en216_0;
    reg             fast_chip_en216_1;
    reg             fast_chip_en216_2;
    reg             fast_chip_en216_3;
    reg             fast_chip_en216_4;
    reg             fast_chip_en216_5;
    reg             fast_chip_en216_6;
    reg             fast_chip_en216_7;
    reg             fast_chip_en216_8;
    reg             fast_chip_en216_9;
    reg             fast_chip_en216_10;
    reg             fast_chip_en216_11;
    reg             fast_chip_en216_12;
    reg             fast_chip_en216_13;
    reg             fast_chip_en216_14;
    reg             fast_chip_en216_15;
    reg             fast_chip_en216_16;
    reg             fast_chip_en216_17;
    reg             fast_chip_en216_18;
    reg             fast_chip_en216_19;
    reg             fast_chip_en216_20;
    reg             fast_chip_en216_21;
    reg             fast_chip_en216_22;
    reg             fast_chip_en216_23;

    reg             fast_chip_en432_0;
    reg             fast_chip_en432_1;
    reg             fast_chip_en432_2;
    reg             fast_chip_en432_3;
    reg             fast_chip_en432_4;
    reg             fast_chip_en432_5;
    reg             fast_chip_en432_6;
    reg             fast_chip_en432_7;
    reg             fast_chip_en432_8;
    reg             fast_chip_en432_9;
    reg             fast_chip_en432_10;
    reg             fast_chip_en432_11;
    reg             fast_chip_en432_12;
    reg             fast_chip_en432_13;
    reg             fast_chip_en432_14;
    reg             fast_chip_en432_15;
    reg             fast_chip_en432_16;
    reg             fast_chip_en432_17;
    reg             fast_chip_en432_18;
    reg             fast_chip_en432_19;
    reg             fast_chip_en432_20;
    reg             fast_chip_en432_21;
    reg             fast_chip_en432_22;
    reg             fast_chip_en432_23;

    reg             fast_chip_en864_0;
    reg             fast_chip_en864_1;
    reg             fast_chip_en864_2;
    reg             fast_chip_en864_3;
    reg             fast_chip_en864_4;
    reg             fast_chip_en864_5;
    reg             fast_chip_en864_6;
    reg             fast_chip_en864_7;
    reg             fast_chip_en864_8;
    reg             fast_chip_en864_9;
    reg             fast_chip_en864_10;
    reg             fast_chip_en864_11;
    reg             fast_chip_en864_12;
    reg             fast_chip_en864_13;
    reg             fast_chip_en864_14;
    reg             fast_chip_en864_15;
    reg             fast_chip_en864_16;
    reg             fast_chip_en864_17;
    reg             fast_chip_en864_18;
    reg             fast_chip_en864_19;
    reg             fast_chip_en864_20;
    reg             fast_chip_en864_21;
    reg             fast_chip_en864_22;
    reg             fast_chip_en864_23;

    reg             fast_chip_en1728_0;
    reg             fast_chip_en1728_1;
    reg             fast_chip_en1728_2;
    reg             fast_chip_en1728_3;
    reg             fast_chip_en1728_4;
    reg             fast_chip_en1728_5;
    reg             fast_chip_en1728_6;
    reg             fast_chip_en1728_7;
    reg             fast_chip_en1728_8;
    reg             fast_chip_en1728_9;
    reg             fast_chip_en1728_10;
    reg             fast_chip_en1728_11;
    reg             fast_chip_en1728_12;
    reg             fast_chip_en1728_13;
    reg             fast_chip_en1728_14;
    reg             fast_chip_en1728_15;
    reg             fast_chip_en1728_16;
    reg             fast_chip_en1728_17;
    reg             fast_chip_en1728_18;
    reg             fast_chip_en1728_19;
    reg             fast_chip_en1728_20;
    reg             fast_chip_en1728_21;
    reg             fast_chip_en1728_22;
    reg             fast_chip_en1728_23;

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
            RD_CNT <= 9'd0;
        else
        case(curr_sta)
            READ_216BYTE: begin
                if (pkt_en) begin
                    if (rf_96path_en) begin
                        if ((RD_CNT == 9'd47) && (RD == 1'b1))
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                    else begin
                        if (RD_CNT == 9'd23)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                end
            end

            READ_432BYTE: begin
                if (pkt_en) begin
                    if (rf_96path_en) begin
                        if (RD_CNT == 9'd95)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                    else begin
                        if (RD_CNT == 9'd47)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                end
            end

            READ_864BYTE: begin
                if (pkt_en) begin
                    if (rf_96path_en) begin
                        if (RD_CNT == 9'd191)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                    else begin
                        if (RD_CNT == 9'd95)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                end
            end

            READ_1728BYTE: begin
                if (pkt_en) begin
                    if (rf_96path_en) begin
                        if (RD_CNT == 9'd383)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                    else begin
                        if (RD_CNT == 9'd191)
                            RD_CNT <= 9'd0;
                        else if (RD)
                            RD_CNT <= RD_CNT + 1;
                    end
                end
            end

            default: RD_CNT <= 9'd0;
        endcase
    end

    reg pkt_en_r;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pkt_en_r <= 1'b0;
        else if (RD)
            pkt_en_r <= pkt_en;
    end

    /* -----------------------------------------------------------------
     Gen ADC_DATA_VALID
     ----------------------------------------------------------------- */
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            ADC_DATA_VALID <= 1'b0;
        else if (pkt_en_r)
            ADC_DATA_VALID <= 1'b1;
        else
            ADC_DATA_VALID <= 1'b0;
    end

    /* -----------------------------------------------------------------
     Gen ADC_DATA
     ----------------------------------------------------------------- */
    reg RD_EN;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            RD_EN <= 1'b0;
        else if (pkt_en_r) begin
            if (RD)
                RD_EN <= RD_EN + 1'b1;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            ADC_DATA <= 18'h0;
        else if (pkt_en_r) begin
            if (RD_EN)
                ADC_DATA <= PKT_DATA[35:18];
            else
                ADC_DATA <= PKT_DATA[17:0];
        end
        else
            ADC_DATA <= 18'h0;
    end

    always @(*) begin
        case(curr_sta)
            READ_216BYTE: begin
                PKT_DATA = DATA_216;
            end

            READ_432BYTE: begin
                PKT_DATA = DATA_432;
            end

            READ_864BYTE: begin
                PKT_DATA = DATA_864;
            end

            READ_1728BYTE: begin
                PKT_DATA = DATA_1728;
            end

            default: PKT_DATA = 36'h0;
        endcase
            
    end

    reg [8:0] RD_CNT_r;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            RD_CNT_r <= 9'd0;
        else if (RD)
            RD_CNT_r <= RD_CNT;
    end

    always @(*) begin
        if (RD_CNT_r%2 == 0) begin
            case(RD_CNT_r/2)
                0:  DATA_216 = fast_din_0;  1:  DATA_216 = fast_din_1;  2:  DATA_216 = fast_din_2;
                3:  DATA_216 = fast_din_3;  4:  DATA_216 = fast_din_4;  5:  DATA_216 = fast_din_5;
                6:  DATA_216 = fast_din_6;  7:  DATA_216 = fast_din_7;  8:  DATA_216 = fast_din_8;
                9:  DATA_216 = fast_din_9;  10: DATA_216 = fast_din_10; 11: DATA_216 = fast_din_11;
                12: DATA_216 = fast_din_12; 13: DATA_216 = fast_din_13; 14: DATA_216 = fast_din_14;
                15: DATA_216 = fast_din_15; 16: DATA_216 = fast_din_16; 17: DATA_216 = fast_din_17;
                18: DATA_216 = fast_din_18; 19: DATA_216 = fast_din_19; 20: DATA_216 = fast_din_20;
                21: DATA_216 = fast_din_21; 22: DATA_216 = fast_din_22; 23: DATA_216 = fast_din_23;
                default: DATA_216 = 36'h0;
            endcase
        end
    end

    always @(*) begin
        case(RD_CNT/4)
            0:  DATA_432 = fast_din_0;  1:  DATA_432 = fast_din_1;  2:  DATA_432 = fast_din_2;
            3:  DATA_432 = fast_din_3;  4:  DATA_432 = fast_din_4;  5:  DATA_432 = fast_din_5;
            6:  DATA_432 = fast_din_6;  7:  DATA_432 = fast_din_7;  8:  DATA_432 = fast_din_8;
            9:  DATA_432 = fast_din_9;  10: DATA_432 = fast_din_10; 11: DATA_432 = fast_din_11;
            12: DATA_432 = fast_din_12; 13: DATA_432 = fast_din_13; 14: DATA_432 = fast_din_14;
            15: DATA_432 = fast_din_15; 16: DATA_432 = fast_din_16; 17: DATA_432 = fast_din_17;
            18: DATA_432 = fast_din_18; 19: DATA_432 = fast_din_19; 20: DATA_432 = fast_din_20;
            21: DATA_432 = fast_din_21; 22: DATA_432 = fast_din_22; 23: DATA_432 = fast_din_23;
            default: DATA_432 = 36'h0;
        endcase
    end

    always @(*) begin
        case(RD_CNT/8)
            0:  DATA_864 = fast_din_0;  1:  DATA_864 = fast_din_1;  2:  DATA_864 = fast_din_2;
            3:  DATA_864 = fast_din_3;  4:  DATA_864 = fast_din_4;  5:  DATA_864 = fast_din_5;
            6:  DATA_864 = fast_din_6;  7:  DATA_864 = fast_din_7;  8:  DATA_864 = fast_din_8;
            9:  DATA_864 = fast_din_9;  10: DATA_864 = fast_din_10; 11: DATA_864 = fast_din_11;
            12: DATA_864 = fast_din_12; 13: DATA_864 = fast_din_13; 14: DATA_864 = fast_din_14;
            15: DATA_864 = fast_din_15; 16: DATA_864 = fast_din_16; 17: DATA_864 = fast_din_17;
            18: DATA_864 = fast_din_18; 19: DATA_864 = fast_din_19; 20: DATA_864 = fast_din_20;
            21: DATA_864 = fast_din_21; 22: DATA_864 = fast_din_22; 23: DATA_864 = fast_din_23;
            default: DATA_864 = 36'h0;
        endcase
    end

    always @(*) begin
        case(RD_CNT/16)
            0:  DATA_1728 = fast_din_0;  1:  DATA_1728 = fast_din_1;  2:  DATA_1728 = fast_din_2;
            3:  DATA_1728 = fast_din_3;  4:  DATA_1728 = fast_din_4;  5:  DATA_1728 = fast_din_5;
            6:  DATA_1728 = fast_din_6;  7:  DATA_1728 = fast_din_7;  8:  DATA_1728 = fast_din_8;
            9:  DATA_1728 = fast_din_9;  10: DATA_1728 = fast_din_10; 11: DATA_1728 = fast_din_11;
            12: DATA_1728 = fast_din_12; 13: DATA_1728 = fast_din_13; 14: DATA_1728 = fast_din_14;
            15: DATA_1728 = fast_din_15; 16: DATA_1728 = fast_din_16; 17: DATA_1728 = fast_din_17;
            18: DATA_1728 = fast_din_18; 19: DATA_1728 = fast_din_19; 20: DATA_1728 = fast_din_20;
            21: DATA_1728 = fast_din_21; 22: DATA_1728 = fast_din_22; 23: DATA_1728 = fast_din_23;
            default: DATA_1728 = 36'h0;
        endcase
    end

    /* -----------------------------------------------------------------
     Gen fast_chip_en
     ----------------------------------------------------------------- */
    always @(*) begin
        if (rf_96path_en) begin
            case(curr_sta)
                READ_216BYTE: begin
                    fast_chip_en_0  = fast_chip_en216_0 ; fast_chip_en_1  = fast_chip_en216_1 ; fast_chip_en_2  = fast_chip_en216_2 ;
                    fast_chip_en_3  = fast_chip_en216_3 ; fast_chip_en_4  = fast_chip_en216_4 ; fast_chip_en_5  = fast_chip_en216_5 ;
                    fast_chip_en_6  = fast_chip_en216_6 ; fast_chip_en_7  = fast_chip_en216_7 ; fast_chip_en_8  = fast_chip_en216_8 ;
                    fast_chip_en_9  = fast_chip_en216_9 ; fast_chip_en_10 = fast_chip_en216_10; fast_chip_en_11 = fast_chip_en216_11;
                    fast_chip_en_12 = fast_chip_en216_12; fast_chip_en_13 = fast_chip_en216_13; fast_chip_en_14 = fast_chip_en216_14;
                    fast_chip_en_15 = fast_chip_en216_15; fast_chip_en_16 = fast_chip_en216_16; fast_chip_en_17 = fast_chip_en216_17;
                    fast_chip_en_18 = fast_chip_en216_18; fast_chip_en_19 = fast_chip_en216_19; fast_chip_en_20 = fast_chip_en216_20;
                    fast_chip_en_21 = fast_chip_en216_21; fast_chip_en_22 = fast_chip_en216_22; fast_chip_en_23 = fast_chip_en216_23;
                end

                READ_432BYTE: begin
                    fast_chip_en_0  = fast_chip_en432_0 ; fast_chip_en_1  = fast_chip_en432_1 ; fast_chip_en_2  = fast_chip_en432_2 ;
                    fast_chip_en_3  = fast_chip_en432_3 ; fast_chip_en_4  = fast_chip_en432_4 ; fast_chip_en_5  = fast_chip_en432_5 ;
                    fast_chip_en_6  = fast_chip_en432_6 ; fast_chip_en_7  = fast_chip_en432_7 ; fast_chip_en_8  = fast_chip_en432_8 ;
                    fast_chip_en_9  = fast_chip_en432_9 ; fast_chip_en_10 = fast_chip_en432_10; fast_chip_en_11 = fast_chip_en432_11;
                    fast_chip_en_12 = fast_chip_en432_12; fast_chip_en_13 = fast_chip_en432_13; fast_chip_en_14 = fast_chip_en432_14;
                    fast_chip_en_15 = fast_chip_en432_15; fast_chip_en_16 = fast_chip_en432_16; fast_chip_en_17 = fast_chip_en432_17;
                    fast_chip_en_18 = fast_chip_en432_18; fast_chip_en_19 = fast_chip_en432_19; fast_chip_en_20 = fast_chip_en432_20;
                    fast_chip_en_21 = fast_chip_en432_21; fast_chip_en_22 = fast_chip_en432_22; fast_chip_en_23 = fast_chip_en432_23;
                end

                READ_864BYTE: begin
                    fast_chip_en_0  = fast_chip_en864_0 ; fast_chip_en_1  = fast_chip_en864_1 ; fast_chip_en_2  = fast_chip_en864_2 ;
                    fast_chip_en_3  = fast_chip_en864_3 ; fast_chip_en_4  = fast_chip_en864_4 ; fast_chip_en_5  = fast_chip_en864_5 ;
                    fast_chip_en_6  = fast_chip_en864_6 ; fast_chip_en_7  = fast_chip_en864_7 ; fast_chip_en_8  = fast_chip_en864_8 ;
                    fast_chip_en_9  = fast_chip_en864_9 ; fast_chip_en_10 = fast_chip_en864_10; fast_chip_en_11 = fast_chip_en864_11;
                    fast_chip_en_12 = fast_chip_en864_12; fast_chip_en_13 = fast_chip_en864_13; fast_chip_en_14 = fast_chip_en864_14;
                    fast_chip_en_15 = fast_chip_en864_15; fast_chip_en_16 = fast_chip_en864_16; fast_chip_en_17 = fast_chip_en864_17;
                    fast_chip_en_18 = fast_chip_en864_18; fast_chip_en_19 = fast_chip_en864_19; fast_chip_en_20 = fast_chip_en864_20;
                    fast_chip_en_21 = fast_chip_en864_21; fast_chip_en_22 = fast_chip_en864_22; fast_chip_en_23 = fast_chip_en864_23;
                end

                READ_1728BYTE: begin
                    fast_chip_en_0  = fast_chip_en1728_0 ; fast_chip_en_1  = fast_chip_en1728_1 ; fast_chip_en_2  = fast_chip_en1728_2 ;
                    fast_chip_en_3  = fast_chip_en1728_3 ; fast_chip_en_4  = fast_chip_en1728_4 ; fast_chip_en_5  = fast_chip_en1728_5 ;
                    fast_chip_en_6  = fast_chip_en1728_6 ; fast_chip_en_7  = fast_chip_en1728_7 ; fast_chip_en_8  = fast_chip_en1728_8 ;
                    fast_chip_en_9  = fast_chip_en1728_9 ; fast_chip_en_10 = fast_chip_en1728_10; fast_chip_en_11 = fast_chip_en1728_11;
                    fast_chip_en_12 = fast_chip_en1728_12; fast_chip_en_13 = fast_chip_en1728_13; fast_chip_en_14 = fast_chip_en1728_14;
                    fast_chip_en_15 = fast_chip_en1728_15; fast_chip_en_16 = fast_chip_en1728_16; fast_chip_en_17 = fast_chip_en1728_17;
                    fast_chip_en_18 = fast_chip_en1728_18; fast_chip_en_19 = fast_chip_en1728_19; fast_chip_en_20 = fast_chip_en1728_20;
                    fast_chip_en_21 = fast_chip_en1728_21; fast_chip_en_22 = fast_chip_en1728_22; fast_chip_en_23 = fast_chip_en1728_23;
                end

                default: begin
                    fast_chip_en_0  = 1'b0; fast_chip_en_1  = 1'b0; fast_chip_en_2  = 1'b0;
                    fast_chip_en_3  = 1'b0; fast_chip_en_4  = 1'b0; fast_chip_en_5  = 1'b0;
                    fast_chip_en_6  = 1'b0; fast_chip_en_7  = 1'b0; fast_chip_en_8  = 1'b0;
                    fast_chip_en_9  = 1'b0; fast_chip_en_10 = 1'b0; fast_chip_en_11 = 1'b0;
                    fast_chip_en_12 = 1'b0; fast_chip_en_13 = 1'b0; fast_chip_en_14 = 1'b0;
                    fast_chip_en_15 = 1'b0; fast_chip_en_16 = 1'b0; fast_chip_en_17 = 1'b0;
                    fast_chip_en_18 = 1'b0; fast_chip_en_19 = 1'b0; fast_chip_en_20 = 1'b0;
                    fast_chip_en_21 = 1'b0; fast_chip_en_22 = 1'b0; fast_chip_en_23 = 1'b0;
                end
            endcase
        end
        else begin
            fast_chip_en_0  = 1'b0; fast_chip_en_1  = 1'b0; fast_chip_en_2  = 1'b0;
            fast_chip_en_3  = 1'b0; fast_chip_en_4  = 1'b0; fast_chip_en_5  = 1'b0;
            fast_chip_en_6  = 1'b0; fast_chip_en_7  = 1'b0; fast_chip_en_8  = 1'b0;
            fast_chip_en_9  = 1'b0; fast_chip_en_10 = 1'b0; fast_chip_en_11 = 1'b0;
            fast_chip_en_12 = 1'b0; fast_chip_en_13 = 1'b0; fast_chip_en_14 = 1'b0;
            fast_chip_en_15 = 1'b0; fast_chip_en_16 = 1'b0; fast_chip_en_17 = 1'b0;
            fast_chip_en_18 = 1'b0; fast_chip_en_19 = 1'b0; fast_chip_en_20 = 1'b0;
            fast_chip_en_21 = 1'b0; fast_chip_en_22 = 1'b0; fast_chip_en_23 = 1'b0;

            case(curr_sta)
                READ_216BYTE: begin
                    fast_chip_en_0  = fast_chip_en216_0 ; fast_chip_en_1  = fast_chip_en216_1 ; fast_chip_en_2  = fast_chip_en216_2 ;
                    fast_chip_en_3  = fast_chip_en216_3 ; fast_chip_en_4  = fast_chip_en216_4 ; fast_chip_en_5  = fast_chip_en216_5 ;
                    fast_chip_en_6  = fast_chip_en216_6 ; fast_chip_en_7  = fast_chip_en216_7 ; fast_chip_en_8  = fast_chip_en216_8 ;
                    fast_chip_en_9  = fast_chip_en216_9 ; fast_chip_en_10 = fast_chip_en216_10; fast_chip_en_11 = fast_chip_en216_11;
                end

                READ_432BYTE: begin
                    fast_chip_en_0  = fast_chip_en432_0 ; fast_chip_en_1  = fast_chip_en432_1 ; fast_chip_en_2  = fast_chip_en432_2 ;
                    fast_chip_en_3  = fast_chip_en432_3 ; fast_chip_en_4  = fast_chip_en432_4 ; fast_chip_en_5  = fast_chip_en432_5 ;
                    fast_chip_en_6  = fast_chip_en432_6 ; fast_chip_en_7  = fast_chip_en432_7 ; fast_chip_en_8  = fast_chip_en432_8 ;
                    fast_chip_en_9  = fast_chip_en432_9 ; fast_chip_en_10 = fast_chip_en432_10; fast_chip_en_11 = fast_chip_en432_11;
                end

                READ_864BYTE: begin
                    fast_chip_en_0  = fast_chip_en864_0 ; fast_chip_en_1  = fast_chip_en864_1 ; fast_chip_en_2  = fast_chip_en864_2 ;
                    fast_chip_en_3  = fast_chip_en864_3 ; fast_chip_en_4  = fast_chip_en864_4 ; fast_chip_en_5  = fast_chip_en864_5 ;
                    fast_chip_en_6  = fast_chip_en864_6 ; fast_chip_en_7  = fast_chip_en864_7 ; fast_chip_en_8  = fast_chip_en864_8 ;
                    fast_chip_en_9  = fast_chip_en864_9 ; fast_chip_en_10 = fast_chip_en864_10; fast_chip_en_11 = fast_chip_en864_11;
                end

                READ_1728BYTE: begin
                    fast_chip_en_0  = fast_chip_en1728_0 ; fast_chip_en_1  = fast_chip_en1728_1 ; fast_chip_en_2  = fast_chip_en1728_2 ;
                    fast_chip_en_3  = fast_chip_en1728_3 ; fast_chip_en_4  = fast_chip_en1728_4 ; fast_chip_en_5  = fast_chip_en1728_5 ;
                    fast_chip_en_6  = fast_chip_en1728_6 ; fast_chip_en_7  = fast_chip_en1728_7 ; fast_chip_en_8  = fast_chip_en1728_8 ;
                    fast_chip_en_9  = fast_chip_en1728_9 ; fast_chip_en_10 = fast_chip_en1728_10; fast_chip_en_11 = fast_chip_en1728_11;
                end

                default: begin
                    fast_chip_en_0  = 1'b0; fast_chip_en_1  = 1'b0; fast_chip_en_2  = 1'b0;
                    fast_chip_en_3  = 1'b0; fast_chip_en_4  = 1'b0; fast_chip_en_5  = 1'b0;
                    fast_chip_en_6  = 1'b0; fast_chip_en_7  = 1'b0; fast_chip_en_8  = 1'b0;
                    fast_chip_en_9  = 1'b0; fast_chip_en_10 = 1'b0; fast_chip_en_11 = 1'b0;
                    fast_chip_en_12 = 1'b0; fast_chip_en_13 = 1'b0; fast_chip_en_14 = 1'b0;
                    fast_chip_en_15 = 1'b0; fast_chip_en_16 = 1'b0; fast_chip_en_17 = 1'b0;
                    fast_chip_en_18 = 1'b0; fast_chip_en_19 = 1'b0; fast_chip_en_20 = 1'b0;
                    fast_chip_en_21 = 1'b0; fast_chip_en_22 = 1'b0; fast_chip_en_23 = 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            fast_chip_en216_0  <= 1'b0; fast_chip_en216_1  <= 1'b0; fast_chip_en216_2  <= 1'b0;
            fast_chip_en216_3  <= 1'b0; fast_chip_en216_4  <= 1'b0; fast_chip_en216_5  <= 1'b0;
            fast_chip_en216_6  <= 1'b0; fast_chip_en216_7  <= 1'b0; fast_chip_en216_8  <= 1'b0;
            fast_chip_en216_9  <= 1'b0; fast_chip_en216_10 <= 1'b0; fast_chip_en216_11 <= 1'b0;
            fast_chip_en216_12 <= 1'b0; fast_chip_en216_13 <= 1'b0; fast_chip_en216_14 <= 1'b0;
            fast_chip_en216_15 <= 1'b0; fast_chip_en216_16 <= 1'b0; fast_chip_en216_17 <= 1'b0;
            fast_chip_en216_18 <= 1'b0; fast_chip_en216_19 <= 1'b0; fast_chip_en216_20 <= 1'b0;
            fast_chip_en216_21 <= 1'b0; fast_chip_en216_22 <= 1'b0; fast_chip_en216_23 <= 1'b0;
        end
        else if (pkt_en) begin
            begin
                fast_chip_en216_0  <= 1'b0; fast_chip_en216_1  <= 1'b0; fast_chip_en216_2  <= 1'b0;
                fast_chip_en216_3  <= 1'b0; fast_chip_en216_4  <= 1'b0; fast_chip_en216_5  <= 1'b0;
                fast_chip_en216_6  <= 1'b0; fast_chip_en216_7  <= 1'b0; fast_chip_en216_8  <= 1'b0;
                fast_chip_en216_9  <= 1'b0; fast_chip_en216_10 <= 1'b0; fast_chip_en216_11 <= 1'b0;
                fast_chip_en216_12 <= 1'b0; fast_chip_en216_13 <= 1'b0; fast_chip_en216_14 <= 1'b0;
                fast_chip_en216_15 <= 1'b0; fast_chip_en216_16 <= 1'b0; fast_chip_en216_17 <= 1'b0;
                fast_chip_en216_18 <= 1'b0; fast_chip_en216_19 <= 1'b0; fast_chip_en216_20 <= 1'b0;
                fast_chip_en216_21 <= 1'b0; fast_chip_en216_22 <= 1'b0; fast_chip_en216_23 <= 1'b0;
            end
            if (RD_CNT%2 == 0) begin
                case(RD_CNT/2)

                    0:  fast_chip_en216_0  <= 1'b1; 1:  fast_chip_en216_1  <= 1'b1; 2:  fast_chip_en216_2  <= 1'b1;
                    3:  fast_chip_en216_3  <= 1'b1; 4:  fast_chip_en216_4  <= 1'b1; 5:  fast_chip_en216_5  <= 1'b1;
                    6:  fast_chip_en216_6  <= 1'b1; 7:  fast_chip_en216_7  <= 1'b1; 8:  fast_chip_en216_8  <= 1'b1;
                    9:  fast_chip_en216_9  <= 1'b1; 10: fast_chip_en216_10 <= 1'b1; 11: fast_chip_en216_11 <= 1'b1;
                    12: fast_chip_en216_12 <= 1'b1; 13: fast_chip_en216_13 <= 1'b1; 14: fast_chip_en216_14 <= 1'b1;
                    15: fast_chip_en216_15 <= 1'b1; 16: fast_chip_en216_16 <= 1'b1; 17: fast_chip_en216_17 <= 1'b1;
                    18: fast_chip_en216_18 <= 1'b1; 19: fast_chip_en216_19 <= 1'b1; 20: fast_chip_en216_20 <= 1'b1;
                    21: fast_chip_en216_21 <= 1'b1; 22: fast_chip_en216_22 <= 1'b1; 23: fast_chip_en216_23 <= 1'b1;

                    default: begin
                        fast_chip_en216_0  <= 1'b0; fast_chip_en216_1  <= 1'b0; fast_chip_en216_2  <= 1'b0;
                        fast_chip_en216_3  <= 1'b0; fast_chip_en216_4  <= 1'b0; fast_chip_en216_5  <= 1'b0;
                        fast_chip_en216_6  <= 1'b0; fast_chip_en216_7  <= 1'b0; fast_chip_en216_8  <= 1'b0;
                        fast_chip_en216_9  <= 1'b0; fast_chip_en216_10 <= 1'b0; fast_chip_en216_11 <= 1'b0;
                        fast_chip_en216_12 <= 1'b0; fast_chip_en216_13 <= 1'b0; fast_chip_en216_14 <= 1'b0;
                        fast_chip_en216_15 <= 1'b0; fast_chip_en216_16 <= 1'b0; fast_chip_en216_17 <= 1'b0;
                        fast_chip_en216_18 <= 1'b0; fast_chip_en216_19 <= 1'b0; fast_chip_en216_20 <= 1'b0;
                        fast_chip_en216_21 <= 1'b0; fast_chip_en216_22 <= 1'b0; fast_chip_en216_23 <= 1'b0;
                    end
                endcase
            end
        end
        else begin
            fast_chip_en216_0  <= 1'b0; fast_chip_en216_1  <= 1'b0; fast_chip_en216_2  <= 1'b0;
            fast_chip_en216_3  <= 1'b0; fast_chip_en216_4  <= 1'b0; fast_chip_en216_5  <= 1'b0;
            fast_chip_en216_6  <= 1'b0; fast_chip_en216_7  <= 1'b0; fast_chip_en216_8  <= 1'b0;
            fast_chip_en216_9  <= 1'b0; fast_chip_en216_10 <= 1'b0; fast_chip_en216_11 <= 1'b0;
            fast_chip_en216_12 <= 1'b0; fast_chip_en216_13 <= 1'b0; fast_chip_en216_14 <= 1'b0;
            fast_chip_en216_15 <= 1'b0; fast_chip_en216_16 <= 1'b0; fast_chip_en216_17 <= 1'b0;
            fast_chip_en216_18 <= 1'b0; fast_chip_en216_19 <= 1'b0; fast_chip_en216_20 <= 1'b0;
            fast_chip_en216_21 <= 1'b0; fast_chip_en216_22 <= 1'b0; fast_chip_en216_23 <= 1'b0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            fast_chip_en432_0  <= 1'b0; fast_chip_en432_1  <= 1'b0; fast_chip_en432_2  <= 1'b0;
            fast_chip_en432_3  <= 1'b0; fast_chip_en432_4  <= 1'b0; fast_chip_en432_5  <= 1'b0;
            fast_chip_en432_6  <= 1'b0; fast_chip_en432_7  <= 1'b0; fast_chip_en432_8  <= 1'b0;
            fast_chip_en432_9  <= 1'b0; fast_chip_en432_10 <= 1'b0; fast_chip_en432_11 <= 1'b0;
            fast_chip_en432_12 <= 1'b0; fast_chip_en432_13 <= 1'b0; fast_chip_en432_14 <= 1'b0;
            fast_chip_en432_15 <= 1'b0; fast_chip_en432_16 <= 1'b0; fast_chip_en432_17 <= 1'b0;
            fast_chip_en432_18 <= 1'b0; fast_chip_en432_19 <= 1'b0; fast_chip_en432_20 <= 1'b0;
            fast_chip_en432_21 <= 1'b0; fast_chip_en432_22 <= 1'b0; fast_chip_en432_23 <= 1'b0;
        end
        else
            begin
                fast_chip_en432_0  <= 1'b0; fast_chip_en432_1  <= 1'b0; fast_chip_en432_2  <= 1'b0;
                fast_chip_en432_3  <= 1'b0; fast_chip_en432_4  <= 1'b0; fast_chip_en432_5  <= 1'b0;
                fast_chip_en432_6  <= 1'b0; fast_chip_en432_7  <= 1'b0; fast_chip_en432_8  <= 1'b0;
                fast_chip_en432_9  <= 1'b0; fast_chip_en432_10 <= 1'b0; fast_chip_en432_11 <= 1'b0;
                fast_chip_en432_12 <= 1'b0; fast_chip_en432_13 <= 1'b0; fast_chip_en432_14 <= 1'b0;
                fast_chip_en432_15 <= 1'b0; fast_chip_en432_16 <= 1'b0; fast_chip_en432_17 <= 1'b0;
                fast_chip_en432_18 <= 1'b0; fast_chip_en432_19 <= 1'b0; fast_chip_en432_20 <= 1'b0;
                fast_chip_en432_21 <= 1'b0; fast_chip_en432_22 <= 1'b0; fast_chip_en432_23 <= 1'b0;
            end
        if (RD_CNT%2 == 0) begin
            case(RD_CNT/4)

                0:  fast_chip_en432_0  <= 1'b1; 1:  fast_chip_en432_1  <= 1'b1; 2:  fast_chip_en432_2  <= 1'b1;
                3:  fast_chip_en432_3  <= 1'b1; 4:  fast_chip_en432_4  <= 1'b1; 5:  fast_chip_en432_5  <= 1'b1;
                6:  fast_chip_en432_6  <= 1'b1; 7:  fast_chip_en432_7  <= 1'b1; 8:  fast_chip_en432_8  <= 1'b1;
                9:  fast_chip_en432_9  <= 1'b1; 10: fast_chip_en432_10 <= 1'b1; 11: fast_chip_en432_11 <= 1'b1;
                12: fast_chip_en432_12 <= 1'b1; 13: fast_chip_en432_13 <= 1'b1; 14: fast_chip_en432_14 <= 1'b1;
                15: fast_chip_en432_15 <= 1'b1; 16: fast_chip_en432_16 <= 1'b1; 17: fast_chip_en432_17 <= 1'b1;
                18: fast_chip_en432_18 <= 1'b1; 19: fast_chip_en432_19 <= 1'b1; 20: fast_chip_en432_20 <= 1'b1;
                21: fast_chip_en432_21 <= 1'b1; 22: fast_chip_en432_22 <= 1'b1; 23: fast_chip_en432_23 <= 1'b1;

                default: begin
                    fast_chip_en432_0  <= 1'b0; fast_chip_en432_1  <= 1'b0; fast_chip_en432_2  <= 1'b0;
                    fast_chip_en432_3  <= 1'b0; fast_chip_en432_4  <= 1'b0; fast_chip_en432_5  <= 1'b0;
                    fast_chip_en432_6  <= 1'b0; fast_chip_en432_7  <= 1'b0; fast_chip_en432_8  <= 1'b0;
                    fast_chip_en432_9  <= 1'b0; fast_chip_en432_10 <= 1'b0; fast_chip_en432_11 <= 1'b0;
                    fast_chip_en432_12 <= 1'b0; fast_chip_en432_13 <= 1'b0; fast_chip_en432_14 <= 1'b0;
                    fast_chip_en432_15 <= 1'b0; fast_chip_en432_16 <= 1'b0; fast_chip_en432_17 <= 1'b0;
                    fast_chip_en432_18 <= 1'b0; fast_chip_en432_19 <= 1'b0; fast_chip_en432_20 <= 1'b0;
                    fast_chip_en432_21 <= 1'b0; fast_chip_en432_22 <= 1'b0; fast_chip_en432_23 <= 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            fast_chip_en864_0  <= 1'b0; fast_chip_en864_1  <= 1'b0; fast_chip_en864_2  <= 1'b0;
            fast_chip_en864_3  <= 1'b0; fast_chip_en864_4  <= 1'b0; fast_chip_en864_5  <= 1'b0;
            fast_chip_en864_6  <= 1'b0; fast_chip_en864_7  <= 1'b0; fast_chip_en864_8  <= 1'b0;
            fast_chip_en864_9  <= 1'b0; fast_chip_en864_10 <= 1'b0; fast_chip_en864_11 <= 1'b0;
            fast_chip_en864_12 <= 1'b0; fast_chip_en864_13 <= 1'b0; fast_chip_en864_14 <= 1'b0;
            fast_chip_en864_15 <= 1'b0; fast_chip_en864_16 <= 1'b0; fast_chip_en864_17 <= 1'b0;
            fast_chip_en864_18 <= 1'b0; fast_chip_en864_19 <= 1'b0; fast_chip_en864_20 <= 1'b0;
            fast_chip_en864_21 <= 1'b0; fast_chip_en864_22 <= 1'b0; fast_chip_en864_23 <= 1'b0;
        end
        else
            begin
                fast_chip_en864_0  <= 1'b0; fast_chip_en864_1  <= 1'b0; fast_chip_en864_2  <= 1'b0;
                fast_chip_en864_3  <= 1'b0; fast_chip_en864_4  <= 1'b0; fast_chip_en864_5  <= 1'b0;
                fast_chip_en864_6  <= 1'b0; fast_chip_en864_7  <= 1'b0; fast_chip_en864_8  <= 1'b0;
                fast_chip_en864_9  <= 1'b0; fast_chip_en864_10 <= 1'b0; fast_chip_en864_11 <= 1'b0;
                fast_chip_en864_12 <= 1'b0; fast_chip_en864_13 <= 1'b0; fast_chip_en864_14 <= 1'b0;
                fast_chip_en864_15 <= 1'b0; fast_chip_en864_16 <= 1'b0; fast_chip_en864_17 <= 1'b0;
                fast_chip_en864_18 <= 1'b0; fast_chip_en864_19 <= 1'b0; fast_chip_en864_20 <= 1'b0;
                fast_chip_en864_21 <= 1'b0; fast_chip_en864_22 <= 1'b0; fast_chip_en864_23 <= 1'b0;
            end
        if (RD_CNT%2 == 0) begin
            case(RD_CNT/8)

                0:  fast_chip_en864_0  <= 1'b1; 1:  fast_chip_en864_1  <= 1'b1; 2:  fast_chip_en864_2  <= 1'b1;
                3:  fast_chip_en864_3  <= 1'b1; 4:  fast_chip_en864_4  <= 1'b1; 5:  fast_chip_en864_5  <= 1'b1;
                6:  fast_chip_en864_6  <= 1'b1; 7:  fast_chip_en864_7  <= 1'b1; 8:  fast_chip_en864_8  <= 1'b1;
                9:  fast_chip_en864_9  <= 1'b1; 10: fast_chip_en864_10 <= 1'b1; 11: fast_chip_en864_11 <= 1'b1;
                12: fast_chip_en864_12 <= 1'b1; 13: fast_chip_en864_13 <= 1'b1; 14: fast_chip_en864_14 <= 1'b1;
                15: fast_chip_en864_15 <= 1'b1; 16: fast_chip_en864_16 <= 1'b1; 17: fast_chip_en864_17 <= 1'b1;
                18: fast_chip_en864_18 <= 1'b1; 19: fast_chip_en864_19 <= 1'b1; 20: fast_chip_en864_20 <= 1'b1;
                21: fast_chip_en864_21 <= 1'b1; 22: fast_chip_en864_22 <= 1'b1; 23: fast_chip_en864_23 <= 1'b1;

                default: begin
                    fast_chip_en864_0  <= 1'b0; fast_chip_en864_1  <= 1'b0; fast_chip_en864_2  <= 1'b0;
                    fast_chip_en864_3  <= 1'b0; fast_chip_en864_4  <= 1'b0; fast_chip_en864_5  <= 1'b0;
                    fast_chip_en864_6  <= 1'b0; fast_chip_en864_7  <= 1'b0; fast_chip_en864_8  <= 1'b0;
                    fast_chip_en864_9  <= 1'b0; fast_chip_en864_10 <= 1'b0; fast_chip_en864_11 <= 1'b0;
                    fast_chip_en864_12 <= 1'b0; fast_chip_en864_13 <= 1'b0; fast_chip_en864_14 <= 1'b0;
                    fast_chip_en864_15 <= 1'b0; fast_chip_en864_16 <= 1'b0; fast_chip_en864_17 <= 1'b0;
                    fast_chip_en864_18 <= 1'b0; fast_chip_en864_19 <= 1'b0; fast_chip_en864_20 <= 1'b0;
                    fast_chip_en864_21 <= 1'b0; fast_chip_en864_22 <= 1'b0; fast_chip_en864_23 <= 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            fast_chip_en1728_0  <= 1'b0; fast_chip_en1728_1  <= 1'b0; fast_chip_en1728_2  <= 1'b0;
            fast_chip_en1728_3  <= 1'b0; fast_chip_en1728_4  <= 1'b0; fast_chip_en1728_5  <= 1'b0;
            fast_chip_en1728_6  <= 1'b0; fast_chip_en1728_7  <= 1'b0; fast_chip_en1728_8  <= 1'b0;
            fast_chip_en1728_9  <= 1'b0; fast_chip_en1728_10 <= 1'b0; fast_chip_en1728_11 <= 1'b0;
            fast_chip_en1728_12 <= 1'b0; fast_chip_en1728_13 <= 1'b0; fast_chip_en1728_14 <= 1'b0;
            fast_chip_en1728_15 <= 1'b0; fast_chip_en1728_16 <= 1'b0; fast_chip_en1728_17 <= 1'b0;
            fast_chip_en1728_18 <= 1'b0; fast_chip_en1728_19 <= 1'b0; fast_chip_en1728_20 <= 1'b0;
            fast_chip_en1728_21 <= 1'b0; fast_chip_en1728_22 <= 1'b0; fast_chip_en1728_23 <= 1'b0;
        end
        else
            begin
                fast_chip_en1728_0  <= 1'b0; fast_chip_en1728_1  <= 1'b0; fast_chip_en1728_2  <= 1'b0;
                fast_chip_en1728_3  <= 1'b0; fast_chip_en1728_4  <= 1'b0; fast_chip_en1728_5  <= 1'b0;
                fast_chip_en1728_6  <= 1'b0; fast_chip_en1728_7  <= 1'b0; fast_chip_en1728_8  <= 1'b0;
                fast_chip_en1728_9  <= 1'b0; fast_chip_en1728_10 <= 1'b0; fast_chip_en1728_11 <= 1'b0;
                fast_chip_en1728_12 <= 1'b0; fast_chip_en1728_13 <= 1'b0; fast_chip_en1728_14 <= 1'b0;
                fast_chip_en1728_15 <= 1'b0; fast_chip_en1728_16 <= 1'b0; fast_chip_en1728_17 <= 1'b0;
                fast_chip_en1728_18 <= 1'b0; fast_chip_en1728_19 <= 1'b0; fast_chip_en1728_20 <= 1'b0;
                fast_chip_en1728_21 <= 1'b0; fast_chip_en1728_22 <= 1'b0; fast_chip_en1728_23 <= 1'b0;
            end
        if (RD_CNT%2 == 0) begin
            case(RD_CNT/16)
                0:  fast_chip_en1728_0  <= 1'b1; 1:  fast_chip_en1728_1  <= 1'b1; 2:  fast_chip_en1728_2  <= 1'b1;
                3:  fast_chip_en1728_3  <= 1'b1; 4:  fast_chip_en1728_4  <= 1'b1; 5:  fast_chip_en1728_5  <= 1'b1;
                6:  fast_chip_en1728_6  <= 1'b1; 7:  fast_chip_en1728_7  <= 1'b1; 8:  fast_chip_en1728_8  <= 1'b1;
                9:  fast_chip_en1728_9  <= 1'b1; 10: fast_chip_en1728_10 <= 1'b1; 11: fast_chip_en1728_11 <= 1'b1;
                12: fast_chip_en1728_12 <= 1'b1; 13: fast_chip_en1728_13 <= 1'b1; 14: fast_chip_en1728_14 <= 1'b1;
                15: fast_chip_en1728_15 <= 1'b1; 16: fast_chip_en1728_16 <= 1'b1; 17: fast_chip_en1728_17 <= 1'b1;
                18: fast_chip_en1728_18 <= 1'b1; 19: fast_chip_en1728_19 <= 1'b1; 20: fast_chip_en1728_20 <= 1'b1;
                21: fast_chip_en1728_21 <= 1'b1; 22: fast_chip_en1728_22 <= 1'b1; 23: fast_chip_en1728_23 <= 1'b1;

                default: begin
                    fast_chip_en1728_0  <= 1'b0; fast_chip_en1728_1  <= 1'b0; fast_chip_en1728_2  <= 1'b0;
                    fast_chip_en1728_3  <= 1'b0; fast_chip_en1728_4  <= 1'b0; fast_chip_en1728_5  <= 1'b0;
                    fast_chip_en1728_6  <= 1'b0; fast_chip_en1728_7  <= 1'b0; fast_chip_en1728_8  <= 1'b0;
                    fast_chip_en1728_9  <= 1'b0; fast_chip_en1728_10 <= 1'b0; fast_chip_en1728_11 <= 1'b0;
                    fast_chip_en1728_12 <= 1'b0; fast_chip_en1728_13 <= 1'b0; fast_chip_en1728_14 <= 1'b0;
                    fast_chip_en1728_15 <= 1'b0; fast_chip_en1728_16 <= 1'b0; fast_chip_en1728_17 <= 1'b0;
                    fast_chip_en1728_18 <= 1'b0; fast_chip_en1728_19 <= 1'b0; fast_chip_en1728_20 <= 1'b0;
                    fast_chip_en1728_21 <= 1'b0; fast_chip_en1728_22 <= 1'b0; fast_chip_en1728_23 <= 1'b0;
                end
            endcase
        end
    end

    /* -----------------------------------------------------------------
     Gen fast_addr
     ----------------------------------------------------------------- */
    always @(*) begin
        fast_addr_0  = addr; fast_addr_1  = addr; fast_addr_2  = addr; fast_addr_3  = addr;
        fast_addr_4  = addr; fast_addr_5  = addr; fast_addr_6  = addr; fast_addr_7  = addr;
        fast_addr_8  = addr; fast_addr_9  = addr; fast_addr_10 = addr; fast_addr_11 = addr;
        fast_addr_12 = addr; fast_addr_13 = addr; fast_addr_14 = addr; fast_addr_15 = addr;
        fast_addr_16 = addr; fast_addr_17 = addr; fast_addr_18 = addr; fast_addr_19 = addr;
        fast_addr_20 = addr; fast_addr_21 = addr; fast_addr_22 = addr; fast_addr_23 = addr;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr <= 0;
            fast_rd_done <= 1'b0;
        end
        else begin
            case(curr_sta)
                READ_IDLE: begin
                    if (fast_read_en)
                        fast_rd_done <= 1'b0;
                end

                READ_216BYTE: begin
                    if (rf_96path_en) begin
                        if ((RD_CNT == 9'd47) && (RD == 1'b1)) begin
                            if (&addr) begin
                                addr <= 0;
                                fast_rd_done <= 1'b1;
                            end
                            else if (pkt_en) begin
                                addr <= addr + 1;
                            end
                        end
                    end
                    else begin
                        if ((RD_CNT == 9'd23) && (RD == 1'b1)) begin
                            if (&addr) begin
                                addr <= 0;
                                fast_rd_done <= 1'b1;
                            end
                            else if (pkt_en) begin
                                addr <= addr + 1;
                            end
                        end
                    end
                end

                READ_432BYTE: begin
                    if (&addr) begin
                        addr <= 0;
                        fast_rd_done <= 1'b1;
                    end
                    else if (pkt_en) begin
                        if (rf_96path_en) begin
                            if (RD_CNT == 9'd95)
                                addr <= addr + 1;
                        end
                        else begin
                            if (RD_CNT == 9'd47)
                                addr <= addr + 1;
                        end
                    end
                end

                READ_864BYTE: begin
                    if (&addr) begin
                        addr <= 0;
                        fast_rd_done <= 1'b1;
                    end
                    else if (pkt_en) begin
                        if (rf_96path_en) begin
                            if (RD_CNT == 9'd191)
                                addr <= addr + 1;
                        end
                        else begin
                            if (RD_CNT == 9'd95)
                                addr <= addr + 1;
                        end
                    end
                end

                READ_1728BYTE: begin
                    if (&addr) begin
                        addr <= 0;
                        fast_rd_done <= 1'b1;
                    end
                    else if (pkt_en) begin
                        if (rf_96path_en) begin
                            if (RD_CNT == 9'd383)
                                addr <= addr + 1;
                        end
                        else begin
                            if (RD_CNT == 9'd191)
                                addr <= addr + 1;
                        end
                    end
                end

                default: begin
                    addr <= 0;
                    fast_rd_done <= 1'b1;
                end
            endcase
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
        case(curr_sta)
            READ_IDLE: begin
                if (fast_read_en) begin
                    if (rf_pkt_data_length == 2'b00)
                        next_sta = READ_216BYTE;
                    else if (rf_pkt_data_length == 2'b01)
                        next_sta = READ_432BYTE;
                    else if (rf_pkt_data_length == 2'b10)
                        next_sta = READ_864BYTE;
                    else if (rf_pkt_data_length == 2'b11)
                        next_sta = READ_1728BYTE;
                end
            end

            READ_216BYTE: begin
                if ((fast_rd_done) && (RD == 1'b1))
                    next_sta = READ_IDLE;
            end

            READ_432BYTE: begin
                if ((fast_rd_done) && (RD == 1'b1))
                    next_sta = READ_IDLE;
            end

            READ_864BYTE: begin
                if ((fast_rd_done) && (RD == 1'b1))
                    next_sta = READ_IDLE;
            end

            READ_1728BYTE: begin
                if ((fast_rd_done) && (RD == 1'b1))
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
                pkt_en = 1'b0;
                if (fast_read_en) begin
                    if (idle_cnt == rf_pkt_idle_length)
                        pkt_next_sta = PKT_VALID;
                end
            end

            PKT_VALID: begin
                pkt_en = 1'b1;
                if (curr_sta == READ_216BYTE) begin
                    if (addr%2 == 1) begin
                        if (rf_96path_en) begin
                            if ((RD_CNT == 9'd47) && (RD == 1'b1))
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if ((RD_CNT == 9'd23) && (RD == 1'b1))
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
                else if (curr_sta == READ_432BYTE) begin
                    if (addr%4 == 1) begin
                        if (rf_96path_en) begin
                            if(RD_CNT == 9'd95)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if(RD_CNT == 9'd47)
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
                else if (curr_sta == READ_864BYTE) begin
                    if (addr%8 == 1) begin
                        if (rf_96path_en) begin
                            if(RD_CNT == 9'd191)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if(RD_CNT == 9'd95)
                                pkt_next_sta = PKT_IDLE;
                        end
                    end
                end
                else if (READ_1728BYTE) begin
                    if (addr%16 == 1) begin
                        if (rf_96path_en) begin
                            if(RD_CNT == 9'd383)
                                pkt_next_sta = PKT_IDLE;
                        end
                        else begin
                            if(RD_CNT == 9'd191)
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
        else if (idle_cnt == rf_pkt_idle_length)
            idle_cnt <= 0;
        else if (fast_read_en)
            if (DATA_RD_EN) 
                idle_cnt <= idle_cnt + 1;
    end

endmodule
