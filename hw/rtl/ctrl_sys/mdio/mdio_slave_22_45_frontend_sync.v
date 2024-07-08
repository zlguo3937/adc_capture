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
//  2024-02-08                  1.0         mdio_slave_22_45_frontend_sync
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
`timescale 1ns/1ns
module mdio_slave_22_45_frontend_sync
(
    input   wire            clk_25m,            // regmap work clock
    input   wire            rst_n,

    input   wire            mdc,
    input   wire            mdio_in,
    output  wire            mdio_out,
    output  wire            mdio_oe,

    input   wire    [4 :0]  legal_phy_addr,     // pin input
    input   wire    [4 :0]  legal_phy_addr_mask,
    input   wire    [4 :0]  broadcast_addr,
    input   wire            broadcast_mode,
    input   wire            opendrain_mode,
    input   wire            enable,

    input   wire    [15:0]  resp_rdata,
    input   wire            resp_ready,
    output  reg             legal,
    output  wire    [31:0]  req_data,
    output  wire            req_regaddr_done,
    output  wire            req_frame_done,
    output  wire            req_phyaddr_done

);

    localparam  IDLE = 3'b001,
                RX   = 3'b010,
                TX   = 3'b100;

    localparam  OP_WRITE = 2'b01,
                OP_READ  = 2'b10;

    reg [2:0]   state;
    reg [2:0]   next_state;
    reg [5:0]   count;






    reg [31:0]  rx_data;
    reg [15:0]  tx_data;
    reg [4:0]   phy_addr;

    reg         phyaddr_done_r;
    reg         regaddr_done_r;
    reg         frame_done_r;

    reg [2:0]   phyaddr_done_pre;
    reg [2:0]   regaddr_done_pre;
    reg [2:0]   frame_done_pre;

    wire        legal_mdc;
    wire        mdio_oe_r;
    wire        mdio_oen;
    wire        mdio_out_dly;
    
    wire        st_done;
    wire        op_done;
    wire        phyaddr_done;
    wire        regaddr_done;
    wire        frame_done;
    wire        ta_0_done;
    wire        ta_1_done;

    assign st_done      = count == 6'd2;
    assign op_done      = count == 6'd3;
    assign phyaddr_done = count == 6'd9;
    assign regaddr_done = count == 6'd13;
    assign frame_done   = count == 6'd31;
    assign ta_0_done    = count == 6'd14;
    assign ta_1_done    = count == 6'd15;

    /* ---------------------------
     backend interaction 
    ---------------------------- */
    always @(negedge mdc or negedge rst_n)
    begin
        if (!rst_n)
            count <= 6'd0;
        else if (!enable)
            count <= 6'd0;
        else if (state == IDLE)
            count <= 6'd0;
        else
            count <= count + 1'd1;
    end

    always @(posedge mdc or negedge rst_n)
    begin
        if (!rst_n)
            rx_data <= 32'h7fff_ffff;
        else if (!enable)
            rx_data <= 32'h7fff_ffff;
        else begin
            rx_data[31] <= 1'b0;
            rx_data[31-count] <= mdio_in;
        end
    end

    assign req_data = legal_mdc ? rx_data : 32'hffff_ffff;
    
    always @(posedge mdc or negedge rst_n)
    begin
        if (!rst_n) begin
            regaddr_done_r <= 1'b0;
            frame_done_r <= 1'b0;
        end
        else if (legal_mdc) begin
            regaddr_done_r <= regaddr_done;
            frame_done_r <= frame_done;
        end
        else begin
            regaddr_done_r <= 1'b0;
            frame_done_r <= 1'b0;
        end
    end

    always @(posedge mdc or negedge rst_n)
    begin
        if (!rst_n)
            phyaddr_done_r <= 1'b0;
        else
            phyaddr_done_r <= phyaddr_done;
    end

    //CDC
    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            phyaddr_done_pre <= 'b0;
            regaddr_done_pre <= 'b0;
            frame_done_pre   <= 'b0;
        end
        else begin
            phyaddr_done_pre <= {phyaddr_done_pre[1:0],phyaddr_done_r};
            regaddr_done_pre <= {regaddr_done_pre[1:0],regaddr_done_r};
            frame_done_pre   <= {frame_done_pre[1:0],frame_done_r};
        end
    end

    assign req_phyaddr_done = phyaddr_done_pre[1] & ~phyaddr_done_pre[2];
    assign req_regaddr_done = regaddr_done_pre[1] & ~regaddr_done_pre[2];
    assign req_frame_done   = frame_done_pre[1]   & ~frame_done_pre[2];

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            legal <= 1'b0;
        else
            legal <= legal_mdc;
    end

    /* ---------------------------
     FSM for MDIO TX & RX
    ---------------------------- */
    always @(posedge mdc or negedge rst_n)
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
                if (~mdio_in)
                    next_state = RX;
                else
                    next_state = IDLE;
            RX  :
                if (ta_0_done && rx_data[29] && legal_mdc)
                    next_state = TX;
                else if (frame_done)
                    next_state = IDLE;
                else
                    next_state = RX;
            TX  :
                if (frame_done)
                    next_state = IDLE;
                else
                    next_state = TX;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge mdc or negedge rst_n)
    begin
        if (!rst_n)
            phy_addr <= 'b0;
        else if (phyaddr_done)
            phy_addr <= rx_data[27:23];
    end

    assign legal_mdc = (phy_addr == (legal_phy_addr & legal_phy_addr_mask)) | (broadcast_mode & (phy_addr == broadcast_addr));

    always @(posedge mdc or negedge rst_n)
    begin
        if (!rst_n)
            tx_data <= 'b0;
        else if (!enable)
            tx_data <= 'b0;
        else if (state == TX) begin
            if (ta_1_done)
                tx_data <= resp_rdata;
            else if (frame_done)
                tx_data <= tx_data; // avoid glitch
            else
                tx_data <= tx_data << 1;
        end
        else
            tx_data <= 'b0;
    end

    assign mdio_oe_r = state == TX;
    assign mdio_out  = tx_data[15];
    assign mdio_oe   = opendrain_mode ? (mdio_oe_r & ~mdio_out) : mdio_oe_r;

endmodule
