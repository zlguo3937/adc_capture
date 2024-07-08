module jlsemi_util_clk_gate_cell
(
    input   clk_i,
    input   clk_en_i,
    input   dft_rtl_icg_en,
    output  clk_o
);

    `ifdef JL_SYNTHESIS
        jlsemi_cell_clk_gating_cell
        u_dont_touch_clk_gating
        (
        .TE (dft_rtl_icg_en ),
        .E  (clk_en_i       ),
        .CP (clk_i          )
        .Q  (clk_o          )
        );
    `else
        reg en_sync;
        always @(*)
            if(!clk_i)
                en_sync <= clk_en_i | dft_rtl_icg_en;
    
        assign clk_o = clk_i & en_sync;
    `endif

endmodule
