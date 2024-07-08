`timescale 1ns/1ns
module jlsemi_util_sync_pos_with_rst_low
#(
    parameter SYNC_STEP = 2
)(
    input         clk,
    input         rst_n,
    input         din,
    output        dout
);

    `ifdef JL_SYNTHESIS
        `ifdef USE_MBFF_AS_SYNC
            generate
                if (SYNC_STEP == 2) begin
                    jlsemi_cell_mbff2_w_rst_low_cell
                    u_dont_touch_mbff2_w_rst_low
                    (
                    .clk    (clk    ),
                    .rst_n  (rst_n  ),
                    .SI     (1'b0   ),
                    .SE     (1'b0   ),
                    .SO     (       ),
                    .din    (din    ),
                    .dout   (dout   )
                    );
                end else if (SYNC_STEP == 3) begin
                    jlsemi_cell_mbff3_w_rst_low_cell
                    u_dont_touch_mbff3_w_rst_low
                    (
                    .clk    (clk    ),
                    .rst_n  (rst_n  ),
                    .SI     (1'b0   ),
                    .SE     (1'b0   ),
                    .SO     (       ),
                    .din    (din    ),
                    .dout   (dout   )
                    );
                end else begin

                end
            endgenerate
        `else
            wire [SYNC_STEP:0] data_temp;
            assign data_temp[0]= din;
            genvar i;
            generate
                for (i=0; i<SYNC_STEP;i=i+1) begin: SYNC_STEP_UNIT
                    jlsemi_util_ff_cell_rst
                    u_dont_touch_sync_ff_cell
                    (
                    .clk    (clk            ),
                    .rst_n  (rst_n          ),
                    .SI     (1'b0           ),
                    .SE     (1'b0           ),
                    .SO     (               ),
                    .din    (data_temp[i]   ),
                    .dout   (data_temp[i+1] )
                    );
                end
            endgenerate
            assign dout = data_temp[SYNC_STEP];
        `endif
    `else
        reg [SYNC_STEP-1:0] din_ff;

        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                din_ff[0] <= 1'b0;
            end
            else begin
                din_ff[0] <= din;
            end
        end

        genvar i;
        generate
            for (i=1; i<SYNC_STEP;i=i+1) begin: SYNC_STEP_UNIT
                always @(posedge clk or negedge rst_n) begin
                    if(!rst_n) begin
                        din_ff[i] <= 1'b0;
                    end
                    else begin
                        din_ff[i] <= din_ff[i-1];
                    end
                end
            end
            assign dout = din_ff[SYNC_STEP-1];
        endgenerate
    `endif

endmodule
