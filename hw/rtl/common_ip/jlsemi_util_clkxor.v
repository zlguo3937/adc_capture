module jlsemi_util_clkxor
(
    input         clk0_i,
    input         clk1_i,
    output        clk_o
);

    `ifdef JL_SYNTHESIS
        jlsemi_cell_clk_xor_cell
        u_dont_touch_clk_xor
        (
        .A1 (clk0_i),
        .A2 (clk1_i),
        .Z  (clk_o )
        );
    `else
        assign clk_o = clk1_i ^ clk0_i;
    `endif

endmodule
