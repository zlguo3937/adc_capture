// jlsemi_cell_logic_mux_cell
module jlsemi_cell_logic_mux_cell (
    input   wire    I0,
    input   wire    I1,
    input   wire    S,
    output  wire    Z
);

MUX2D2BWP40P140 U_DONT_TOUCH_DATA_MUX (
    .I0 (I0 ),
    .I1 (I1 ),
    .S  (S  ),
    .Z  (Z  )
);

endmodule

// jlsemi_cell_clk_buf_cell
module jlsemi_cell_clk_buf_cell (
    input   wire    I,
    output  wire    Z
);

CKBD2BWP40P140 U_DONT_TOUCH_CLK_BUF (
    .I  (I  ),
    .Z  (Z  )
);

endmodule

// jlsemi_cell_clk_mux_cell
module jlsemi_cell_clk_mux_cell (
    input   wire    I0,
    input   wire    I1,
    input   wire    S,
    output  wire    Z
);

CKMUX2D2BWP40P140 U_DONT_TOUCH_DATA_MUX (
    .I0 (I0 ),
    .I1 (I1 ),
    .S  (S  ),
    .Z  (Z  )
);

endmodule

// jlsemi_cell_clk_gating_cell
module jlsemi_cell_clk_gating_cell (
    input   wire    TE,
    input   wire    E,
    input   wire    CP,
    output  wire    Q
);

CKLNQD2BWP40P140 U_DONT_TOUCH_CLK_GATING (
    .TE (TE ),
    .E  (E  ),
    .CP (CP ),
    .Q  (Q  )
);

endmodule

module jlsemi_util_ff_cell_rst (
    input   wire    clk,
    input   wire    rst_n,
    input   wire    SI,
    input   wire    SE,
    output  wire    SO,

    input   wire    din,
    output  wire    dout
);

SDFCNQARD2BWP40P140 U_DONT_TOUCH_SYNC_REG (
    .CP (clk   ),
    .CDN(rst_n ),
    .SI (1'b0  ),
    .SE (1'b0  ),
    .D  (din   ),
    .Q  (dout  )
);

BUFFD20BWP40P140 U_DONT_TOUCH_BUF (
    .I  (1'b0  ),
    .Z  (SO    )
);

endmodule
