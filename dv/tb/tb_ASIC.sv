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

    time next_display_time = 0;
    logic clk;

    reg [1:0]   rd_cnt;
    reg         start;
    reg         again;

    assign RSTN = rstn;

    initial
    begin
        `ifdef VPD_ON
            $vcdpluson();
        `endif
        //$fsdbDumpfile("tb_ASIC.fsdb");
        $fsdbAutoSwitchDumpfile(1000, "tb_ASIC.fsdb", 20, "fsdb_dump.log"); // auto spit waveform file
        $fsdbDumpvars("+all");
    end

    // --------------------------------------------------------------------
    // Display Memory address value to terminal: every 1ms display once
    // --------------------------------------------------------------------

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        next_display_time = 1ms;
    end

    initial
    begin
        rstn = 0;
        #20;
        rstn = 1;
    end

    initial begin
        rd_cnt= 0;
        start = 0;
        again = 0;
        #41;
        start = 1;
        #6;
        start = 0;
    end

    initial begin
        force ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_clk_en.cell_data = 1'b1;
        force ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_sw_rstn.cell_data = 1'b1;
        force ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_regfile_sw_rstn.cell_data = 1'b1;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_self_test_mode.cell_data = 1'b1;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_start.dev_rdata = start;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_capture_again.dev_rdata = again;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pktctrl_gap.cell_data = 4;
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pkt_data_length.cell_data = 1; // 00-216type, 01-432type, 10-864type, 11-1728type
        force tb_ASIC.ASIC.u_digital_top.u_ctrl_sys.u_top_regfile.u_rf_pkt_idle_length.cell_data = 0;
    end

    always @(posedge clk) begin
        if ($time >= next_display_time) begin
            $display("At time %.3f ms, Memory read address is %d", $time/1_000_000, tb_ASIC.ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.mem_addr);
            next_display_time = $time + 1ms;
        end
    end

    always @(posedge clk) begin
        if ((ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.u_gen_read_logic_fast.fast_rd_done == 1) && (ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.curr_sta == 1) && (rd_cnt == 0))
            rd_cnt  <= 1;
        else if ((ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.u_gen_read_logic_fast.fast_rd_done == 1) && (ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.curr_sta == 1) && (rd_cnt == 1))
            rd_cnt  <= 2;
    end

    always @(posedge clk) begin
        if ((ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.u_gen_read_logic_fast.fast_rd_done == 1) && (ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.curr_sta == 1) && (rd_cnt == 1))
            again <= 1;
        else if (again == 1)
            #10 again <= 0;
    end

    always @(posedge clk) begin
        if ((ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.u_gen_read_logic_fast.fast_rd_done == 1) && (ASIC.u_digital_top.u_pktctrl_top.u_package_ctrl.curr_sta == 1) && (rd_cnt == 2)) begin
            $display("=============================================================");
            $display("|                                                           |");
            $display("|                  Simulation Stopped!                      |");
            $display("|        Fast read done due to fast_read_done is 1'b1!      |");
            $display("|               Please check the ADC_DATA!                  |"); // TODO
            $display("|                                                           |");
            $display("=============================================================");
            #5000;
            $finish;
        end
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
