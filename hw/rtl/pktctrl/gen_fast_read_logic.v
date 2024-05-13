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
//  2024-05-06    zlguo         1.0         gen_fast_read_logic
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module gen_fast_read_logic
(
    // Mdio read
    input   wire                clk,
    input   wire                rstn,

    input   wire                fast_rd_en,
    input   wire    [96*9-1:0]  data_out,

    input   wire                rf_96path_en,
    input   wire    [1:0]       rf_pkt_data_length,
    input   wire    [1:0]       rf_pkt_idle_length,

    output  reg     [95:0]      fast_rd_chip_en,
    output  reg     [96*15-1:0] fast_rd_raddr,
    output  reg     [17:0]      fast_pkt_data,
    output  reg                 fast_pkt_data_valid,
    output  reg                 fast_rd_done
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

    wire    fast_rd_en_sync;
    jlsemi_util_sync_pos_with_rst_low
    u_sync_fast_rd_done
    (
    .clk        (clk                ),
    .rst_n      (rstn               ),
    .din        (fast_rd_en         ),
    .dout       (fast_rd_en_sync    )
    );

    always @(*) begin
        begin
            next_sta = curr_sta;
        end
        case(curr_sta)
            READ_IDLE: begin
                if (fast_rd_en_sync) begin
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

            end

            PKT_VALID: begin

            end

            default:next_sta = IDLE;
        endcase
    end

endmodule
