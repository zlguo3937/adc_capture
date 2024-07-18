# ---> user settings <---
if { [info exists synopsys_program_name] && $synopsys_program_name == "dc_shell" } {
    set over 0.7
} else {
    set over 1.0
}

set period_500   2.0
set period_250   4.0
set period_200   5.0
set period_25    40
set period_v_500 2.0
set period_v_200 5.0
set PLL_jitter   0.05

set clk_period_500      [expr ${period_500} * $over]
set clk_period_250      [expr ${period_250} * $over]
set clk_period_200      [expr ${period_200} * $over]
set v_clk_period_500    [expr ${period_v_500} * $over]
set v_clk_period_200    [expr ${period_v_200} * $over]
set clk_period_25       [expr ${period_25}    * $over]



# 1---> create adc_96_clk500

# create adc_96_clk500
create_clock -name adc_96_clk500 -period ${clk_period_500} -waveform [list 0 [expr 0.5 * ${clk_period_500}]] [get_pins u_analog_top/ADC_CLK500M] -add
if { [info exists synopsys_program_name] && $synopsys_program_name == "pt_shell" } {
    set_clock_jitter -clock adc_96_clk500 -duty_cycle [expr ${clk_period_500} * 0.05]
    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -fall_from adc_96_clk500 -rise_to adc_96_clk500 -hold
    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -rise_from adc_96_clk500 -fall_to adc_96_clk500 -hold
} else {
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -fall_from adc_96_clk500 -rise_to adc_96_clk500 -setup
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -rise_from adc_96_clk500 -fall_to adc_96_clk500 -setup
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.01 + $PLL_jitter] -fall_from adc_96_clk500 -rise_to adc_96_clk500 -hold
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.01 + $PLL_jitter] -rise_from adc_96_clk500 -fall_to adc_96_clk500 -hold
}



# create adc_48_clk500
create_clock -name adc_48_clk500 -period ${clk_period_500} -waveform [list 0 [expr 0.5 * ${clk_period_500}]] [get_pins u_analog_top/ADC48_CLK500M] -add
if { [info exists synopsys_program_name] && $synopsys_program_name == "pt_shell" } {
    set_clock_jitter -clock adc_48_clk500 -duty_cycle [expr ${clk_period_500} * 0.05]
    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -fall_from adc_48_clk500 -rise_to adc_48_clk500 -hold
    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -rise_from adc_48_clk500 -fall_to adc_48_clk500 -hold
} else {
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -fall_from adc_48_clk500 -rise_to adc_48_clk500 -setup
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -rise_from adc_48_clk500 -fall_to adc_48_clk500 -setup
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.01 + $PLL_jitter] -fall_from adc_48_clk500 -rise_to adc_48_clk500 -hold
    set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.01 + $PLL_jitter] -rise_from adc_48_clk500 -fall_to adc_48_clk500 -hold
}



# 2---> generate_clock clk_rd_96, clk_rd_48

# generate clk_rd_96
create_generated_clock -name adc_96_clk500_mux1 -master_clock adc_96_clk500 -source [get_pins u_analog_top/ADC_CLK500M] -add \
        [get_pins u_digital_top/u_crg/u_clk_gen/u_clkmux_to_CLK500M/u_dont_touch_clkmux_mux/Z] -divide_by 1 -combinational

create_generated_clock -name clk_rd_96 -master_clock adc_96_clk500_mux1 -source [get_pins u_digital_top/u_crg/u_clk_gen/u_clkmux_to_CLK500M/u_dont_touch_clkmux_mux/Z] -add \
        [get_ports PAD21_CLK_RD] -divide_by 2


# generate clk_rd_48
create_generated_clock -name adc_48_clk500_mux0 -master_clock adc_48_clk500 -source [get_pins u_analog_top/ADC48_CLK500M] -add \
        [get_pins u_digital_top/u_crg/u_clk_gen/u_clkmux_to_CLK500M/u_dont_touch_clkmux_mux/Z] -divide_by 1 -combinational

create_generated_clock -name clk_rd_48 -master_clock adc_48_clk500_mux0 -source [get_pins u_digital_top/u_crg/u_clk_gen/u_clkmux_to_CLK500M/u_dont_touch_clkmux_mux/Z] -add \
        [get_ports PAD21_CLK_RD] -divide_by 2


set_clock_groups -physically_exclusive \
        -group { adc_96_clk500_mux1 clk_rd_96 }  \
        -group { adc_48_clk500_mux0 clk_rd_48 }



# 3---> clk_200m
create_clock -name clk_200m -period ${clk_period_200} -waveform [list 0 [expr 0.5 * ${clk_period_200}]] [get_pins u_analog_top/CLK200M] -add
if { [info exists synopsys_program_name] && $synopsys_program_name == "pt_shell" } {
    set_clock_jitter -clock clk_200m -duty_cycle [expr ${clk_period_500} * 0.05]
    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -fall_from clk_200m -rise_to clk_200m -hold
    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -rise_from clk_200m -fall_to clk_200m -hold
} else {
    set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.03 + $PLL_jitter] -fall_from clk_200m -rise_to clk_200m -setup
    set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.03 + $PLL_jitter] -rise_from clk_200m -fall_to clk_200m -setup
    set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.01 + $PLL_jitter] -fall_from clk_200m -rise_to clk_200m -hold
    set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.01 + $PLL_jitter] -rise_from clk_200m -fall_to clk_200m -hold
}



## 4---> MDC
#create_clock -name mdc -period ${clk_period_25} -waveform [list 0 [expr 0.5 * ${clk_period_25}]] [get_ports PAD22_MDC] -add
#if { [info exists synopsys_program_name] && $synopsys_program_name == "pt_shell" } {
#    set_clock_jitter -clock mdc -duty_cycle [expr ${clk_period_25} * 0.05]
#    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -fall_from mdc -rise_to mdc -hold
#    set_clock_uncertainty [expr 0.01 + $PLL_jitter] -rise_from mdc -fall_to mdc -hold
#} else {
#    set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.03 + $PLL_jitter] -fall_from mdc -rise_to mdc -setup
#    set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.03 + $PLL_jitter] -rise_from mdc -fall_to mdc -setup
#    set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.01 + $PLL_jitter] -fall_from mdc -rise_to mdc -hold
#    set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.01 + $PLL_jitter] -rise_from mdc -fall_to mdc -hold
#}

# virtual clock
create_clock -name mdc_v_clk       -period $v_clk_period_200 -waveform [list 0 [expr 0.5 * ${v_clk_period_200}]]
create_clock -name adc_96_v_clk500 -period $v_clk_period_500 -waveform [list 0 [expr 0.5 * ${v_clk_period_500}]]
create_clock -name adc_48_v_clk500 -period $v_clk_period_500 -waveform [list 0 [expr 0.5 * ${v_clk_period_500}]]
create_clock -name clk_v_200m      -period $v_clk_period_200 -waveform [list 0 [expr 0.5 * ${v_clk_period_200}]]


# set_clock_groups
set_clock_groups -name all_clock_group -asynchronous          \
        -group { adc_96_clk500 adc_96_clk500_mux1 clk_rd_96 adc_96_v_clk500 } \
        -group { adc_48_clk500 adc_48_clk500_mux0 clk_rd_48 adc_48_v_clk500 } \
        -group { clk_200m mdc_v_clk clk_v_200m }
#        -group { mdc }



# 5---> analog io constraints
set_input_delay -max [expr 1.235 * $over] -clock adc_96_clk500 [get_pins u_analog_top/ADC_DATA*] -add
set_input_delay -min [expr 0.836 * $over] -clock adc_96_clk500 [get_pins u_analog_top/ADC_DATA*] -add

set_input_delay -max [expr 1.235 * $over] -clock adc_48_clk500 [get_pins u_analog_top/ADC48_DATA*] -add
set_input_delay -min [expr 0.836 * $over] -clock adc_48_clk500 [get_pins u_analog_top/ADC48_DATA*] -add



## 6---> set max transition for analog input port
#if { [info exists synopsys_program_name] && $synopsys_program_name == "dc_shell" } {
#
#} else {
#set_max_capacitance 0.005 [list [get_pins u_analog_top/ADC_DATA*] [get_pins u_analog_top/ADC48_DATA*]]
#set_max_capacitance 0.005 [get_pins u_analog_top/ADC_CLK500M]
#set_max_capacitance 0.005 [get_pins u_analog_top/ADC48_CLK500M]
#set_max_capacitance 0.005 [get_pins u_analog_top/CLK200M]
#}



# 7---> set max capacitance for analog output port
if { [info exists synopsys_program_name] && $synopsys_program_name == "dc_shell" } {

} else {
set_max_capacitance 0.005 [list [get_pins u_analog_top/ADC_DATA*] [get_pins u_analog_top/ADC48_DATA*]]
set_max_capacitance 0.005 [get_pins u_analog_top/ADC_CLK500M]
set_max_capacitance 0.005 [get_pins u_analog_top/ADC48_CLK500M]
set_max_capacitance 0.005 [get_pins u_analog_top/CLK200M]
}



# 8---> set transition for analog output port
set_annotated_transition -max 0.04 [list [get_pins u_analog_top/ADC_DATA*] [get_pins u_analog_top/ADC48_DATA*]]
set_annotated_transition -min 0.00 [list [get_pins u_analog_top/ADC_DATA*] [get_pins u_analog_top/ADC48_DATA*]]
set_annotated_transition -max 0.04 [get_pins u_analog_top/ADC_CLK500M]
set_annotated_transition -min 0.00 [get_pins u_analog_top/ADC_CLK500M]
set_annotated_transition -max 0.04 [get_pins u_analog_top/ADC48_CLK500M]
set_annotated_transition -min 0.00 [get_pins u_analog_top/ADC48_CLK500M]
set_annotated_transition -max 0.04 [get_pins u_analog_top/CLK200M]
set_annotated_transition -min 0.00 [get_pins u_analog_top/CLK200M]



# 9---> set io delay for ASIC pad

# MDC + MDIO #######TODO
# sync mode ????????? TODO
#set_input_delay -max [expr 10 * $over] -clock mdc [get_ports PAD23_MDIO] -add
#set_input_delay -min [expr 1  * $over] -clock mdc [get_ports PAD23_MDIO] -add
#
#set_output_delay -max [expr 10 * $over] -clock mdc [get_ports PAD23_MDIO] -add
#set_output_delay -min [expr 0  * $over] -clock mdc [get_ports PAD23_MDIO] -add

###########################TODO

# async mode ????????? TODO
set mdio_mdc_max_delay_fm_sta 4
set mdio_max_delay_fm_phy 8.3

set_input_delay  0 -clock mdc_v_clk [get_ports PAD22_MDC] -add
set_input_delay  0 -clock mdc_v_clk [get_ports PAD23_MDIO] -add
set_output_delay 0 -clock mdc_v_clk [get_ports PAD23_MDIO] -add

#set_max_delay $mdio_mdc_max_delay_fm_sta -from mdc_v_clk -th [get_ports PAD22_MDC]  -to [get_pins u_digital_top/u_ctrl_sys/u_mdio/u_async_frontend_unit/mdc_cdc_out_0_reg/D]
#set_max_delay $mdio_mdc_max_delay_fm_sta -from mdc_v_clk -th [get_ports PAD23_MDIO] -to [get_pins u_digital_top/u_ctrl_sys/u_mdio/u_async_frontend_unit/mdio_cdc_out_0_reg/D]

#set_max_delay $mdio_max_delay_fm_phy -from [get_pins u_digital_top/u_ctrl_sys/u_mdio/u_async_frontend_unit/mdio_out_reg/CP] -th [get_ports PAD23_MDIO] -to mdc_v_clk
#set_max_delay $mdio_max_delay_fm_phy -from [get_pins u_digital_top/u_ctrl_sys/u_mdio/u_async_frontend_unit/mdio_oe_reg/CP]  -th [get_ports PAD23_MDIO] -to mdc_v_clk


# ADC_DATA + CLK_RD
set_output_delay -max [expr ${clk_period_250} * 0.7] -clock clk_rd_96 [get_ports *_ADC_DATA*] -add
set_output_delay -min [expr ${clk_period_250} * 0.1] -clock clk_rd_96 [get_ports *_ADC_DATA*] -add

set_output_delay -max [expr ${clk_period_250} * 0.7] -clock clk_rd_48 [get_ports *_ADC_DATA*] -add
set_output_delay -min [expr ${clk_period_250} * 0.1] -clock clk_rd_48 [get_ports *_ADC_DATA*] -add

set_multicycle_path -setup 2 -start -from adc_96_clk500_mux1 -to clk_rd_96
set_multicycle_path -hold  1 -start -from adc_96_clk500_mux1 -to clk_rd_96
set_multicycle_path -setup 2 -start -from adc_48_clk500_mux0 -to clk_rd_48
set_multicycle_path -hold  1 -start -from adc_48_clk500_mux0 -to clk_rd_48


# 10---> set reset constraints for ASIC pad
#set_false_path -from [get_ports PAD20_RSTN]
set_input_delay -max [expr ${clk_period_500} * 0.7] -clock adc_96_v_clk500 [get_ports PAD20_RSTN] -add
set_input_delay -min [expr ${clk_period_500} * 0.1] -clock adc_96_v_clk500 [get_ports PAD20_RSTN] -add

set_input_delay -max [expr ${clk_period_500} * 0.7] -clock adc_48_v_clk500 [get_ports PAD20_RSTN] -add
set_input_delay -min [expr ${clk_period_500} * 0.1] -clock adc_48_v_clk500 [get_ports PAD20_RSTN] -add

set_input_delay -max [expr ${clk_period_200} * 0.7] -clock clk_v_200m [get_ports PAD20_RSTN] -add
set_input_delay -min [expr ${clk_period_200} * 0.1] -clock clk_v_200m [get_ports PAD20_RSTN] -add



# 11---> uncertainty: 0.01ns margin, 0.02ns cts jitter and 0.05ns PLL jitter
set_clock_uncertainty -setup [expr 0.01 + 0.02 + $PLL_jitter] [all_clocks]
set_clock_uncertainty -hold 0.01 [all_clocks]



# 12---> input transition & load
# data port
# {5.0 * 0.3 = 1.5} """io.lib: input_transition_time/input_net_transition = 5.0"""
set_input_transition -max 1.5 [remove_from_collection [all_inputs] [list PAD22_MDC]]
set_input_transition -min 0   [remove_from_collection [all_inputs] [list PAD22_MDC]]



# clk port: {5.0 * 0.3 = 1.5} """io.lib: input_transition_time/input_net_transition = 5.0"""
set_input_transition -max 1.5 [list PAD22_MDC]
set_input_transition -min 0   [list PAD22_MDC]

set_load 10 [all_outputs]



# 13---> design rule
set_max_transition 0.25 [current_design]
set_max_transition 0.15 -clock [all_clocks]
