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
//  2023-10-20    zlguo         1.0         cpu_watchdog
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module cpu_watchdog
#(
    parameter   WIDTH = 16
)
(
    input   wire                clk,
    input   wire                rstn,

    input   wire                enable,
    input   wire                timer_done,
    input   wire    [WIDTH-1:0] cfg_reset_time,

    output  reg                 reset_cpu
);
    
    reg             timer_done_r;
    reg [WIDTH-1:0] maintain_reset_time;
    
    wire            timer_done_pulse;
    wire            maintain_time_done;

    assign  timer_done_pulse     =   timer_done & ~timer_done_r;
    assign  maintain_time_done   =   maintain_reset_time == cfg_reset_time;

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            timer_done_r <= 1'b0;
        else
            timer_done_r <= timer_done;
    end

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            maintain_reset_time <= {WIDTH{1'b0}};
        else if (maintain_time_done)
            maintain_reset_time <= {WIDTH{1'b0}};
        else if (reset_cpu)
            maintain_reset_time <= maintain_reset_time + 1'b1;
    end

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            reset_cpu <= 1'b0;
        else if (maintain_time_done)
            reset_cpu <= 1'b0;
        else if (enable & timer_done_pulse)
            reset_cpu <= 1'b1;
    end

endmodule
