// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name : Zhiling Guo
//                     Email: zlguo@jlsemi.com
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2024-05-14    zlguo         1.0         synchronizer
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module synchronizer
#(
    parameter DATA_WIDTH = 16,
    parameter INIT_VALUE = {DATA_WIDTH{1'b0}}
)
(
    input   wire                        clk,
    input   wire                        rstn,
    input   wire    [DATA_WIDTH-1:0]    din,
    output  wire    [DATA_WIDTH-1:0]    dout

);
    genvar i;
    generate
        for (i=0; i<DATA_WIDTH; i=i+1) begin: SYNC_CELL

            `ifdef TSMC28HPC_PROCESS
                
            `elsif FPGA

                reg din_ff1;
                reg din_ff2;

                always @(posedge clk or negedge rstn) begin
                    if (!rstn) begin
                        din_ff1 <= 1'b0;
                        din_ff2 <= 1'b0;
                    end
                    else begin
                        din_ff1 <= din[i];
                        din_ff2 <= din_ff1;
                    end
                end

                assign dout[i] = din_ff2;

            `else

                reg din_ff1;
                reg din_ff2;

                always @(posedge clk or negedge rstn) begin
                    if (!rstn) begin
                        din_ff1 <= 1'b0;
                        din_ff2 <= 1'b0;
                    end
                    else begin
                        din_ff1 <= din[i];
                        din_ff2 <= din_ff1;
                    end
                end

                assign dout[i] = din_ff2;

            `endif

        end
    endgenerate

endmodule
