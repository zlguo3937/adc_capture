`timescale 1ns/1ns
module jlsemi_util_clkmux_sel1
(
input         clk0_i,
input         clk1_i,
input         sel_i,
input         dft_test_clk_en,
output        clk_o
);

wire sel_pre;

assign sel_pre = dft_test_clk_en ? 1'b1 : sel_i;

assign clk_o = sel_pre ? clk1_i : clk0_i;

endmodule
