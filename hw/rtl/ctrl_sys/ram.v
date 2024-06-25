module ram
(
    input   wire            clk,
    input   wire            wen,
    input   wire    [21:0]   addr,
    input   wire    [31:0]  wdata,
    output  reg     [31:0]  rdata
);

    reg [31:0] RAM [0:21];

    always @(posedge clk)
        if(wen)
            RAM[addr] <= wdata;
    
    always @(posedge clk)
        if(!wen)
            rdata <= RAM[addr];


endmodule
