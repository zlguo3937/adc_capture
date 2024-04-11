`timescale 1ns/1ns
module jlsemi_util_async_reset_low_sync
(
    input   rst_n_i,
    input   clk_i,
    input   dft_rstnsync_scan_rstn_ctrl,
    input   dft_rstnsync_scan_rstn,
    output  rst_n_o
);

    wire  rst_n_pre;
    reg   rst_n_sync_pre;
    reg   rst_n_sync;

    assign rst_n_pre = dft_rstnsync_scan_rstn_ctrl ? dft_rstnsync_scan_rstn : rst_n_i;


    always @(posedge clk_i or negedge rst_n_pre)
    begin
        if(~rst_n_pre) begin
            rst_n_sync_pre  <= 1'b0;
            rst_n_sync      <= 1'b0;
        end
        else begin
            rst_n_sync_pre  <= 1'b1;
            rst_n_sync      <= rst_n_sync_pre;
        end
    end

    assign rst_n_o = dft_rstnsync_scan_rstn_ctrl ? dft_rstnsync_scan_rstn : rst_n_sync;

endmodule
