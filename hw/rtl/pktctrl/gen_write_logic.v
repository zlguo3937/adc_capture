// Copyright (c) 2024 by JLSemi Inc.
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
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-05-06    zlguo         1.0         gen_write_logic
// --------------------------------------------------------------------
// --------------------------------------------------------------------
module gen_write_logic
(
    input   wire                clk,
    input   wire                rstn,
    input   wire                rf_capture_start,
    input   wire                write_en,
    output  reg     [15-1:0]    waddr,
    output  reg                 wr_done
);

    wire    write_en_sync;
    wire    capture_start_sync;

    jlsemi_util_sync_pos_with_rst_low
    u_sync_write_en
    (
    .clk        (clk                ),
    .rst_n      (rstn               ),
    .din        (write_en           ),
    .dout       (write_en_sync      )
    );

    jlsemi_util_sync_pos_with_rst_low
    u_sync_rf_capture_start
    (
    .clk        (clk                ),
    .rst_n      (rstn               ),
    .din        (rf_capture_start   ),
    .dout       (capture_start_sync )
    );

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            wr_done <= 1'b0;
        else if (capture_start_sync)
            wr_done <= 1'b0;
        else if (&waddr)
            wr_done <= 1'b1;
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            waddr <= 15'b0;
        else if (&waddr)
            waddr <= 15'b0;
        else if(write_en_sync)
            waddr <= waddr + 1'b1;
    end

endmodule
