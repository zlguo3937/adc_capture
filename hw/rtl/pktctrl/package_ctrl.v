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
//  2024-05-06    zlguo         1.0         package_ctrl
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module package_ctrl
(
    input   wire            pktctrl_clk,
    input   wire            pktctrl_rstn,

    input   wire            rf_capture_mode,
    input   wire            rf_capture_start,
    input   wire            rf_capture_again,

    input   wire            rf_96path_en,
    input   wire    [1:0]   rf_pkt_data_length,
    input   wire    [15:0]  rf_pkt_idle_length,
    input   wire    [8:0]   rf_pktctrl_gap,
    input   wire    [8:0]   rf_pktctrl_phase,

    input   wire    [35:0]  adc_data_0,
    input   wire    [35:0]  adc_data_1,
    input   wire    [35:0]  adc_data_2,
    input   wire    [35:0]  adc_data_3,
    input   wire    [35:0]  adc_data_4,
    input   wire    [35:0]  adc_data_5,
    input   wire    [35:0]  adc_data_6,
    input   wire    [35:0]  adc_data_7,
    input   wire    [35:0]  adc_data_8,
    input   wire    [35:0]  adc_data_9,
    input   wire    [35:0]  adc_data_10,
    input   wire    [35:0]  adc_data_11,
    input   wire    [35:0]  adc_data_12,
    input   wire    [35:0]  adc_data_13,
    input   wire    [35:0]  adc_data_14,
    input   wire    [35:0]  adc_data_15,
    input   wire    [35:0]  adc_data_16,
    input   wire    [35:0]  adc_data_17,
    input   wire    [35:0]  adc_data_18,
    input   wire    [35:0]  adc_data_19,
    input   wire    [35:0]  adc_data_20,
    input   wire    [35:0]  adc_data_21,
    input   wire    [35:0]  adc_data_22,
    input   wire    [35:0]  adc_data_23,

    // Mdio read
    input   wire    [6:0]   rf_mdio_data_sel,
    input   wire    [14:0]  rf_mdio_memory_addr,
    output  wire    [8:0]   rf_mdio_pkt_data,

    // Fast read
    output  reg             CLK_RD,
    output  wire    [17:0]  ADC_DATA,
    output  wire            ADC_DATA_VALID

);

    // FSM
    localparam      IDLE        = 5'b0_0001,
                    WRITE       = 5'b0_0010,
                    WRITE_DONE  = 5'b0_0100,
                    MDIO_READ   = 5'b0_1000,
                    FAST_READ   = 5'b1_0000;

    reg     [4:0]   curr_sta;
    reg     [4:0]   next_sta;

    // Memory interface
    reg             chip_en_0;
    reg             chip_en_1;
    reg             chip_en_2;
    reg             chip_en_3;
    reg             chip_en_4;
    reg             chip_en_5;
    reg             chip_en_6;
    reg             chip_en_7;
    reg             chip_en_8;
    reg             chip_en_9;
    reg             chip_en_10;
    reg             chip_en_11;
    reg             chip_en_12;
    reg             chip_en_13;
    reg             chip_en_14;
    reg             chip_en_15;
    reg             chip_en_16;
    reg             chip_en_17;
    reg             chip_en_18;
    reg             chip_en_19;
    reg             chip_en_20;
    reg             chip_en_21;
    reg             chip_en_22;
    reg             chip_en_23;

    reg             wr_en_0;
    reg             wr_en_1;
    reg             wr_en_2;
    reg             wr_en_3;
    reg             wr_en_4;
    reg             wr_en_5;
    reg             wr_en_6;
    reg             wr_en_7;
    reg             wr_en_8;
    reg             wr_en_9;
    reg             wr_en_10;
    reg             wr_en_11;
    reg             wr_en_12;
    reg             wr_en_13;
    reg             wr_en_14;
    reg             wr_en_15;
    reg             wr_en_16;
    reg             wr_en_17;
    reg             wr_en_18;
    reg             wr_en_19;
    reg             wr_en_20;
    reg             wr_en_21;
    reg             wr_en_22;
    reg             wr_en_23;

    reg    [14:0]   addr_0;
    reg    [14:0]   addr_1;
    reg    [14:0]   addr_2;
    reg    [14:0]   addr_3;
    reg    [14:0]   addr_4;
    reg    [14:0]   addr_5;
    reg    [14:0]   addr_6;
    reg    [14:0]   addr_7;
    reg    [14:0]   addr_8;
    reg    [14:0]   addr_9;
    reg    [14:0]   addr_10;
    reg    [14:0]   addr_11;
    reg    [14:0]   addr_12;
    reg    [14:0]   addr_13;
    reg    [14:0]   addr_14;
    reg    [14:0]   addr_15;
    reg    [14:0]   addr_16;
    reg    [14:0]   addr_17;
    reg    [14:0]   addr_18;
    reg    [14:0]   addr_19;
    reg    [14:0]   addr_20;
    reg    [14:0]   addr_21;
    reg    [14:0]   addr_22;
    reg    [14:0]   addr_23;

    wire    [35:0]  dout_0;
    wire    [35:0]  dout_1;
    wire    [35:0]  dout_2;
    wire    [35:0]  dout_3;
    wire    [35:0]  dout_4;
    wire    [35:0]  dout_5;
    wire    [35:0]  dout_6;
    wire    [35:0]  dout_7;
    wire    [35:0]  dout_8;
    wire    [35:0]  dout_9;
    wire    [35:0]  dout_10;
    wire    [35:0]  dout_11;
    wire    [35:0]  dout_12;
    wire    [35:0]  dout_13;
    wire    [35:0]  dout_14;
    wire    [35:0]  dout_15;
    wire    [35:0]  dout_16;
    wire    [35:0]  dout_17;
    wire    [35:0]  dout_18;
    wire    [35:0]  dout_19;
    wire    [35:0]  dout_20;
    wire    [35:0]  dout_21;
    wire    [35:0]  dout_22;
    wire    [35:0]  dout_23;

    // Write if
    reg                 write_en;
    wire    [14:0]      waddr;
    wire                wr_done;

    // Fast read if
    reg                 fast_read_en;

    wire                fast_chip_en_0;
    wire                fast_chip_en_1;
    wire                fast_chip_en_2;
    wire                fast_chip_en_3;
    wire                fast_chip_en_4;
    wire                fast_chip_en_5;
    wire                fast_chip_en_6;
    wire                fast_chip_en_7;
    wire                fast_chip_en_8;
    wire                fast_chip_en_9;
    wire                fast_chip_en_10;
    wire                fast_chip_en_11;
    wire                fast_chip_en_12;
    wire                fast_chip_en_13;
    wire                fast_chip_en_14;
    wire                fast_chip_en_15;
    wire                fast_chip_en_16;
    wire                fast_chip_en_17;
    wire                fast_chip_en_18;
    wire                fast_chip_en_19;
    wire                fast_chip_en_20;
    wire                fast_chip_en_21;
    wire                fast_chip_en_22;
    wire                fast_chip_en_23;

    wire    [14:0]      fast_addr;

    wire                fast_rd_done;

    // Mdio read if
    reg                 mdio_read_en;

    wire                mdio_chip_en_0;
    wire                mdio_chip_en_1;
    wire                mdio_chip_en_2;
    wire                mdio_chip_en_3;
    wire                mdio_chip_en_4;
    wire                mdio_chip_en_5;
    wire                mdio_chip_en_6;
    wire                mdio_chip_en_7;
    wire                mdio_chip_en_8;
    wire                mdio_chip_en_9;
    wire                mdio_chip_en_10;
    wire                mdio_chip_en_11;
    wire                mdio_chip_en_12;
    wire                mdio_chip_en_13;
    wire                mdio_chip_en_14;
    wire                mdio_chip_en_15;
    wire                mdio_chip_en_16;
    wire                mdio_chip_en_17;
    wire                mdio_chip_en_18;
    wire                mdio_chip_en_19;
    wire                mdio_chip_en_20;
    wire                mdio_chip_en_21;
    wire                mdio_chip_en_22;
    wire                mdio_chip_en_23;

    wire    [14:0]      mdio_addr_0;
    wire    [14:0]      mdio_addr_1;
    wire    [14:0]      mdio_addr_2;
    wire    [14:0]      mdio_addr_3;
    wire    [14:0]      mdio_addr_4;
    wire    [14:0]      mdio_addr_5;
    wire    [14:0]      mdio_addr_6;
    wire    [14:0]      mdio_addr_7;
    wire    [14:0]      mdio_addr_8;
    wire    [14:0]      mdio_addr_9;
    wire    [14:0]      mdio_addr_10;
    wire    [14:0]      mdio_addr_11;
    wire    [14:0]      mdio_addr_12;
    wire    [14:0]      mdio_addr_13;
    wire    [14:0]      mdio_addr_14;
    wire    [14:0]      mdio_addr_15;
    wire    [14:0]      mdio_addr_16;
    wire    [14:0]      mdio_addr_17;
    wire    [14:0]      mdio_addr_18;
    wire    [14:0]      mdio_addr_19;
    wire    [14:0]      mdio_addr_20;
    wire    [14:0]      mdio_addr_21;
    wire    [14:0]      mdio_addr_22;
    wire    [14:0]      mdio_addr_23;

    wire                mdio_rd_done;

    reg                 DATA_RD_EN;
    reg     [7:0]       cnt;
    
    always @(posedge pktctrl_clk or negedge pktctrl_rstn)
    begin
        if(~pktctrl_rstn)
            cnt <= 0;
        else if (fast_read_en) begin
            if (cnt < ((rf_pktctrl_gap/2)-1))
                cnt <= cnt + 1'b1;
            else
                cnt <= 0;
        end
        else
            cnt <= 0;
    end

    always @(posedge pktctrl_clk or negedge pktctrl_rstn)
    begin
        if(~pktctrl_rstn)
            CLK_RD <= 1'b0;
        else if (cnt == rf_pktctrl_phase)
            CLK_RD <= ~CLK_RD;
    end

    always @(posedge pktctrl_clk or negedge pktctrl_rstn)
    begin
        if(~pktctrl_rstn)
            DATA_RD_EN <= 1'b0;
        else if (cnt == ((rf_pktctrl_gap/2)-1))
            DATA_RD_EN <= ~DATA_RD_EN;
        else
            DATA_RD_EN <= 1'b0;
    end

    /* -----------------------------------------------------------------
     Main FSM logic
     ----------------------------------------------------------------- */
    always @(posedge pktctrl_clk or negedge pktctrl_rstn) begin
        if (!pktctrl_rstn)
            curr_sta <= IDLE;
        else
            curr_sta <= next_sta;
    end

    always @(*) begin
        begin
            next_sta = curr_sta;
            write_en = 1'b0;
            mdio_read_en = 1'b0;
            fast_read_en = 1'b0;
        end
        case(curr_sta)
            IDLE: begin
                if (rf_capture_start)
                    next_sta = WRITE;
                else if (rf_capture_again)
                    next_sta = WRITE_DONE;
            end

            WRITE: begin
                write_en = 1'b1;
                if (wr_done) begin
                    next_sta = WRITE_DONE;
                    write_en = 1'b0;
                end
            end

            WRITE_DONE: begin
                if (!rf_capture_mode)
                    next_sta = FAST_READ;
                else
                    next_sta = MDIO_READ;
            end

            MDIO_READ: begin
                mdio_read_en = 1'b1;
                if (rf_capture_start) begin
                    next_sta     = WRITE;
                    mdio_read_en = 1'b0;
                end 
                else if (!rf_capture_mode) begin
                    next_sta = FAST_READ;
                    mdio_read_en = 1'b0;
                end
                else if (mdio_rd_done) begin
                    next_sta = IDLE;
                    mdio_read_en = 1'b0;
                end
            end

            FAST_READ: begin
                fast_read_en = 1'b1;
                if (rf_capture_mode) begin
                    next_sta = MDIO_READ;
                    mdio_read_en = 1'b0;
                end
                else if (fast_rd_done) begin
                    next_sta = IDLE;
                    fast_read_en = 1'b0;
                end
            end

            default:next_sta = IDLE;
        endcase
    end

    /* -----------------------------------------------------------------
     Memory interface
     ----------------------------------------------------------------- */
    always @(posedge pktctrl_clk or negedge pktctrl_rstn) begin
        if (!pktctrl_rstn) begin
            chip_en_0  <= 1'b0; chip_en_1  <= 1'b0; chip_en_2  <= 1'b0; chip_en_3  <= 1'b0; chip_en_4  <= 1'b0; chip_en_5  <= 1'b0;
            chip_en_6  <= 1'b0; chip_en_7  <= 1'b0; chip_en_8  <= 1'b0; chip_en_9  <= 1'b0; chip_en_10 <= 1'b0; chip_en_11 <= 1'b0;
            chip_en_12 <= 1'b0; chip_en_13 <= 1'b0; chip_en_14 <= 1'b0; chip_en_15 <= 1'b0; chip_en_16 <= 1'b0; chip_en_17 <= 1'b0;
            chip_en_18 <= 1'b0; chip_en_19 <= 1'b0; chip_en_20 <= 1'b0; chip_en_21 <= 1'b0; chip_en_22 <= 1'b0; chip_en_23 <= 1'b0;
        end
        else if (rf_96path_en) begin
            if (write_en) begin
                chip_en_0  <= 1'b1; chip_en_1  <= 1'b1; chip_en_2  <= 1'b1; chip_en_3  <= 1'b1; chip_en_4  <= 1'b1; chip_en_5  <= 1'b1;
                chip_en_6  <= 1'b1; chip_en_7  <= 1'b1; chip_en_8  <= 1'b1; chip_en_9  <= 1'b1; chip_en_10 <= 1'b1; chip_en_11 <= 1'b1;
                chip_en_12 <= 1'b1; chip_en_13 <= 1'b1; chip_en_14 <= 1'b1; chip_en_15 <= 1'b1; chip_en_16 <= 1'b1; chip_en_17 <= 1'b1;
                chip_en_18 <= 1'b1; chip_en_19 <= 1'b1; chip_en_20 <= 1'b1; chip_en_21 <= 1'b1; chip_en_22 <= 1'b1; chip_en_23 <= 1'b1;
            end
            else if (mdio_read_en) begin
                chip_en_0  <= mdio_chip_en_0 ; chip_en_1  <= mdio_chip_en_1 ; chip_en_2  <= mdio_chip_en_2 ; chip_en_3  <= mdio_chip_en_3 ;
                chip_en_4  <= mdio_chip_en_4 ; chip_en_5  <= mdio_chip_en_5 ; chip_en_6  <= mdio_chip_en_6 ; chip_en_7  <= mdio_chip_en_7 ;
                chip_en_8  <= mdio_chip_en_8 ; chip_en_9  <= mdio_chip_en_9 ; chip_en_10 <= mdio_chip_en_10; chip_en_11 <= mdio_chip_en_11;
                chip_en_12 <= mdio_chip_en_12; chip_en_13 <= mdio_chip_en_13; chip_en_14 <= mdio_chip_en_14; chip_en_15 <= mdio_chip_en_15;
                chip_en_16 <= mdio_chip_en_16; chip_en_17 <= mdio_chip_en_17; chip_en_18 <= mdio_chip_en_18; chip_en_19 <= mdio_chip_en_19;
                chip_en_20 <= mdio_chip_en_20; chip_en_21 <= mdio_chip_en_21; chip_en_22 <= mdio_chip_en_22; chip_en_23 <= mdio_chip_en_23;
            end
            else if (fast_read_en) begin
                chip_en_0  <= fast_chip_en_0 ; chip_en_1  <= fast_chip_en_1 ; chip_en_2  <= fast_chip_en_2 ; chip_en_3  <= fast_chip_en_3 ;
                chip_en_4  <= fast_chip_en_4 ; chip_en_5  <= fast_chip_en_5 ; chip_en_6  <= fast_chip_en_6 ; chip_en_7  <= fast_chip_en_7 ;
                chip_en_8  <= fast_chip_en_8 ; chip_en_9  <= fast_chip_en_9 ; chip_en_10 <= fast_chip_en_10; chip_en_11 <= fast_chip_en_11;
                chip_en_12 <= fast_chip_en_12; chip_en_13 <= fast_chip_en_13; chip_en_14 <= fast_chip_en_14; chip_en_15 <= fast_chip_en_15;
                chip_en_16 <= fast_chip_en_16; chip_en_17 <= fast_chip_en_17; chip_en_18 <= fast_chip_en_18; chip_en_19 <= fast_chip_en_19;
                chip_en_20 <= fast_chip_en_20; chip_en_21 <= fast_chip_en_21; chip_en_22 <= fast_chip_en_22; chip_en_23 <= fast_chip_en_23;
            end
            else begin
                chip_en_0  <= 1'b0; chip_en_1  <= 1'b0; chip_en_2  <= 1'b0; chip_en_3  <= 1'b0; chip_en_4  <= 1'b0; chip_en_5  <= 1'b0;
                chip_en_6  <= 1'b0; chip_en_7  <= 1'b0; chip_en_8  <= 1'b0; chip_en_9  <= 1'b0; chip_en_10 <= 1'b0; chip_en_11 <= 1'b0;
                chip_en_12 <= 1'b0; chip_en_13 <= 1'b0; chip_en_14 <= 1'b0; chip_en_15 <= 1'b0; chip_en_16 <= 1'b0; chip_en_17 <= 1'b0;
                chip_en_18 <= 1'b0; chip_en_19 <= 1'b0; chip_en_20 <= 1'b0; chip_en_21 <= 1'b0; chip_en_22 <= 1'b0; chip_en_23 <= 1'b0;
            end
        end
        else begin
            chip_en_12 <= 1'b0; chip_en_13 <= 1'b0; chip_en_14 <= 1'b0; chip_en_15 <= 1'b0; chip_en_16 <= 1'b0; chip_en_17 <= 1'b0;
            chip_en_18 <= 1'b0; chip_en_19 <= 1'b0; chip_en_20 <= 1'b0; chip_en_21 <= 1'b0; chip_en_22 <= 1'b0; chip_en_23 <= 1'b0;

            if (write_en) begin
                chip_en_0  <= 1'b1; chip_en_1  <= 1'b1; chip_en_2  <= 1'b1; chip_en_3  <= 1'b1; chip_en_4  <= 1'b1; chip_en_5  <= 1'b1;
                chip_en_6  <= 1'b1; chip_en_7  <= 1'b1; chip_en_8  <= 1'b1; chip_en_9  <= 1'b1; chip_en_10 <= 1'b1; chip_en_11 <= 1'b1;
                
            end
            else if (mdio_read_en) begin
                chip_en_0  <= mdio_chip_en_0; chip_en_1  <= mdio_chip_en_1; chip_en_2  <= mdio_chip_en_2 ; chip_en_3  <= mdio_chip_en_3 ;
                chip_en_4  <= mdio_chip_en_4; chip_en_5  <= mdio_chip_en_5; chip_en_6  <= mdio_chip_en_6 ; chip_en_7  <= mdio_chip_en_7 ;
                chip_en_8  <= mdio_chip_en_8; chip_en_9  <= mdio_chip_en_9; chip_en_10 <= mdio_chip_en_10; chip_en_11 <= mdio_chip_en_11;
            end
            else if (fast_read_en) begin
                chip_en_0  <= fast_chip_en_0; chip_en_1  <= fast_chip_en_1; chip_en_2  <= fast_chip_en_2 ; chip_en_3  <= fast_chip_en_3 ;
                chip_en_4  <= fast_chip_en_4; chip_en_5  <= fast_chip_en_5; chip_en_6  <= fast_chip_en_6 ; chip_en_7  <= fast_chip_en_7 ;
                chip_en_8  <= fast_chip_en_8; chip_en_9  <= fast_chip_en_9; chip_en_10 <= fast_chip_en_10; chip_en_11 <= fast_chip_en_11;
            end
            else begin
                chip_en_0  <= 1'b0; chip_en_1  <= 1'b0; chip_en_2  <= 1'b0; chip_en_3  <= 1'b0; chip_en_4  <= 1'b0; chip_en_5  <= 1'b0;
                chip_en_6  <= 1'b0; chip_en_7  <= 1'b0; chip_en_8  <= 1'b0; chip_en_9  <= 1'b0; chip_en_10 <= 1'b0; chip_en_11 <= 1'b0;
            end
        end
    end

    always @(posedge pktctrl_clk or negedge pktctrl_rstn) begin
        if (!pktctrl_rstn) begin
            wr_en_0  <= 1'b0; wr_en_1  <= 1'b0; wr_en_2  <= 1'b0; wr_en_3  <= 1'b0; wr_en_4  <= 1'b0; wr_en_5  <= 1'b0;
            wr_en_6  <= 1'b0; wr_en_7  <= 1'b0; wr_en_8  <= 1'b0; wr_en_9  <= 1'b0; wr_en_10 <= 1'b0; wr_en_11 <= 1'b0;
            wr_en_12 <= 1'b0; wr_en_13 <= 1'b0; wr_en_14 <= 1'b0; wr_en_15 <= 1'b0; wr_en_16 <= 1'b0; wr_en_17 <= 1'b0;
            wr_en_18 <= 1'b0; wr_en_19 <= 1'b0; wr_en_20 <= 1'b0; wr_en_21 <= 1'b0; wr_en_22 <= 1'b0; wr_en_23 <= 1'b0;
        end
        else if (rf_96path_en) begin
            if (write_en) begin
                wr_en_0  <= 1'b1; wr_en_1  <= 1'b1; wr_en_2  <= 1'b1; wr_en_3  <= 1'b1; wr_en_4  <= 1'b1; wr_en_5  <= 1'b1;
                wr_en_6  <= 1'b1; wr_en_7  <= 1'b1; wr_en_8  <= 1'b1; wr_en_9  <= 1'b1; wr_en_10 <= 1'b1; wr_en_11 <= 1'b1;
                wr_en_12 <= 1'b1; wr_en_13 <= 1'b1; wr_en_14 <= 1'b1; wr_en_15 <= 1'b1; wr_en_16 <= 1'b1; wr_en_17 <= 1'b1;
                wr_en_18 <= 1'b1; wr_en_19 <= 1'b1; wr_en_20 <= 1'b1; wr_en_21 <= 1'b1; wr_en_22 <= 1'b1; wr_en_23 <= 1'b1;
            end
            else begin
                wr_en_0  <= 1'b0; wr_en_1  <= 1'b0; wr_en_2  <= 1'b0; wr_en_3  <= 1'b0; wr_en_4  <= 1'b0; wr_en_5  <= 1'b0;
                wr_en_6  <= 1'b0; wr_en_7  <= 1'b0; wr_en_8  <= 1'b0; wr_en_9  <= 1'b0; wr_en_10 <= 1'b0; wr_en_11 <= 1'b0;
                wr_en_12 <= 1'b0; wr_en_13 <= 1'b0; wr_en_14 <= 1'b0; wr_en_15 <= 1'b0; wr_en_16 <= 1'b0; wr_en_17 <= 1'b0;
                wr_en_18 <= 1'b0; wr_en_19 <= 1'b0; wr_en_20 <= 1'b0; wr_en_21 <= 1'b0; wr_en_22 <= 1'b0; wr_en_23 <= 1'b0;
            end
        end
        else begin
            wr_en_12 <= 1'b0; wr_en_13 <= 1'b0; wr_en_14 <= 1'b0; wr_en_15 <= 1'b0; wr_en_16 <= 1'b0; wr_en_17 <= 1'b0;
            wr_en_18 <= 1'b0; wr_en_19 <= 1'b0; wr_en_20 <= 1'b0; wr_en_21 <= 1'b0; wr_en_22 <= 1'b0; wr_en_23 <= 1'b0;

            if (write_en) begin
                wr_en_0  <= 1'b1; wr_en_1  <= 1'b1; wr_en_2  <= 1'b1; wr_en_3  <= 1'b1; wr_en_4  <= 1'b1; wr_en_5  <= 1'b1;
                wr_en_6  <= 1'b1; wr_en_7  <= 1'b1; wr_en_8  <= 1'b1; wr_en_9  <= 1'b1; wr_en_10 <= 1'b1; wr_en_11 <= 1'b1;
            end
            else begin
                wr_en_0  <= 1'b0; wr_en_1  <= 1'b0; wr_en_2  <= 1'b0; wr_en_3  <= 1'b0; wr_en_4  <= 1'b0; wr_en_5  <= 1'b0;
                wr_en_6  <= 1'b0; wr_en_7  <= 1'b0; wr_en_8  <= 1'b0; wr_en_9  <= 1'b0; wr_en_10 <= 1'b0; wr_en_11 <= 1'b0;
            end
        end
    end

    always @(posedge pktctrl_clk or negedge pktctrl_rstn) begin
        if (!pktctrl_rstn) begin
            addr_0  <= 15'h0; addr_1  <= 15'h0; addr_2  <= 15'h0; addr_3  <= 15'h0; addr_4  <= 15'h0; addr_5  <= 15'h0;
            addr_6  <= 15'h0; addr_7  <= 15'h0; addr_8  <= 15'h0; addr_9  <= 15'h0; addr_10 <= 15'h0; addr_11 <= 15'h0;
            addr_12 <= 15'h0; addr_13 <= 15'h0; addr_14 <= 15'h0; addr_15 <= 15'h0; addr_16 <= 15'h0; addr_17 <= 15'h0;
            addr_18 <= 15'h0; addr_19 <= 15'h0; addr_20 <= 15'h0; addr_21 <= 15'h0; addr_22 <= 15'h0; addr_23 <= 15'h0;
        end
        else if (rf_96path_en) begin
            if (write_en) begin
                addr_0  <= waddr; addr_1  <= waddr; addr_2  <= waddr; addr_3  <= waddr; addr_4  <= waddr; addr_5  <= waddr;
                addr_6  <= waddr; addr_7  <= waddr; addr_8  <= waddr; addr_9  <= waddr; addr_10 <= waddr; addr_11 <= waddr;
                addr_12 <= waddr; addr_13 <= waddr; addr_14 <= waddr; addr_15 <= waddr; addr_16 <= waddr; addr_17 <= waddr;
                addr_18 <= waddr; addr_19 <= waddr; addr_20 <= waddr; addr_21 <= waddr; addr_22 <= waddr; addr_23 <= waddr;
            end
            else if (mdio_read_en) begin
                addr_0  <= mdio_addr_0 ; addr_1  <= mdio_addr_1 ; addr_2  <= mdio_addr_2 ; addr_3  <= mdio_addr_3 ; addr_4  <= mdio_addr_4 ; addr_5  <= mdio_addr_5 ;
                addr_6  <= mdio_addr_6 ; addr_7  <= mdio_addr_7 ; addr_8  <= mdio_addr_8 ; addr_9  <= mdio_addr_9 ; addr_10 <= mdio_addr_10; addr_11 <= mdio_addr_11;
                addr_12 <= mdio_addr_12; addr_13 <= mdio_addr_13; addr_14 <= mdio_addr_14; addr_15 <= mdio_addr_15; addr_16 <= mdio_addr_16; addr_17 <= mdio_addr_17;
                addr_18 <= mdio_addr_18; addr_19 <= mdio_addr_19; addr_20 <= mdio_addr_20; addr_21 <= mdio_addr_21; addr_22 <= mdio_addr_22; addr_23 <= mdio_addr_23;
            end
            else if (fast_read_en) begin
                addr_0  <= fast_addr; addr_1  <= fast_addr; addr_2  <= fast_addr; addr_3  <= fast_addr; addr_4  <= fast_addr; addr_5  <= fast_addr;
                addr_6  <= fast_addr; addr_7  <= fast_addr; addr_8  <= fast_addr; addr_9  <= fast_addr; addr_10 <= fast_addr; addr_11 <= fast_addr;
                addr_12 <= fast_addr; addr_13 <= fast_addr; addr_14 <= fast_addr; addr_15 <= fast_addr; addr_16 <= fast_addr; addr_17 <= fast_addr;
                addr_18 <= fast_addr; addr_19 <= fast_addr; addr_20 <= fast_addr; addr_21 <= fast_addr; addr_22 <= fast_addr; addr_23 <= fast_addr;
            end
            else begin
                addr_0  <= 15'h0; addr_1  <= 15'h0; addr_2  <= 15'h0; addr_3  <= 15'h0; addr_4  <= 15'h0; addr_5  <= 15'h0;
                addr_6  <= 15'h0; addr_7  <= 15'h0; addr_8  <= 15'h0; addr_9  <= 15'h0; addr_10 <= 15'h0; addr_11 <= 15'h0;
                addr_12 <= 15'h0; addr_13 <= 15'h0; addr_14 <= 15'h0; addr_15 <= 15'h0; addr_16 <= 15'h0; addr_17 <= 15'h0;
                addr_18 <= 15'h0; addr_19 <= 15'h0; addr_20 <= 15'h0; addr_21 <= 15'h0; addr_22 <= 15'h0; addr_23 <= 15'h0;
            end
        end
        else begin
            addr_12 <= 15'h0; addr_13 <= 15'h0; addr_14 <= 15'h0; addr_15 <= 15'h0; addr_16 <= 15'h0; addr_17 <= 15'h0;
            addr_18 <= 15'h0; addr_19 <= 15'h0; addr_20 <= 15'h0; addr_21 <= 15'h0; addr_22 <= 15'h0; addr_23 <= 15'h0;

            if (write_en) begin
                addr_0 <= waddr; addr_1  <= waddr; addr_2  <= waddr; addr_3  <= waddr; addr_4  <= waddr; addr_5  <= waddr;
                addr_6 <= waddr; addr_7  <= waddr; addr_8  <= waddr; addr_9  <= waddr; addr_10 <= waddr; addr_11 <= waddr;
                
            end
            else if (mdio_read_en) begin
                addr_0 <= mdio_addr_0; addr_1 <= mdio_addr_1; addr_2 <= mdio_addr_2; addr_3 <= mdio_addr_3; addr_4  <= mdio_addr_4 ; addr_5  <= mdio_addr_5 ;
                addr_6 <= mdio_addr_6; addr_7 <= mdio_addr_7; addr_8 <= mdio_addr_8; addr_9 <= mdio_addr_9; addr_10 <= mdio_addr_10; addr_11 <= mdio_addr_11;
            end
            else if (fast_read_en) begin
                addr_0 <= fast_addr; addr_1 <= fast_addr; addr_2 <= fast_addr; addr_3 <= fast_addr; addr_4  <= fast_addr; addr_5  <= fast_addr;
                addr_6 <= fast_addr; addr_7 <= fast_addr; addr_8 <= fast_addr; addr_9 <= fast_addr; addr_10 <= fast_addr; addr_11 <= fast_addr;
            end
            else begin
                addr_0 <= 15'h0; addr_1 <= 15'h0; addr_2 <= 15'h0; addr_3 <= 15'h0; addr_4  <= 15'h0; addr_5  <= 15'h0;
                addr_6 <= 15'h0; addr_7 <= 15'h0; addr_8 <= 15'h0; addr_9 <= 15'h0; addr_10 <= 15'h0; addr_11 <= 15'h0;
            end
        end
    end

    /* -----------------------------------------------------------------
     Write Logic
     ----------------------------------------------------------------- */
    gen_write_logic
    u_gen_write_logic
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .rf_capture_start           (rf_capture_start           ),
    .write_en                   (write_en                   ),
    .waddr                      (waddr                      ),
    .wr_done                    (wr_done                    )
    );

    /* -----------------------------------------------------------------
     Mdio Read Logic
     ----------------------------------------------------------------- */
    gen_read_logic_mdio
    u_gen_read_logic_mdio
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_mdio_data_sel           (rf_mdio_data_sel           ),
    .rf_mdio_memory_addr        (rf_mdio_memory_addr        ),
    .mdio_read_en               (mdio_read_en               ),
    .mdio_din_0                 (dout_0                     ),
    .mdio_din_1                 (dout_1                     ),
    .mdio_din_2                 (dout_2                     ),
    .mdio_din_3                 (dout_3                     ),
    .mdio_din_4                 (dout_4                     ),
    .mdio_din_5                 (dout_5                     ),
    .mdio_din_6                 (dout_6                     ),
    .mdio_din_7                 (dout_7                     ),
    .mdio_din_8                 (dout_8                     ),
    .mdio_din_9                 (dout_9                     ),
    .mdio_din_10                (dout_10                    ),
    .mdio_din_11                (dout_11                    ),
    .mdio_din_12                (dout_12                    ),
    .mdio_din_13                (dout_13                    ),
    .mdio_din_14                (dout_14                    ),
    .mdio_din_15                (dout_15                    ),
    .mdio_din_16                (dout_16                    ),
    .mdio_din_17                (dout_17                    ),
    .mdio_din_18                (dout_18                    ),
    .mdio_din_19                (dout_19                    ),
    .mdio_din_20                (dout_20                    ),
    .mdio_din_21                (dout_21                    ),
    .mdio_din_22                (dout_22                    ),
    .mdio_din_23                (dout_23                    ),
    .mdio_chip_en_0             (mdio_chip_en_0             ),
    .mdio_chip_en_1             (mdio_chip_en_1             ),
    .mdio_chip_en_2             (mdio_chip_en_2             ),
    .mdio_chip_en_3             (mdio_chip_en_3             ),
    .mdio_chip_en_4             (mdio_chip_en_4             ),
    .mdio_chip_en_5             (mdio_chip_en_5             ),
    .mdio_chip_en_6             (mdio_chip_en_6             ),
    .mdio_chip_en_7             (mdio_chip_en_7             ),
    .mdio_chip_en_8             (mdio_chip_en_8             ),
    .mdio_chip_en_9             (mdio_chip_en_9             ),
    .mdio_chip_en_10            (mdio_chip_en_10            ),
    .mdio_chip_en_11            (mdio_chip_en_11            ),
    .mdio_chip_en_12            (mdio_chip_en_12            ),
    .mdio_chip_en_13            (mdio_chip_en_13            ),
    .mdio_chip_en_14            (mdio_chip_en_14            ),
    .mdio_chip_en_15            (mdio_chip_en_15            ),
    .mdio_chip_en_16            (mdio_chip_en_16            ),
    .mdio_chip_en_17            (mdio_chip_en_17            ),
    .mdio_chip_en_18            (mdio_chip_en_18            ),
    .mdio_chip_en_19            (mdio_chip_en_19            ),
    .mdio_chip_en_20            (mdio_chip_en_20            ),
    .mdio_chip_en_21            (mdio_chip_en_21            ),
    .mdio_chip_en_22            (mdio_chip_en_22            ),
    .mdio_chip_en_23            (mdio_chip_en_23            ),
    .mdio_addr_0                (mdio_addr_0                ),
    .mdio_addr_1                (mdio_addr_1                ),
    .mdio_addr_2                (mdio_addr_2                ),
    .mdio_addr_3                (mdio_addr_3                ),
    .mdio_addr_4                (mdio_addr_4                ),
    .mdio_addr_5                (mdio_addr_5                ),
    .mdio_addr_6                (mdio_addr_6                ),
    .mdio_addr_7                (mdio_addr_7                ),
    .mdio_addr_8                (mdio_addr_8                ),
    .mdio_addr_9                (mdio_addr_9                ),
    .mdio_addr_10               (mdio_addr_10               ),
    .mdio_addr_11               (mdio_addr_11               ),
    .mdio_addr_12               (mdio_addr_12               ),
    .mdio_addr_13               (mdio_addr_13               ),
    .mdio_addr_14               (mdio_addr_14               ),
    .mdio_addr_15               (mdio_addr_15               ),
    .mdio_addr_16               (mdio_addr_16               ),
    .mdio_addr_17               (mdio_addr_17               ),
    .mdio_addr_18               (mdio_addr_18               ),
    .mdio_addr_19               (mdio_addr_19               ),
    .mdio_addr_20               (mdio_addr_20               ),
    .mdio_addr_21               (mdio_addr_21               ),
    .mdio_addr_22               (mdio_addr_22               ),
    .mdio_addr_23               (mdio_addr_23               ),
    .mdio_rd_done               (mdio_rd_done               ),
    .rf_mdio_pkt_data           (rf_mdio_pkt_data           )
    );

    /* -----------------------------------------------------------------
     Fast Read Logic
     ----------------------------------------------------------------- */
    gen_read_logic_fast
    u_gen_read_logic_fast
    (
    .clk                        (pktctrl_clk                ),
    .rstn                       (pktctrl_rstn               ),
    .rf_capture_start           (rf_capture_start           ),
    .rf_capture_again           (rf_capture_again           ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_pkt_data_length         (rf_pkt_data_length         ),
    .rf_pkt_idle_length         (rf_pkt_idle_length         ),
    .DATA_RD_EN                 (DATA_RD_EN                 ),
    .fast_read_en               (fast_read_en               ),
    .fast_din_0                 (dout_0                     ),
    .fast_din_1                 (dout_1                     ),
    .fast_din_2                 (dout_2                     ),
    .fast_din_3                 (dout_3                     ),
    .fast_din_4                 (dout_4                     ),
    .fast_din_5                 (dout_5                     ),
    .fast_din_6                 (dout_6                     ),
    .fast_din_7                 (dout_7                     ),
    .fast_din_8                 (dout_8                     ),
    .fast_din_9                 (dout_9                     ),
    .fast_din_10                (dout_10                    ),
    .fast_din_11                (dout_11                    ),
    .fast_din_12                (dout_12                    ),
    .fast_din_13                (dout_13                    ),
    .fast_din_14                (dout_14                    ),
    .fast_din_15                (dout_15                    ),
    .fast_din_16                (dout_16                    ),
    .fast_din_17                (dout_17                    ),
    .fast_din_18                (dout_18                    ),
    .fast_din_19                (dout_19                    ),
    .fast_din_20                (dout_20                    ),
    .fast_din_21                (dout_21                    ),
    .fast_din_22                (dout_22                    ),
    .fast_din_23                (dout_23                    ),
    .fast_chip_en_0             (fast_chip_en_0             ),
    .fast_chip_en_1             (fast_chip_en_1             ),
    .fast_chip_en_2             (fast_chip_en_2             ),
    .fast_chip_en_3             (fast_chip_en_3             ),
    .fast_chip_en_4             (fast_chip_en_4             ),
    .fast_chip_en_5             (fast_chip_en_5             ),
    .fast_chip_en_6             (fast_chip_en_6             ),
    .fast_chip_en_7             (fast_chip_en_7             ),
    .fast_chip_en_8             (fast_chip_en_8             ),
    .fast_chip_en_9             (fast_chip_en_9             ),
    .fast_chip_en_10            (fast_chip_en_10            ),
    .fast_chip_en_11            (fast_chip_en_11            ),
    .fast_chip_en_12            (fast_chip_en_12            ),
    .fast_chip_en_13            (fast_chip_en_13            ),
    .fast_chip_en_14            (fast_chip_en_14            ),
    .fast_chip_en_15            (fast_chip_en_15            ),
    .fast_chip_en_16            (fast_chip_en_16            ),
    .fast_chip_en_17            (fast_chip_en_17            ),
    .fast_chip_en_18            (fast_chip_en_18            ),
    .fast_chip_en_19            (fast_chip_en_19            ),
    .fast_chip_en_20            (fast_chip_en_20            ),
    .fast_chip_en_21            (fast_chip_en_21            ),
    .fast_chip_en_22            (fast_chip_en_22            ),
    .fast_chip_en_23            (fast_chip_en_23            ),
    .fast_addr                  (fast_addr                  ),
    .fast_rd_done               (fast_rd_done               ),
    .ADC_DATA                   (ADC_DATA                   ),
    .ADC_DATA_VALID             (ADC_DATA_VALID             )
    );

    /* -----------------------------------------------------------------
     Memory wrapper
     ----------------------------------------------------------------- */
    memory_wrapper
    u_memory_wrapper
    (
    .clk                        (pktctrl_clk                ),
    .chip_en_0                  (chip_en_0                  ),
    .chip_en_1                  (chip_en_1                  ),
    .chip_en_2                  (chip_en_2                  ),
    .chip_en_3                  (chip_en_3                  ),
    .chip_en_4                  (chip_en_4                  ),
    .chip_en_5                  (chip_en_5                  ),
    .chip_en_6                  (chip_en_6                  ),
    .chip_en_7                  (chip_en_7                  ),
    .chip_en_8                  (chip_en_8                  ),
    .chip_en_9                  (chip_en_9                  ),
    .chip_en_10                 (chip_en_10                 ),
    .chip_en_11                 (chip_en_11                 ),
    .chip_en_12                 (chip_en_12                 ),
    .chip_en_13                 (chip_en_13                 ),
    .chip_en_14                 (chip_en_14                 ),
    .chip_en_15                 (chip_en_15                 ),
    .chip_en_16                 (chip_en_16                 ),
    .chip_en_17                 (chip_en_17                 ),
    .chip_en_18                 (chip_en_18                 ),
    .chip_en_19                 (chip_en_19                 ),
    .chip_en_20                 (chip_en_20                 ),
    .chip_en_21                 (chip_en_21                 ),
    .chip_en_22                 (chip_en_22                 ),
    .chip_en_23                 (chip_en_23                 ),
    .wr_en_0                    (wr_en_0                    ),
    .wr_en_1                    (wr_en_1                    ),
    .wr_en_2                    (wr_en_2                    ),
    .wr_en_3                    (wr_en_3                    ),
    .wr_en_4                    (wr_en_4                    ),
    .wr_en_5                    (wr_en_5                    ),
    .wr_en_6                    (wr_en_6                    ),
    .wr_en_7                    (wr_en_7                    ),
    .wr_en_8                    (wr_en_8                    ),
    .wr_en_9                    (wr_en_9                    ),
    .wr_en_10                   (wr_en_10                   ),
    .wr_en_11                   (wr_en_11                   ),
    .wr_en_12                   (wr_en_12                   ),
    .wr_en_13                   (wr_en_13                   ),
    .wr_en_14                   (wr_en_14                   ),
    .wr_en_15                   (wr_en_15                   ),
    .wr_en_16                   (wr_en_16                   ),
    .wr_en_17                   (wr_en_17                   ),
    .wr_en_18                   (wr_en_18                   ),
    .wr_en_19                   (wr_en_19                   ),
    .wr_en_20                   (wr_en_20                   ),
    .wr_en_21                   (wr_en_21                   ),
    .wr_en_22                   (wr_en_22                   ),
    .wr_en_23                   (wr_en_23                   ),
    .addr_0                     (addr_0                     ),
    .addr_1                     (addr_1                     ),
    .addr_2                     (addr_2                     ),
    .addr_3                     (addr_3                     ),
    .addr_4                     (addr_4                     ),
    .addr_5                     (addr_5                     ),
    .addr_6                     (addr_6                     ),
    .addr_7                     (addr_7                     ),
    .addr_8                     (addr_8                     ),
    .addr_9                     (addr_9                     ),
    .addr_10                    (addr_10                    ),
    .addr_11                    (addr_11                    ),
    .addr_12                    (addr_12                    ),
    .addr_13                    (addr_13                    ),
    .addr_14                    (addr_14                    ),
    .addr_15                    (addr_15                    ),
    .addr_16                    (addr_16                    ),
    .addr_17                    (addr_17                    ),
    .addr_18                    (addr_18                    ),
    .addr_19                    (addr_19                    ),
    .addr_20                    (addr_20                    ),
    .addr_21                    (addr_21                    ),
    .addr_22                    (addr_22                    ),
    .addr_23                    (addr_23                    ),
    .din_0                      (adc_data_0                 ),
    .din_1                      (adc_data_1                 ),
    .din_2                      (adc_data_2                 ),
    .din_3                      (adc_data_3                 ),
    .din_4                      (adc_data_4                 ),
    .din_5                      (adc_data_5                 ),
    .din_6                      (adc_data_6                 ),
    .din_7                      (adc_data_7                 ),
    .din_8                      (adc_data_8                 ),
    .din_9                      (adc_data_9                 ),
    .din_10                     (adc_data_10                ),
    .din_11                     (adc_data_11                ),
    .din_12                     (adc_data_12                ),
    .din_13                     (adc_data_13                ),
    .din_14                     (adc_data_14                ),
    .din_15                     (adc_data_15                ),
    .din_16                     (adc_data_16                ),
    .din_17                     (adc_data_17                ),
    .din_18                     (adc_data_18                ),
    .din_19                     (adc_data_19                ),
    .din_20                     (adc_data_20                ),
    .din_21                     (adc_data_21                ),
    .din_22                     (adc_data_22                ),
    .din_23                     (adc_data_23                ),
    .dout_0                     (dout_0                     ),
    .dout_1                     (dout_1                     ),
    .dout_2                     (dout_2                     ),
    .dout_3                     (dout_3                     ),
    .dout_4                     (dout_4                     ),
    .dout_5                     (dout_5                     ),
    .dout_6                     (dout_6                     ),
    .dout_7                     (dout_7                     ),
    .dout_8                     (dout_8                     ),
    .dout_9                     (dout_9                     ),
    .dout_10                    (dout_10                    ),
    .dout_11                    (dout_11                    ),
    .dout_12                    (dout_12                    ),
    .dout_13                    (dout_13                    ),
    .dout_14                    (dout_14                    ),
    .dout_15                    (dout_15                    ),
    .dout_16                    (dout_16                    ),
    .dout_17                    (dout_17                    ),
    .dout_18                    (dout_18                    ),
    .dout_19                    (dout_19                    ),
    .dout_20                    (dout_20                    ),
    .dout_21                    (dout_21                    ),
    .dout_22                    (dout_22                    ),
    .dout_23                    (dout_23                    )
);

endmodule
