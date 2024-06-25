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
//  Date          By            Revision    Description
//---------------------------------------------------------------------
//  2023-10-06    zlguo         1.0         cpu_mdio_arbiter
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`timescale 1ns/1ns

module cpu_mdio_arbiter
#(
    parameter CFG_TIMEOUT = 16
)
(
    input   wire                            clk,
    input   wire                            rstn,
    input   wire    [CFG_TIMEOUT-1:0]       cfg_timeout,
    input   wire                            valid_0,
    input   wire                            valid_1,
    
    input   wire                            areq0,
    input   wire                            areq1,
    input   wire                            ack0,
    input   wire                            ack1,

    output  wire                            agrant0,
    output  wire                            agrant1,

);

    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            curr_sta <= 2'b00;
        else
            curr_sta <= next_sta;
    end

    always @(*)
    begin
        next_sta = 2'b00;
        case(curr_sta)
            IDLE:
                if (areq0)
                    next_sta = MASTER0;
                else if (areq1)
                    next_sta = MASTER1;

            MASTER0:
                if (req0_timeout)
                    next_sta = MASTER0_TIMEOUT;
                else if ()


