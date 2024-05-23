// ------------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//-------------------------------------------------------------------------
//  2024-02-08                  1.0         cdc_1clk_signal
// ------------------------------------------------------------------------
// ------------------------------------------------------------------------
`timescale 1ns/1ns
module cdc_1clk_signal
(
    input   clka,       //domain clk
    input   clkb,       //receive clk
    input   rstn_clka,
    input   rstn_clkb,
    input   sig_in,     //driven by domain clk
    output  sig_out     //driven by recive clk

);

    reg         sig_valid_clka;
    reg [2:0]   sig_cdc_clkb;
    reg [1:0]   sig_ack_clka;

    always @(posedge clka or negedge rstn_clka)
    begin
        if (!rstn_clka)
            sig_valid_clka <= 1'b0;
        else if (sig_ack_clka[1])
            sig_valid_clka <= 1'b0;
        else if (sig_in)
            sig_valid_clka <= 1'b1;
    end

    always @(posedge clkb or negedge rstn_clkb)
    begin
        if (!rstn_clkb)
            sig_cdc_clkb <= 3'b0;
        else
            sig_cdc_clkb <= {sig_cdc_clkb[1:0],sig_valid_clka};
    end

    always @(posedge clka or negedge rstn_clka)
    begin
        if (!rstn_clka)
            sig_ack_clka <= 2'b0;
        else
            sig_ack_clka <= {sig_ack_clka[0],sig_cdc_clkb[2]};
    end

    assign sig_out = sig_cdc_clkb[1] && (~sig_cdc_clkb[2]);

endmodule
