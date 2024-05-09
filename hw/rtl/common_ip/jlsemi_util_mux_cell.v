module jlsemi_util_mux_cell
(
    input   a0_i,
    input   a1_i,
    input   sel_i,
    output  z_o
);

    `ifdef JL_SYNTHESIS
        jlsemi_cell_logic_mux_cell
        u_dont_touch_logic_mux
        (
        .I0 (a0_i ),
        .I1 (a1_i ),
        .S  (sel_i)
        .Z  (z_o  )
        );
    `else
        assign z_o = sel_i ? a1_i : a0_i;
    `endif

endmodule
