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
//  2024-02-08                  1.0         mdio_slave_22_backend
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
`timescale 1ns/1ns
module mdio_slave_22_backend
(
    input   wire            clk_25m,
    input   wire            rst_n,

    input   wire            enable,

    input   wire    [13:0]  in_info,
    input   wire            in_info_en,
    input   wire    [15:0]  in_data,
    input   wire            in_data_en,

    input   wire    [15:0]  reg_if_rdata,
    input   wire            reg_if_ready,
    output  wire    [20:0]  reg_if_addr,
    output  reg     [15:0]  reg_if_wdata,
    output  reg             reg_if_valid,
    output  reg             reg_if_we,

    output  reg     [15:0]  resp_rdata,
    output  reg             resp_ready

);

    localparam  IDLE        = 2'd0,
                MMD_INFO    = 2'd1,
                ADDR_DATA   = 2'd2,
                RW_DATA     = 2'd3;

    reg     [1:0]   state;
    reg     [1:0]   next_state;
    
    wire    [4:0]   five_addr;
    reg             info_en;
    reg     [1:0]   data_en;
    reg     [4:0]   dev_addr;
    reg     [15:0]  reg_addr;
    reg     [1:0]   OP_code;
    
    wire            reg_if_valid_rd;
    reg             reg_if_valid_wr;
    
    wire            wr_op;
    wire            rd_op;
    wire            addr_incr;
    wire            mmd_addr;
    wire            mmd_data;

    assign wr_op        = in_info[11:10] == 2'b01;
    assign rd_op        = in_info[11:10] == 2'b10;
    assign addr_incr    = OP_code == 2'b10 || (OP_code == 2'b11 && wr_op);
    assign five_addr    = in_info[4:0];
    assign mmd_addr     = OP_code == 2'b00;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            info_en <= 1'b0;
        else if (!enable)
            info_en <= 1'b0;
        else
            info_en <= in_info_en;
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            data_en <= 2'b00;
        else if (!enable)
            data_en <= 2'b00;
        else
            data_en <= { data_en[0], in_data_en };
    end

    /* -----------------------------
      FSM
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
                if (in_info_en) begin
                    if (five_addr == 'd13)
                        next_state = MMD_INFO;
                    else if (five_addr == 'd14) begin
                        if (mmd_addr)
                            next_state = ADDR_DATA;
                        else
                            next_state = RW_DATA;
                    end
                    else
                        next_state = IDLE;
                end
                else
                    next_state = IDLE;

            MMD_INFO:
                if (data_en[1])
                    next_state = IDLE;
                else
                    next_state = MMD_INFO;

            ADDR_DATA:
                if (data_en[1])
                    next_state = IDLE;
                else
                    next_state = ADDR_DATA;

            RW_DATA:
                if (data_en[1])
                    next_state = IDLE;
                else
                    next_state = RW_DATA;

            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            reg_if_valid    <=  1'b0;
            reg_if_wdata    <= 16'b0;
            reg_if_we       <=  1'b0;
            dev_addr        <=  5'b0;
            reg_addr        <= 16'b0;
            OP_code         <=  2'b0;
        end
        else
        begin
            case (next_state)
                IDLE:
                    begin
                        reg_if_valid    <= 1'b0;
                        reg_if_wdata    <= reg_if_wdata;
                        reg_if_we       <= 1'b0;
                        dev_addr        <= dev_addr;
                        reg_addr        <= reg_addr;
                        OP_code         <= OP_code;
                    end

                MMD_INFO:
                    begin
                        if (wr_op) begin
                            if (in_data_en) begin
                                OP_code     <= in_data[15:14];
                                dev_addr    <= in_data[4:0];
                            end
                        end
                    end

                ADDR_DATA:
                    begin
                        if (wr_op)
                            reg_addr    <= in_data;
                    end

                RW_DATA:
                    begin
                        if (wr_op) begin
                            if (in_data_en) begin
                                reg_if_valid <= 1'b1;
                                reg_if_wdata <= in_data;
                                reg_if_we    <= 1'b1;
                            end                       
                            else begin
                                reg_if_valid <= 1'b0;
                                reg_if_we    <= 1'b0;
                            end
                        end
                        else if (rd_op)
                            reg_if_valid <= in_info_en;

                        if (data_en[0] && addr_incr)
                            reg_addr <= reg_addr + 1'd1;
                    end

                default:
                    begin
                        reg_if_valid    <=  1'b0;
                        reg_if_wdata    <= 16'b0;
                        reg_if_we       <=  1'b0;
                        dev_addr        <=  5'b0;
                        reg_addr        <= 16'b0;
                        OP_code         <=  2'b0;
                    end
            endcase
        end
    end

    assign reg_if_addr = { dev_addr, reg_addr };

    always @(negedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            resp_rdata <= 16'b0;
            resp_ready <= 1'b0;
        end
        else if (rd_op) begin
            if (next_state == MMD_INFO) begin
                resp_rdata <= { OP_code, 9'h0, dev_addr };
                resp_ready <= info_en;
            end
            else if (next_state == ADDR_DATA) begin
                resp_rdata <= reg_addr;
                resp_ready <= info_en;
            end
            else if (next_state == RW_DATA) begin
                if (reg_if_ready) begin
                    resp_rdata <= reg_if_rdata;
                    resp_ready <= 1'b1;
                end
                else begin
                    resp_ready <= 1'b0;
                end
            end
        end
        else begin
            resp_ready <= 1'b0;
            resp_rdata <= 16'b0;
        end
    end

endmodule
