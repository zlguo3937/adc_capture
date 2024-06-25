module rom
(
    input   wire            clk,
    input   wire    [21:0]   addr,
    output  reg     [31:0]  rdata
);

    reg [31] ROM [21:0];

    always @(posedge clk)
        rdata <= ROM[addr];

endmodule
