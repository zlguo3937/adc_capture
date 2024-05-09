module jlsemi_util_clkmux_sel1
(
    input         clk0_i,
    input         clk1_i,
    input         sel_i,
    input         dft_test_clk_en,
    output        clk_o
);

    wire sel_pre;

    //assign sel_pre = dft_test_clk_en ? 1'b1 : sel_i;
    jlsemi_util_mux_cell
    u_dont_touch_clkmux_tie1_mux
    (
    .a0_i           (sel_i          ),
    .a1_i           (1'b1           ),
    .sel_i          (dft_test_clk_en),
    .z_o            (sel_pre        )
    );

    `ifdef JL_SYNTHESIS
        jlsemi_cell_clk_mux_cell
        u_dont_touch_clkmux_tie1_mux
        (
        .I0             (clk0_i         ),
        .I1             (clk1_i         ),
        .S              (sel_pre        ),
        .Z              (clk_o          )
        );
    `else
        assign clk_o = sel_pre ? clk1_i : clk0_i;
    `endif

endmodule
