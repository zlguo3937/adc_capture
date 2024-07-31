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
//  2024-07-30    zlguo         1.0         FPGA_TOP
// --------------------------------------------------------------------
// --------------------------------------------------------------------
`timescale 1ns/1ns
module tb_FPGA_TOP;

    wire            PAD1_ADC_DATA_1;
    wire            PAD2_ADC_DATA_2;
    wire            PAD3_ADC_DATA_3;
    wire            PAD4_ADC_DATA_4;
    wire            PAD5_ADC_DATA_5;
    wire            PAD6_ADC_DATA_6;
    wire            PAD7_ADC_DATA_7;
    wire            PAD8_ADC_DATA_8;
    wire            PAD9_ADC_DATA_9;
    wire            PAD10_ADC_DATA_10;
    wire            PAD11_ADC_DATA_11;
    wire            PAD12_ADC_DATA_12;
    wire            PAD13_ADC_DATA_13;
    wire            PAD14_ADC_DATA_14;
    wire            PAD15_ADC_DATA_15;
    wire            PAD16_ADC_DATA_16;
    wire            PAD17_ADC_DATA_17;
    wire            PAD18_ADC_DATA_18;
    wire            PAD19_ADC_DATA_VALID;
    wire            PAD20_RSTN;
    wire            PAD21_CLK_RD;
    reg             PAD22_MDC;
    wire            PAD23_MDIO;
    wire            CLK_100M;

    reg         clk_100m;
    reg         rstn;
    reg         start;
    reg         again;

    initial
    begin
        `ifdef VPD_ON
            $vcdpluson();
        `endif
        //$fsdbDumpfile("tb_ASIC.fsdb");
        $fsdbAutoSwitchDumpfile(1000, "tb_ASIC.fsdb", 20, "fsdb_dump.log"); // auto spit waveform file
        $fsdbDumpvars("+all");
    end

    initial begin
        clk_100m = 0;
        forever begin
            #5 clk_100m = ~clk_100m;
        end
    end

    assign CLK_100M = clk_100m;

    initial
    begin
        rstn = 0;
        #5;
        rstn = 1;
        #5;
        rstn = 0;
        #5;
        rstn = 1;
        #5;
        rstn = 0;
        #40;
        rstn = 1;
    end

    assign PAD20_RSTN = rstn;


    initial begin
        start = 0;
        again = 0;
        #500;
        start = 1;
        #6;
        start = 0;
    end

    initial begin
        force FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_clk_en.cell_data = 1'b1;
        force FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_sw_rstn.cell_data = 1'b1;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_self_test_mode.cell_data = 1'b1;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_96path_en.cell_data = 1'b0;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_start.dev_rdata = start;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_again.dev_rdata = again;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_gap.cell_data = 4;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_phase.cell_data = 1;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pkt_data_length.cell_data = 1; // 00-216type, 01-432type, 10-864type, 11-1728type
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pkt_idle_length.cell_data = 1;
        #5ms;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_mode.cell_data = 1;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_mdio_data_sel.cell_data = 1;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_mdio_memory_addr.cell_data = 1;
        #100;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_mdio_data_sel.cell_data = 2;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_mdio_memory_addr.cell_data = 2;
        #100;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_mdio_data_sel.cell_data = 3;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_mdio_memory_addr.cell_data = 4;
        #500;
        force tb_FPGA_TOP.FPGA_TOP.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_mode.cell_data = 0;
        #5ms;
        $finish;
    end

    FPGA_TOP
    FPGA_TOP
    (
    .PAD1_ADC_DATA_1        (PAD1_ADC_DATA_1        ),
    .PAD2_ADC_DATA_2        (PAD2_ADC_DATA_2        ),
    .PAD3_ADC_DATA_3        (PAD3_ADC_DATA_3        ),
    .PAD4_ADC_DATA_4        (PAD4_ADC_DATA_4        ),
    .PAD5_ADC_DATA_5        (PAD5_ADC_DATA_5        ),
    .PAD6_ADC_DATA_6        (PAD6_ADC_DATA_6        ),
    .PAD7_ADC_DATA_7        (PAD7_ADC_DATA_7        ),
    .PAD8_ADC_DATA_8        (PAD8_ADC_DATA_8        ),
    .PAD9_ADC_DATA_9        (PAD9_ADC_DATA_9        ),
    .PAD10_ADC_DATA_10      (PAD10_ADC_DATA_10      ),
    .PAD11_ADC_DATA_11      (PAD11_ADC_DATA_11      ),
    .PAD12_ADC_DATA_12      (PAD12_ADC_DATA_12      ),
    .PAD13_ADC_DATA_13      (PAD13_ADC_DATA_13      ),
    .PAD14_ADC_DATA_14      (PAD14_ADC_DATA_14      ),
    .PAD15_ADC_DATA_15      (PAD15_ADC_DATA_15      ),
    .PAD16_ADC_DATA_16      (PAD16_ADC_DATA_16      ),
    .PAD17_ADC_DATA_17      (PAD17_ADC_DATA_17      ),
    .PAD18_ADC_DATA_18      (PAD18_ADC_DATA_18      ),
    .PAD19_ADC_DATA_VALID   (PAD19_ADC_DATA_VALID   ),
    .PAD20_RSTN             (PAD20_RSTN             ),
    .PAD21_CLK_RD           (PAD21_CLK_RD           ),
    .PAD22_MDC              (PAD22_MDC              ),
    .PAD23_MDIO             (PAD23_MDIO             ),
    .CLK_100M               (CLK_100M               )
    );

endmodule
