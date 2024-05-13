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

    input   wire                rf_96path_en,
    input   wire    [1:0]       rf_pkt_data_length,
    input   wire    [1:0]       rf_pkt_idle_length,

    input   wire    [9*96-1:0]  data_in,

    // Mdio read
    input   wire                rf_mdio_read_en,    // pulse
    input   wire    [6:0]       rf_mdio_which_memory_sel,
    input   wire    [14:0]      rf_mdio_memory_addr,
    output  wire    [8:0]       rf_mdio_pkt_data,

    // Fast read
    output  wire    [17:0]      fast_pkt_data,
    output  wire                fast_pkt_data_valid

);

    localparam          IDLE        = 5'b0_0001,
                        WRITE       = 5'b0_0010,
                        WRITE_DONE  = 5'b0_0100,
                        MDIO_READ   = 5'b0_1000,
                        FAST_READ   = 5'b1_0000;

    reg     [4:0]       curr_sta;
    reg     [4:0]       next_sta;

    // Write if
    reg                 write_en;
    wire    [14:0]      waddr;
    wire                wr_done;

    // Fast read if
    reg                 fast_rd_en;
    wire    [95:0]      fast_rd_chip_en;
    wire    [15*96-1:0] fast_rd_raddr;
    wire                fast_rd_done;

    wire                fast_rd_done_sync;

    // Mdio read if
    reg                 mdio_rd_en;
    wire    [95:0]      mdio_rd_chip_en;
    wire    [15*96-1:0] mdio_rd_raddr;
    wire                mdio_rd_done;

    // Memory if
    wire    [95:0]      chip_en;
    wire    [95:0]      wr_en;
    wire    [15*96-1:0] addr;

    wire    [9*96-1:0]  data_out;

    wire    [95:0]      rd_cen;
    wire    [95:0]      rd_wen;
    wire    [15*96-1:0] raddr;

    jlsemi_util_sync_pos_with_rst_low
    u_sync_wr_done
    (
    .clk        (clk_200m           ),
    .rst_n      (rstn_200m          ),
    .din        (wr_done            ),
    .dout       (wr_done_sync       )
    );

    jlsemi_util_sync_pos_with_rst_low
    u_sync_fast_rd_done
    (
    .clk        (clk_200m           ),
    .rst_n      (rstn_200m          ),
    .din        (fast_rd_done       ),
    .dout       (fast_rd_done_sync  )
    );

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
            mdio_rd_en = 1'b0;
            fast_rd_en = 1'b0;
        end
        case(curr_sta)
            IDLE: begin
                if (rf_capture_start)
                    next_sta = WRITE;
            end

            WRITE: begin
                write_en = 1'b1;
                if (wr_done_sync) begin
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
                fast_rd_en = 1'b1;
                if (fast_rd_done_sync) begin
                    next_sta = IDLE;
                    fast_rd_en = 1'b0;
                end
            end

            default:next_sta = IDLE;
        endcase
    end

    /* -----------------------------------------------------------------
     Write Logic
     ----------------------------------------------------------------- */
    gen_write_logic
    u_gen_write_logic
    (
    .clk                        (pktctrl_wclk               ),
    .rstn                       (pktctrl_wrstn              ),
    .rf_capture_start           (rf_capture_start           ),
    .write_en                   (write_en                   ),
    .waddr                      (waddr                      )
    );


    /* -----------------------------------------------------------------
     Mdio Read Logic
     ----------------------------------------------------------------- */
    gen_mdio_read_logic
    u_gen_mdio_read_logic
    (
    .clk                        (clk_200m                   ),
    .rstn                       (rstn_200m                  ),
    .rf_mdio_read_en            (rf_mdio_read_en            ),
    .rf_mdio_which_memory_sel   (rf_mdio_which_memory_sel   ),
    .rf_mdio_memory_addr        (rf_mdio_memory_addr        ),
    .mdio_rd_en                 (mdio_rd_en                 ),
    .data_out                   (data_out                   ),
    .mdio_rd_chip_en            (mdio_rd_chip_en            ),
    .mdio_rd_raddr              (mdio_rd_raddr              ),
    .rf_mdio_pkt_data           (rf_mdio_pkt_data           ),
    .mdio_rd_done               (mdio_rd_done               )
    );

    /* -----------------------------------------------------------------
     Fast Read Logic
     ----------------------------------------------------------------- */
    gen_fast_read_logic
    u_gen_fast_read_logic
    (
    .clk                        (pktctrl_rclk               ),
    .rstn                       (pktctrl_rrstn              ),
    .fast_rd_en                 (fast_rd_en                 ),
    .data_out                   (data_out                   ),
    .rf_96path_en               (rf_96path_en               ),
    .rf_pkt_data_length         (rf_pkt_data_length         ),
    .rf_pkt_idle_length         (rf_pkt_idle_length         ),
    .fast_rd_chip_en            (fast_rd_chip_en            ),
    .fast_rd_raddr              (fast_rd_raddr              ),
    .fast_pkt_data              (fast_pkt_data              ),
    .fast_pkt_data_valid        (fast_pkt_data_valid        ),
    .fast_rd_done               (fast_rd_done               )
    );

    /* -----------------------------------------------------------------
     Memory interface
     ----------------------------------------------------------------- */
    assign rd_chip_en   = rf_capture_mode ? mdio_rd_chip_en : fast_rd_chip_en;
    assign raddr        = rf_capture_mode ? mdio_rd_raddr   : fast_rd_raddr;

    assign wr_en    = write_en ? {96{1'b1}}   : {96{1'b0}};
    assign chip_en  = write_en ? {96{1'b1}}   : rd_chip_en;
    assign addr     = write_en ? {96{waddr}}  : raddr;

///////////////// memory clock must be at crg TODO
    wire   rd_clk;
    assign clk      = write_en ? pktctrl_wclk : rd_clk;
    assign rd_clk   = rf_capture_mode ? clk_200m : pktctrl_rclk;

    memory_ctrl
    u_memory_ctrl
    (
    .clk            (mem_clk        ),
    .chip_en        (chip_en        ),
    .wr_en          (wr_en          ),
    .addr           (addr           ),
    .data_in        (data_in        ),
    .data_out       (data_out       )
    );

endmodule
