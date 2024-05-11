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
module package_ctrl
(
    input   wire                clk_200m,
    input   wire                pktctrl_wclk,
    input   wire                pktctrl_rclk,

    input   wire                rstn_200m,
    input   wire                pktctrl_wrstn,
    input   wire                pktctrl_rrstn,

    input   wire                rf_capture_mode,
    input   wire                rf_capture_start,

    input   wire    [9*96-1:0]  data_in,

    // Mdio read
    input   wire                rf_mdio_read_en,    // pulse
    input   wire    [6:0]       rf_which_memory_sel,
    input   wire    [14:0]      rf_memory_addr,
    output  wire    [8:0]       rf_mdio_pkt_data,

    // Fast read
    output  wire    [17:0]      pkt_data,
    output  wire                pkt_data_valid

);

    localparam  IDLE            = 5'b0_0001,
                WRITE           = 5'b0_0010,
                WRITE_DONE      = 5'b0_0100,
                MDIO_READ       = 5'b0_1000,
                FAST_READ       = 5'b1_0000;

    reg     [4:0]       curr_sta;
    reg     [4:0]       next_sta;

    reg                 write_en;
    reg     [1:0]       write_en_sync;
    reg                 wr_done;
    reg                 wr_done_r;
    reg     [2:0]       wr_done_dly;
    reg     [1:0]       wr_done_sync;
    reg                 rd_done;
    reg     [1:0]       rd_done_sync;

    wire    [95:0]      mdio_rd_cen;
    wire    [95:0]      mdio_rd_wen;
    wire    [15*96-1:0] mdio_rd_raddr;
    reg     [6:0]       reg_mdio_raddr;

    wire    [95:0]      fast_rd_cen;
    wire    [95:0]      fast_rd_wen;
    wire    [15*96-1:0] fast_rd_raddr;

    wire    [95:0]      rd_cen;
    wire    [95:0]      rd_wen;
    wire    [15*96-1:0] raddr;

    wire                wr_wen;
    wire                wr_cen;
    reg     [14:0]      waddr;

    wire    [95:0]      cen;
    wire    [95:0]      wen;
    wire    [15*96-1:0] addr;

    wire    [9*96-1:0]  data_out;

    /* -----------------------------------------------------------------
     FSM logic
     ----------------------------------------------------------------- */
    always @(posedge clk_200m or negedge rstn_200m) begin
        if (!rstn_200m)
            curr_sta <= IDLE;
        else
            curr_sta <= next_sta;
    end

    always @(*) begin
        begin
            next_sta = curr_sta;
            write_en = 1'b0;
        end
        case(curr_sta)
            IDLE: begin
                if (rf_capture_start)
                    next_sta = WRITE;
            end

            WRITE: begin
                write_en = 1'b1;
                if (wr_done_sync[1]) begin
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
                if (mdio_rd_done)
                    next_sta = IDLE;
            end

            FAST_READ: begin
                if (fast_rd_done_sync)
                    next_sta = IDLE;
            end

            default:next_sta = IDLE;
        endcase
    end

    /* -----------------------------------------------------------------
     Write Logic
     ----------------------------------------------------------------- */
    // Sync logic
    always @(posedge pktctrl_wclk or negedge pktctrl_wrstn) begin
        if (!pktctrl_wrstn) begin
            write_en_sync   <= 2'b00;
            rd_done_sync    <= 2'b00;
        end
        else begin
            write_en_sync   <= {write_en_sync[0], write_en};
            rd_done_sync    <= {rd_done_sync[0], mdio_rd_done | fast_rd_done};
        end
    end

    always @(posedge pktctrl_wclk or negedge pktctrl_wrstn) begin
        if (!pktctrl_wrstn)
            wr_done <= 1'b0;
        else if (rd_done_sync[1])
            wr_done <= 1'b0;
        else if (&waddr)
            wr_done <= 1'b1;
    end

    always @(posedge pktctrl_wclk or negedge pktctrl_wrstn) begin
        if (!pktctrl_wrstn)
            wr_done_dly <= 3'b000;
        else
            wr_done_dly <= {wr_done_dly[1:0], wr_done};
    end

    always @(posedge pktctrl_wclk or negedge pktctrl_wrstn) begin
        if (!pktctrl_wrstn)
            wr_done_r <= 1'b0;
        else if (wr_done)
            wr_done_r <= 1'b1;
        else if (wr_done_dly[2])
            wr_done_r <= 1'b0;
    end

    always @(posedge clk_200m or negedge rstn_200m) begin
        if (!pktctrl_wrstn)
            wr_done_sync <= 2'b00;
        else
            wr_done_sync <= {wr_done_sync[0], wr_done_r};
    end

    // Generate wr_wen,wr_cen,waddr
    assign wr_wen = {96{1'b1}};
    assign wr_cen = {96{1'b1}};

    always @(posedge pktctrl_wclk or negedge pktctrl_wrstn) begin
        if (!pktctrl_wrstn)
            waddr <= 15'b0;
        else if (&waddr)
            waddr <= 15'b0;
        else if(write_en_sync[1])
            waddr <= waddr + 1'b1;
    end

    /* -----------------------------------------------------------------
     Mdio Read Logic
     ----------------------------------------------------------------- */
    genvar i;
    generate
        for (i=0;i<96;i=i+1) begin: mdio_rd_chip_en
            assign mdio_rd_chip_en[i] = (curr_sta == MDIO_READ) ? (rf_mdio_read_en ? (rf_which_memory_sel == i) : 1'b0) : 1'b0;
        end
    endgenerate

    always @(*) begin
        case(rf_which_memory_sel)
            0:  mdio_pkt_data = data_out[0*9+:9]   1:  mdio_pkt_data = data_out[1*9+:9];  2:  mdio_pkt_data = data_out[2*9+:9];  3:  mdio_pkt_data = data_out[3*9+:9];
            4:  mdio_pkt_data = data_out[4*9+:9]   5:  mdio_pkt_data = data_out[5**9+:9]; 6:  mdio_pkt_data = data_out[6*9+:9];  7:  mdio_pkt_data = data_out[7*9+:9];
            8:  mdio_pkt_data = data_out[8*9+:9]   9:  mdio_pkt_data = data_out[9**9+:9]; 10: mdio_pkt_data = data_out[10*9+:9]; 11: mdio_pkt_data = data_out[11*9+:9];
            12: mdio_pkt_data = data_out[12*9+:9]; 13: mdio_pkt_data = data_out[13*9+:9]; 14: mdio_pkt_data = data_out[14*9+:9]; 15: mdio_pkt_data = data_out[15*9+:9];
            16: mdio_pkt_data = data_out[16*9+:9]; 17: mdio_pkt_data = data_out[17*9+:9]; 18: mdio_pkt_data = data_out[18*9+:9]; 19: mdio_pkt_data = data_out[19*9+:9];
            20: mdio_pkt_data = data_out[20*9+:9]; 21: mdio_pkt_data = data_out[21*9+:9]; 22: mdio_pkt_data = data_out[22*9+:9]; 23: mdio_pkt_data = data_out[23*9+:9];
            24: mdio_pkt_data = data_out[24*9+:9]; 25: mdio_pkt_data = data_out[25*9+:9]; 26: mdio_pkt_data = data_out[26*9+:9]; 27: mdio_pkt_data = data_out[27*9+:9];
            28: mdio_pkt_data = data_out[28*9+:9]; 29: mdio_pkt_data = data_out[29*9+:9]; 30: mdio_pkt_data = data_out[30*9+:9]; 31: mdio_pkt_data = data_out[31*9+:9];
            32: mdio_pkt_data = data_out[32*9+:9]; 33: mdio_pkt_data = data_out[33*9+:9]; 34: mdio_pkt_data = data_out[34*9+:9]; 35: mdio_pkt_data = data_out[35*9+:9];
            36: mdio_pkt_data = data_out[36*9+:9]; 37: mdio_pkt_data = data_out[37*9+:9]; 38: mdio_pkt_data = data_out[38*9+:9]; 39: mdio_pkt_data = data_out[39*9+:9];
            40: mdio_pkt_data = data_out[40*9+:9]; 41: mdio_pkt_data = data_out[41*9+:9]; 42: mdio_pkt_data = data_out[42*9+:9]; 43: mdio_pkt_data = data_out[43*9+:9];
            44: mdio_pkt_data = data_out[44*9+:9]; 45: mdio_pkt_data = data_out[45*9+:9]; 46: mdio_pkt_data = data_out[46*9+:9]; 47: mdio_pkt_data = data_out[47*9+:9];
            48: mdio_pkt_data = data_out[48*9+:9]; 49: mdio_pkt_data = data_out[49*9+:9]; 50: mdio_pkt_data = data_out[50*9+:9]; 51: mdio_pkt_data = data_out[51*9+:9];
            52: mdio_pkt_data = data_out[52*9+:9]; 53: mdio_pkt_data = data_out[53*9+:9]; 54: mdio_pkt_data = data_out[54*9+:9]; 55: mdio_pkt_data = data_out[55*9+:9];
            56: mdio_pkt_data = data_out[56*9+:9]; 57: mdio_pkt_data = data_out[57*9+:9]; 58: mdio_pkt_data = data_out[58*9+:9]; 59: mdio_pkt_data = data_out[59*9+:9];
            60: mdio_pkt_data = data_out[60*9+:9]; 61: mdio_pkt_data = data_out[61*9+:9]; 62: mdio_pkt_data = data_out[62*9+:9]; 63: mdio_pkt_data = data_out[63*9+:9];
            64: mdio_pkt_data = data_out[64*9+:9]; 65: mdio_pkt_data = data_out[65*9+:9]; 66: mdio_pkt_data = data_out[66*9+:9]; 67: mdio_pkt_data = data_out[67*9+:9];
            68: mdio_pkt_data = data_out[68*9+:9]; 69: mdio_pkt_data = data_out[69*9+:9]; 70: mdio_pkt_data = data_out[70*9+:9]; 71: mdio_pkt_data = data_out[71*9+:9];
            72: mdio_pkt_data = data_out[72*9+:9]; 73: mdio_pkt_data = data_out[73*9+:9]; 74: mdio_pkt_data = data_out[74*9+:9]; 75: mdio_pkt_data = data_out[75*9+:9];
            76: mdio_pkt_data = data_out[76*9+:9]; 77: mdio_pkt_data = data_out[77*9+:9]; 78: mdio_pkt_data = data_out[78*9+:9]; 79: mdio_pkt_data = data_out[79*9+:9];
            80: mdio_pkt_data = data_out[80*9+:9]; 81: mdio_pkt_data = data_out[81*9+:9]; 82: mdio_pkt_data = data_out[82*9+:9]; 83: mdio_pkt_data = data_out[83*9+:9];
            84: mdio_pkt_data = data_out[84*9+:9]; 85: mdio_pkt_data = data_out[85*9+:9]; 86: mdio_pkt_data = data_out[86*9+:9]; 87: mdio_pkt_data = data_out[87*9+:9];
            88: mdio_pkt_data = data_out[88*9+:9]; 89: mdio_pkt_data = data_out[89*9+:9]; 90: mdio_pkt_data = data_out[90*9+:9]; 91: mdio_pkt_data = data_out[91*9+:9];
            92: mdio_pkt_data = data_out[92*9+:9]; 93: mdio_pkt_data = data_out[93*9+:9]; 94: mdio_pkt_data = data_out[94*9+:9]; 95: mdio_pkt_data = data_out[95*9+:9];
        endcase
    end

    always @(posedge clk_200m or negedge rstn_200m) begin
        if (!rstn_200m)
            mdio_read_en <= 1'b0;
        else
            mdio_read_en <= rf_mdio_read_en;
    end

    always @(posedge clk_200m or negedge rstn_200m) begin
        if (!rstn_200m)
            rf_mdio_pkt_data <= 9'h0;
        else if (curr_sta == MDIO_READ) begin
            if (mdio_read_en)
                rf_mdio_pkt_data <= mdio_pkt_data;
        end
        else
            rf_mdio_pkt_data <= 9'h0;
    end

    /* -----------------------------------------------------------------
     Fast Read Logic
     ----------------------------------------------------------------- */


    /* -----------------------------------------------------------------
     Read Done Generate
     ----------------------------------------------------------------- */
    always @(posedge clk_200m or negedge rstn_200m) begin
        if (!rstn_200m)
            mdio_rd_done <= 1'b0;
        else if (write_en)
            mdio_rd_done <= 1'b0;
        else if ((reg_mdio_raddr == 7'd95) && (paddr[14:0] == 15'd32767) && (psel && !pwrite))
            mdio_rd_done <= 1'b1;
    end

    /* -----------------------------------------------------------------
     Memory interface
     ----------------------------------------------------------------- */
    assign rd_clk       = rf_capture_mode ? clk_200m        : pktctrl_rclk;
    assign rd_chip_en   = rf_capture_mode ? mdio_rd_chip_en : fast_rd_chip_en;
    assign raddr        = rf_capture_mode ? mdio_rd_raddr   : fast_rd_raddr;

    assign clk      = write_en ? pktctrl_wclk : rd_clk;
    assign wr_en    = write_en ? {96{1'b1}}   : {96{1'b0}};
    assign chip_en  = write_en ? {96{1'b1}}   : rd_chip_en;
    assign addr     = write_en ? {96{waddr}}  : raddr;

    memory_ctrl
    u_memory_ctrl
    (
    .clk            (clk            ),
    .chip_en        (chip_en        ),
    .wr_en          (wr_en          ),
    .addr           (addr           ),
    .data_in        (data_in        ),
    .data_out       (data_out       )
    );

endmodule
