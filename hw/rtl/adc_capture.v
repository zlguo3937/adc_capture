// --------------------------------------------------------------------
// Copyright (c) 2023 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name :
//                     Email:
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.0
//  Date          By            Revision    Change Description
//---------------------------------------------------------------------
//  2024-03-08                  1.0         adc_clk_rst_gen
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module adc_clk_rst_gen
(
    input  wire         ANA_CLK500M,
    input  wire         ANA_CLK200M,
    input  wire         ANA_RSTN,

    input  wire [2:0]   rf_regfile_div,
    input  wire [2:0]   rf_sramctrl_rclk_div,

    output wire         to_sramcrtl_rclk,
    output wire         

);

