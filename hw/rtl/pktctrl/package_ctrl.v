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
    input   wire    [6:0]       rf_mdio_which_memory_sel,
    input   wire    [14:0]      rf_mdio_memory_addr,
    output  reg     [8:0]       rf_mdio_pkt_data,

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

    wire    [95:0]      chip_en;
    wire    [95:0]      wr_en;

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

    reg  mdio_rd_en;

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
                mdio_rd_en = 1'b1;
                if (mdio_rd_done) begin
                    next_sta = IDLE;
                    mdio_rd_en = 1'b0;
                end
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
    wire     [95:0]      mdio_rd_chip_en;
    gen_mdio_read_logic
    u_gen_mdio_read_logic
    (
    .clk_200m                 (clk_200m                 ),
    .rstn_200m                (rstn_200m                ),
    .rf_mdio_read_en          (rf_mdio_read_en          ),
    .rf_mdio_which_memory_sel (rf_mdio_which_memory_sel ),
    .rf_mdio_memory_addr      (rf_mdio_memory_addr      ),
    .mdio_rd_en               (mdio_rd_en               ),
    .data_out                 (data_out                 ),
    .mdio_rd_chip_en          (mdio_rd_chip_en          ),
    .mdio_rd_raddr            (mdio_rd_raddr            ),
    .rf_mdio_pkt_data         (rf_mdio_pkt_data         )
    );

    /* -----------------------------------------------------------------
     Fast Read Logic
     ----------------------------------------------------------------- */

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
