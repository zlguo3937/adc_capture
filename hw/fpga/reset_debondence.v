module reset_debouncer (
    input wire clk,
    input wire rstn_in,
    output reg rstn_out
);

    parameter DEBOUNCE_DELAY = 16;
    
    reg [DEBOUNCE_DELAY-1:0] shift_reg;
    
    always @(posedge clk or negedge rstn_in) begin
        if (!rstn_in) begin
            shift_reg <= {DEBOUNCE_DELAY{1'b0}};
        end else begin
            shift_reg <= {shift_reg[DEBOUNCE_DELAY-2:0], 1'b1};
        end
    end
    
    always @(posedge clk) begin
        if (shift_reg == {DEBOUNCE_DELAY{1'b1}}) begin
            rstn_out <= 1'b1;
        end else begin
            rstn_out <= 1'b0;
        end
    end

endmodule
