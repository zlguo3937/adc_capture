// ------------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//-------------------------------------------------------------------------
//  2024-02-08                  1.0         mdio_slave_22_45_frontend_async
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
`timescale 1ns/1ns
module mdio_slave_22_45_frontend_async
(
    input   wire            clk_25m,            // work clock
    input   wire            rst_n,

    input   wire            mdio_in,
    input   wire            mdc,                // at most 2.5M, didn't support fast clock
    output  reg             mdio_out,
    output  reg             mdio_oe,            // if high, write rdata_mem to mdio

    input   wire    [4 :0]  legal_phy_addr,     // pin input
    input   wire    [4 :0]  legal_phy_addr_mask,
    input   wire    [4 :0]  broadcast_addr,
    input   wire            broadcast_mode,
    input   wire            non_zero_detect,
    input   wire            opendrain_mode,
    input   wire            enable,

    input   wire    [15:0]  resp_rdata,
    input   wire            resp_ready,
    output  wire            legal,
    output  reg     [31:0]  rx_data,
    output  reg             info_done,
    output  reg             data_done,
    output  reg             phyaddr_done

);

    localparam  IDLE = 4'b0001,
                ST   = 4'b0010,
                RX   = 4'b0100,
                TX   = 4'b1000;

    reg [3:0]   state;
    reg [3:0]   next_state;

    reg [4:0]   count;

    /* -----------------------------
     CDC input && glitch shield
     ---------------------------- */
    reg	        mdio_cdc_out_0;
    reg         mdio_cdc_out;

    reg	        mdc_cdc_out_0;
    reg	        mdc_cdc_out;

    reg         mdio_cdc_r;
    reg         mdc_cdc_r;

    reg         mdio_filted;
    reg         mdc_filted;

    reg         mdc_filted_r;

    reg         mdio_neg_flag;

    always@(posedge clk_25m or negedge rst_n)
    begin
    	if (!rst_n) begin
    		mdio_cdc_out_0  <= 1'b1;
    		mdio_cdc_out    <= 1'b1;
    	end
    	else begin
    		mdio_cdc_out_0  <= mdio_in;
    		mdio_cdc_out    <= mdio_cdc_out_0;
    	end
    end

    always@(posedge clk_25m or negedge rst_n)
    begin
    	if (!rst_n) begin
    		mdc_cdc_out_0  <= 1'b1;
    		mdc_cdc_out    <= 1'b1;
    	end
    	else begin
    		mdc_cdc_out_0  <= mdc;
    		mdc_cdc_out    <= mdc_cdc_out_0;
    	end
    end

    always@(posedge clk_25m or negedge rst_n)
    begin
    	if (!rst_n) begin
    		mdio_cdc_r  <= 1'b1;
    		mdc_cdc_r   <= 1'b0;
    	end
    	else begin
    		mdio_cdc_r  <= mdio_cdc_out;
    		mdc_cdc_r   <= mdc_cdc_out;
    	end
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_filted <= 1'b1;
        else if ((mdio_cdc_out ^ mdio_cdc_r) && (mdio_cdc_r ^ mdio_filted))
            mdio_filted <= mdio_cdc_out;
    
        else
            mdio_filted <= mdio_cdc_r;
    end
    
    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdc_filted <= 1'b1;
        else if ((mdc_cdc_out ^ mdc_cdc_r) && (mdc_cdc_r ^ mdc_filted))
            mdc_filted <= mdc_cdc_out;
    
        else
            mdc_filted <= mdc_cdc_r;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdc_filted_r <= 1'b0;
        else
            mdc_filted_r <= mdc_filted;
    end

    wire    mdc_pos;
    wire    mdc_neg;
    wire    mdc_pos_pre;

    assign mdc_pos = ~mdc_filted_r && mdc_filted;
    assign mdc_neg = mdc_filted_r && ~mdc_filted;
    assign mdc_pos_pre = mdc_cdc_r && mdc_cdc_out && ~mdc_filted;

    /* ---------------------------------------------
     avoid situation which mdio remains 0 when IDLE
     --------------------------------------------- */
    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_neg_flag <= 1'b0;
        else if (!enable)
            mdio_neg_flag <= 1'b0;
        else if (state != IDLE)
            mdio_neg_flag <= 1'b0;
        else if (mdio_cdc_r && mdio_cdc_out && ~mdio_filted)
            mdio_neg_flag <= 1'b0;
        else if ((~mdio_cdc_r) && (~mdio_cdc_out) && mdio_filted)
            mdio_neg_flag <= 1'b1;
        else
            mdio_neg_flag <= mdio_neg_flag;
    end

    /* ---------------------------
     backend interaction 
    ---------------------------- */
    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            count <= 5'd0;
        else if (!enable)
            count <= 5'd0;
        else if (state == IDLE)
            count <= 5'd0;
        else if (count == 5'd31 && mdc_neg)
            count <= 5'd0;
        else if (mdc_neg)
            count <= count + 1'd1;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            rx_data <= 32'h7fff_ffff;
        else if (!enable)
            rx_data <= 32'h7fff_ffff;
        else if (state == IDLE) begin
            if (next_state == ST)
                rx_data[31-count] <= mdio_filted;
            else
                rx_data <= 32'h7fff_ffff;
        end
        else if (mdc_pos)
            rx_data[31-count] <= mdio_filted;
    end

    reg [15:0]  rdata;
    reg         rdata_ready;
    reg [15:0]  tx_data;
    reg         mdio_oe_tmp;
    reg         mdio_out_tmp;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            rdata       <= 16'b0;
            rdata_ready <= 1'b0;
        end
        else if (!enable) begin
            rdata       <= 16'b0;
            rdata_ready <= 1'b0;
        end
        else if (resp_ready) begin
            rdata       <= resp_rdata;
            rdata_ready <= 1'b1;
        end
        else begin
            rdata_ready <= 1'b0;
        end
    end

    /* ---------------------------
     phy addr control
    ---------------------------- */
    reg [4:0]   true_legal_phy_addr;
    reg         latch_done;
    reg [4:0]   phy_addr;
    reg         phyaddr_done_r;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            phy_addr <= 5'b0;
        else if (!enable)
            phy_addr <= 5'b0;
        else if (phyaddr_done)
            phy_addr <= rx_data[27:23];
        else
            phy_addr <= phy_addr;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            phyaddr_done_r <= 1'b0;
        else
            phyaddr_done_r <= phyaddr_done;
    end

    // broadcast mode
    assign legal = (phy_addr == (true_legal_phy_addr & legal_phy_addr_mask)) || (broadcast_mode && (phy_addr == broadcast_addr));

    // non zero detection
    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            true_legal_phy_addr     <= 'b0;
        else if (non_zero_detect && legal_phy_addr == 5'b0) begin
            if (latch_done)
                true_legal_phy_addr <= true_legal_phy_addr;
            else if (phyaddr_done_r)
                true_legal_phy_addr <= phy_addr;
        end
        else
            true_legal_phy_addr     <= legal_phy_addr;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            latch_done <= 1'b0;
        else if ((true_legal_phy_addr != 5'b0) && non_zero_detect && (legal_phy_addr == 5'b0))
            latch_done <= 1'b1;
    end

    /* ---------------------------
     FSM for MDIO TX & RX
    ---------------------------- */
    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            state <= IDLE;
        else if (!enable)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*)
    begin
        case (state)
            IDLE:
                if (mdio_neg_flag && mdc_pos_pre)
                    next_state = ST;
                else
                    next_state = IDLE;
            ST:
                if (count == 5'd9 && mdc_neg)
                    next_state = RX;
                else
                    next_state = ST;
            RX:
                if (count == 5'd14 && rx_data[29] && legal)
                    next_state = TX;
                else if (count == 5'd0 && mdc_pos) begin
                    if (mdio_filted)
                        next_state = IDLE;
                    else
                        next_state = RX; //preamble suppression
                end
                else
                    next_state = RX;
            TX:
                if (count == 5'd0 && mdc_pos) begin
                    if (mdio_filted)
                        next_state = IDLE;
                    else
                        next_state = ST; //preamble suppression
                end
                else
                    next_state = TX;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            phyaddr_done <= 1'b0;
        else if (count == 5'd8 && mdc_pos)
            phyaddr_done <= 1'b1;
        else
            phyaddr_done <= 1'b0;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            info_done <= 1'b0;
        else if (!legal)
            info_done <= 1'b0;
        else if (count == 5'd13 && mdc_pos)
            info_done <= 1'b1;
        else
            info_done <= 1'b0;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            data_done <= 1'b0;
        else if (!legal)
            data_done <= 1'b0;
        else if (count == 5'd31 && mdc_pos)
            data_done <= 1'b1;
        else
            data_done <= 1'b0;
    end

    reg shift_en;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            tx_data <= 16'b0;
        else if (!enable)
            tx_data <= 16'b0;
        else if (rdata_ready)
            tx_data <= rdata;
        else if (shift_en && mdc_pos)
            tx_data <= tx_data << 1;
        else
            tx_data <= tx_data;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            shift_en <= 1'b0;
        else if (state == TX) begin
            if (count == 5'd15 && mdc_pos_pre)
                shift_en <= 1'b1;
            else if (count == 5'd30 && mdc_pos_pre)
                shift_en <= 1'b0;
        end
        else
            shift_en <= 1'b0;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_oe_tmp <= 1'b0;
        else if (state == TX) begin
            if (count == 5'd14 && mdc_pos)
                mdio_oe_tmp <= 1'b1;
            else if (count == 5'd31 && mdc_pos_pre)
                mdio_oe_tmp <= 1'b0;
            else
                mdio_oe_tmp <= mdio_oe_tmp;
        end
        else
            mdio_oe_tmp <= 1'b0;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_out_tmp <= 1'b0;
        else if (state == TX) begin
            if (mdc_pos) begin
                if (count == 'd14)
                    mdio_out_tmp <= 1'b0;
                else
                    mdio_out_tmp <= tx_data[15];
            end
        end
        else
            mdio_out_tmp <= 1'b0;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_oe <= 1'b0;
        else if (!legal)
            mdio_oe <= 1'b0;
        else if (opendrain_mode)
            mdio_oe <= mdio_oe_tmp & ~mdio_out_tmp;
        else
            mdio_oe <= mdio_oe_tmp;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            mdio_out <= 1'b0;
        else if (!legal)
            mdio_out <= 1'b0;
        else
            mdio_out <= mdio_out_tmp;
    end

endmodule
