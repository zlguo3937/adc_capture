set proj_name "adc_capture"
set work_dir [pwd]

#**********************************************************************************************************
create_project -force $proj_name $work_dir/$proj_name -part xc7a75tfgg484-2
# Create 'sources_1' fileset (if not found)；file mkdir ip, new, bd
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
file mkdir $work_dir/$proj_name/$proj_name.srcs/sources_1/ip
file mkdir $work_dir/$proj_name/$proj_name.srcs/sources_1/new
file mkdir $work_dir/$proj_name/$proj_name.srcs/sources_1/bd
# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
file mkdir $work_dir/$proj_name/$proj_name.srcs/constrs_1/new
# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
file mkdir $work_dir/$proj_name/$proj_name.srcs/sim_1/new

#**********************************************************************************************************
# update RTL source
add_files -norecurse {  /local/zlguo/prj/adc_capture/hw/rtl/top/DIGITAL_WRAPPER.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/analog_signal_mux.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/ASIC.v \
						/local/zlguo/prj/adc_capture/hw/rtl/clk_rst_gen/clk_gen.v \
						/local/zlguo/prj/adc_capture/hw/rtl/clk_rst_gen/rst_gen.v \
						/local/zlguo/prj/adc_capture/hw/rtl/clk_rst_gen/crg.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/pulse_handshake.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/multi_handshake.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/synchronizer.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_async_reset_low_sync.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_sync_pos_with_rst_low.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkdiv_even_with_cfg.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkdiv_even_with_phase.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkgate.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkmux_sel1.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkbuf.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_and_cell.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_mux_cell.v \
						/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_logic_cell.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/ctrl_sys.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/cdc_500_200.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_top.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_slave_45_backend.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/watchdog_mdio.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_slave_22_45_frontend_async.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_slave_22_45_frontend_sync.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_slave_22_backend.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/cdc_1clk_signal.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/cdc_200m_100m.v \
						/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_slave_22_45_backend.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/iopad_top.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/iopad_pdu_inst.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/iopad_pdd_inst.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/pktctrl_top.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/package_ctrl.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/gen_write_logic.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/gen_read_logic_mdio.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/gen_read_logic_fast.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/package_gen.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/package_data_sel.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/memory_wrapper.v \
						/local/zlguo/prj/adc_capture/hw/rtl/pktctrl/memory_inst.v \
						/local/zlguo/prj/adc_capture/hw/rtl/analog/ANALOG_WRAPPER.sv \
						/local/zlguo/prj/adc_capture/hw/rtl/top/analog_signal_mux.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/DIGITAL_WRAPPER.v \
						/local/zlguo/prj/adc_capture/hw/rtl/top/ASIC.v \
						/local/zlguo/prj/adc_capture/builds/verilog/top_regfile.v \
						/local/zlguo/prj/adc_capture/hw/fpga/reset_debondence.v
}

update_compile_order -fileset sources_1

#**********************************************************************************************************
# set define FPGA
set_property verilog_define FPGA [current_fileset]
update_compile_order -fileset sources_1

remove_files  { /local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/cdc_200m_100m.v \
		        /local/zlguo/prj/adc_capture/hw/rtl/clk_rst_gen/clk_gen.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkdiv_even_with_cfg.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkdiv_even_with_phase.v \
				/local/zlguo/prj/adc_capture/hw/rtl/clk_rst_gen/rst_gen.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_logic_cell.v \
				/local/zlguo/prj/adc_capture/hw/rtl/top/iopad_pdd_inst.v \
				/local/zlguo/prj/adc_capture/hw/rtl/top/iopad_pdu_inst.v \
				/local/zlguo/prj/adc_capture/hw/rtl/analog/ANALOG_WRAPPER.sv \
				/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/mdio_slave_22_45_frontend_sync.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkgate.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkmux_sel1.v \
				/local/zlguo/prj/adc_capture/hw/rtl/ctrl_sys/mdio/cdc_1clk_signal.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_and_cell.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_clkbuf.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_async_reset_low_sync.v \
				/local/zlguo/prj/adc_capture/hw/rtl/common_ip/jlsemi_util_mux_cell.v \
}
update_compile_order -fileset sources_1

#**********************************************************************************************************
# create_ip clk_wiz
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0
set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT3_USED {true} CONFIG.PRIMARY_PORT {CLK_100M} CONFIG.CLK_OUT1_PORT {ADC_CLK500M} CONFIG.CLK_OUT2_PORT {ADC48_CLK500M} CONFIG.CLK_OUT3_PORT {CLK200M} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {500.000} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {500.000} CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200.000} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.MMCM_CLKOUT0_DIVIDE_F {2.000} CONFIG.MMCM_CLKOUT1_DIVIDE {2} CONFIG.MMCM_CLKOUT2_DIVIDE {5} CONFIG.NUM_OUT_CLKS {3} CONFIG.RESET_PORT {resetn} CONFIG.CLKOUT1_JITTER {97.082} CONFIG.CLKOUT2_JITTER {97.082} CONFIG.CLKOUT2_PHASE_ERROR {98.575} CONFIG.CLKOUT3_JITTER {114.829} CONFIG.CLKOUT3_PHASE_ERROR {98.575}] [get_ips clk_wiz_0]

generate_target {instantiation_template} [get_files /local/zlguo/prj/adc_capture/fpga/adc_capture/adc_capture.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]

generate_target all [get_files  /local/zlguo/prj/adc_capture/fpga/adc_capture/adc_capture.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]

catch { config_ip_cache -export [get_ips -all clk_wiz_0] }

create_ip_run [get_files -of_objects [get_fileset sources_1] /local/zlguo/prj/adc_capture/fpga/adc_capture/adc_capture.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]

launch_runs clk_wiz_0_synth_1 -jobs 8

update_compile_order -fileset sources_1

#**********************************************************************************************************
# create_ip blk_mem_gen 32768x36
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name blk_mem_gen_0

set_property -dict [list CONFIG.Write_Width_A {36} CONFIG.Write_Depth_A {32768} CONFIG.Read_Width_A {36} CONFIG.Write_Width_B {36} CONFIG.Read_Width_B {36}] [get_ips blk_mem_gen_0]

generate_target {instantiation_template} [get_files /local/zlguo/prj/adc_capture/fpga/adc_capture/adc_capture.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci]

generate_target all [get_files  /local/zlguo/prj/adc_capture/fpga/adc_capture/adc_capture.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci]

catch { config_ip_cache -export [get_ips -all blk_mem_gen_0] }

create_ip_run [get_files -of_objects [get_fileset sources_1] /local/zlguo/prj/adc_capture/fpga/adc_capture/adc_capture.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci]

launch_runs blk_mem_gen_0_synth_1 -jobs 8

update_compile_order -fileset sources_1
