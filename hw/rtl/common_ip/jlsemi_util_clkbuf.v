`timescale 1ns/1ns
module jlsemi_util_clkbuf
(
    input         clk_i,
    output        clk_o
);

    `ifdef JL_SYNTHESIS
        jlsemi_cell_clk_buf_cell
        u_dont_touch_clk_buf
        (
        .I (clk_i),
        .Z (clk_o)
        );
    `else
        assign clk_o = clk_i;
    `endif

endmodule
