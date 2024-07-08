module jlsemi_util_and_cell
(
    input   a_i,
    input   b_i,
    output  z_o
);

    `ifdef JL_SYNTHESIS
        jlsemi_util_logic_and_sel
        u_dont_touch_logic_and
        (
        .A1 (a_i),
        .A2 (b_i),
        .Z  (z_o)
        );
    `else
        assign z_o = a_i & b_i;
    `endif

endmodule
