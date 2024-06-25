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
//  2023-10-08    zlguo         1.0         mdio_converter_timer
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module mdio_converter_timer
(
    input   wire    clk,
    input   wire    rstn,
    input   wire    timer_en,
    input   wire    timer_clr,
    output  wire    timer_done
);

    reg [9:0]   timer_cnt;
    
    assign timer_done = timer_en & timer_cnt == 10'd1000;

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            timer_cnt <= 10'd0;
        else if (timer_en)
        begin
            if (timer_clr)
                timer_cnt <= 10'd0;
            else if (timer_done)
                timer_cnt <= 10'd0;
            else if (timer_cnt != 10'd1000)
                timer_cnt <= timer_cnt + 10'd1;
        end
        else
            timer_cnt <= 10'd0;
    end

endmodule
