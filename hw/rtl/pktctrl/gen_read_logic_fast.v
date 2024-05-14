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
    input   wire    [1:0]   rf_pkt_idle_length,

    input   wire            fast_read_en,

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

    localparam          READ_IDLE       = 6'b00_0001,
                        READ_216BYTE    = 6'b00_0010,
                        READ_432BYTE    = 6'b00_0100,
                        READ_864BYTE    = 6'b00_1000,
                        READ_1728BYTE   = 6'b01_0000,
                        READ_DONE       = 6'b10_0000;

    reg     [5:0]       curr_sta;
    reg     [5:0]       next_sta;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            curr_sta <= IDLE;
        else
            curr_sta <= next_sta;
    end

    always @(*) begin
        begin
            next_sta = curr_sta;
        end
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

            end

            READ_432BYTE: begin

            end

            READ_864BYTE: begin

            end

            READ_1728BYTE: begin

            end

            READ_DONE: begin

            end

            default:next_sta = IDLE;
        endcase
    end

    localparam          PKT_IDLE    = 2'b01,
                        PKT_VALID   = 2'b10;

    reg     [1:0]       pkt_curr_sta;
    reg     [1:0]       pkt_next_sta;

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
                //rf_pkt_idle_length
            end

            PKT_VALID: begin

            end

            default:next_sta = IDLE;
        endcase
    end

endmodule
