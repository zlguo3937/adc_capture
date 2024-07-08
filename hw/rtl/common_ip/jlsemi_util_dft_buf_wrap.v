module jlsemi_util_dft_buf_wrap
(
    input   clk_in,
    output  clk_out
);

    `ifdef JL_SYNTHESIS
        jlsemi_cell_clk_buf_cell
        u_dont_touch_buf_clk
        (
        .I (clk_in ),
        .Z (clk_out)
        );
    `else
        assign clk_out = clk_in;
    `endif

endmodule
