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
//  2023-10-20    zlguo         1.0         cpu_timer
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module cpu_timer
#(
    parameter   WIDTH = 16
)
(
    input   wire                clk,
    input   wire                rstn,

    input   wire                enable,
    input   wire                clr,
    input   wire    [WIDTH-1:0] cfg_mat,

    input   wire                mode,
    input   wire                interval,

    output  wire                timer_done,
    output  reg     [WIDTH-1:0] timer_cnt
);
    
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            timer_cnt <= {WIDTH{1'b0}};
        else if (enable)
            begin
                if (clr)
                    timer_cnt <= {WIDTH{1'b0}};
                else if (mode & timer_done)
                    timer_cnt <= {WIDTH{1'b0}};
                else if (interval & timer_cnt != cfg_mat)
                    timer_cnt <= timer_cnt + 1'b1;
            end
        else
            timer_cnt <= {WIDTH{1'b0}};
    end

    assign  timer_done = enable & timer_cnt == cfg_mat;

endmodule
