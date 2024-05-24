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
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-04-23    zlguo         1.0         tb_ASIC
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`timescale 1ns/1ns

module tb_ASIC;

    reg     rstn;
    wire    RSTN;

    assign RSTN = rstn;

    initial
    begin
        `ifdef VPD_ON
            $vcdpluson();
        `endif
        $fsdbDumpfile("tb_ASIC.fsdb");
        $fsdbDumpvars("+all");
    end

    initial
    begin
        rstn = 0;
        #20;
        rstn = 1;
    end

    reg start;
    reg again;

    initial begin
        start = 0;
        again = 0;
        #41;
        start = 1;
        #6;
        start = 0;
        #500_000;
        //#30_000_000;
        //#22_500_000;
        //again = 1;
        //#5;
        //again = 0;
        //#500_000;
        $finish;
    end

    initial begin
        force ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_clk_en.cell_data = 1'b1;
        force ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_sw_rstn.cell_data = 1'b1;
        force ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_regfile_sw_rstn.cell_data = 1'b1;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_self_test_mode.cell_data = 1'b1;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_start.dev_rdata = start;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_again.dev_rdata = again;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_gap.cell_data = 8;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pkt_data_length.cell_data = 2; // 00-216type, 01-432type, 10-864type, 11-1728type
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pkt_idle_length.cell_data = 15;
    end

    ASIC
    ASIC
    (
    .PAD1_ADC_DATA_1        (),
    .PAD2_ADC_DATA_2        (),
    .PAD3_ADC_DATA_3        (),
    .PAD4_ADC_DATA_4        (),
    .PAD5_ADC_DATA_5        (),
    .PAD6_ADC_DATA_6        (),
    .PAD7_ADC_DATA_7        (),
    .PAD8_ADC_DATA_8        (),
    .PAD9_ADC_DATA_9        (),
    .PAD10_ADC_DATA_10      (),
    .PAD11_ADC_DATA_11      (),
    .PAD12_ADC_DATA_12      (),
    .PAD13_ADC_DATA_13      (),
    .PAD14_ADC_DATA_14      (),
    .PAD15_ADC_DATA_15      (),
    .PAD16_ADC_DATA_16      (),
    .PAD17_ADC_DATA_17      (),
    .PAD18_ADC_DATA_18      (),
    .PAD19_ADC_DATA_VALID   (),
    .PAD20_RSTN             (RSTN),
    .PAD21_CLK_RD           (),
    .PAD22_MDC              (),
    .PAD23_MDIO             ()
    );

endmodule
