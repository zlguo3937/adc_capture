`timescale 1ns/1ns
module jlsemi_util_and_cell
(
    input   a_i,
    input   b_i,
    output  z_o
);

assign z_o = a_i & b_i;

endmodule
