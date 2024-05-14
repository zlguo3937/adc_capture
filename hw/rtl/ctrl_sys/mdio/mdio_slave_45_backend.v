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
//  2024-02-08                  1.0         mdio_slave_45_backend
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------

module mdio_slave_45_backend
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

    output  reg     [20:0]  reg_if_addr,
    output  reg     [15:0]  reg_if_wdata,
    output  reg             reg_if_valid,
    output  reg             reg_if_we,

    output  reg     [15:0]  resp_rdata,
    output  reg             resp_ready

);

    localparam  IDLE = 2'd0,
                ADDR = 2'd1,
                DATA = 2'd2;

    reg     [1:0]   state;
    reg     [1:0]   next_state;

    reg     [15:0]  info;
    reg             info_en;
    reg             data_en;
    reg     [4:0]   dev_addr;
    reg     [15:0]  reg_addr;
    reg     [1:0]   OP_code;

    wire            addr_op;
    wire            wr_op;
    wire            rd_op;
    wire            read_incr;

    assign addr_op      = in_info[11:10] == 2'b00;
    assign wr_op        = in_info[11:10] == 2'b01;
    assign rd_op        = in_info[11:10] == 2'b11;
    assign read_incr    = in_info[11:10] == 2'b10;

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            info    <= 14'b0;
            info_en <= 1'b0;
        end
        else if (!enable) begin
            info    <= 14'b0;
            info_en <= 'b0;
        end
        else if (in_info_en) begin
            info    <= in_info;
            info_en <= 1'b1;
        end
        else begin
            info    <= info;
            info_en <= 1'b0;
        end
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n)
            data_en <= 1'b0;
        else if (!enable)
            data_en <= 1'b0;
        else if (in_data_en)
            data_en <= 1'b1;
        else
            data_en <= 1'b0;
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
            IDLE :
                if (in_info_en && addr_op)
                    next_state = ADDR; // first frame must be addr
                else
                    next_state = IDLE;
    
            ADDR :
                if ((wr_op || rd_op || read_incr) && in_info_en)
                    next_state = DATA;
                else
                    next_state = ADDR;
    
            DATA :
                if (in_info_en) begin
                    if (addr_op)
                        next_state = ADDR;
                    else
                        next_state = DATA;
                end
                else
                    next_state = DATA;
    
            default : next_state = IDLE;
        endcase
    end

    always @(posedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            reg_if_addr     <= 21'b0;
            reg_if_valid    <=  1'b0;
            reg_if_wdata    <= 16'b0;
            reg_if_we       <=  1'b0;
            dev_addr        <=  5'b0;
            reg_addr        <= 16'b0;
        end
        else
        begin
            case (state)
                IDLE:
                    begin
                        reg_if_addr     <= 21'b0;
                        reg_if_valid    <=  1'b0;
                        reg_if_wdata    <= reg_if_wdata;
                        reg_if_we       <=  1'b0;
                        dev_addr        <=  5'b0;
                        reg_addr        <= 16'b0;
                    end

                ADDR:
                    begin
                        if (info_en)
                            dev_addr <= info[4:0];
                        else if (in_data_en)
                            reg_addr <= in_data[15:0];
                        else if (data_en) begin
                            reg_if_addr  <= { dev_addr, reg_addr };
                            reg_if_valid <= 1'b1;
                        end
                        else
                            reg_if_valid <= 1'b0;
                    end

                DATA:
                    begin
                        if (wr_op) begin
                            if (in_data_en) begin
                                reg_if_valid <= 1'b1;
                                reg_if_we    <= 1'b1;
                                reg_if_wdata <= in_data;
                            end
                            else begin
                                reg_if_valid <= 1'b0;
                                reg_if_we    <= 1'b0;
                            end
                        end
                        else if (read_incr) begin
                            if (data_en) begin
                                reg_if_valid <= 1'b1;
                                reg_if_addr  <= reg_if_addr + 1'd1;
                            end
                            else begin
                                reg_if_valid <= 1'b0;
                            end
                        end
                    end

                default:
                    begin
                        reg_if_addr     <= 21'b0;
                        reg_if_valid    <=  1'b0;
                        reg_if_wdata    <= 16'b0;
                        reg_if_we       <=  1'b0;
                        dev_addr        <=  5'b0;
                        reg_addr        <= 16'b0;
                    end
            endcase
        end
    end

    always @(negedge clk_25m or negedge rst_n)
    begin
        if (!rst_n) begin
            resp_rdata <= 16'b0;
            resp_ready <= 1'b0;
        end
        else if (!enable) begin
            resp_rdata <= 16'b0;
            resp_ready <= 1'b0;
        end
        else if (reg_if_ready) begin
            resp_rdata <= reg_if_rdata;
            resp_ready <= 1'b1;
        end
        else begin
            resp_ready <= 1'b0;
        end
    end

endmodule
