# ---> user environment settings <---
if { [info exists synopsys_program_name] && $synopsys_program_name == "dc_shell" } {
    set over 0.7
} else {
    set over 1.0
}

set period_500 2.0
set period_200 5.0
set period_25  40
set PLL_jitter 0.05

set clk_period_500 [expr ${period_500} * $over]
set clk_period_200 [expr ${period_200} * $over]
set clk_period_25  [expr ${period_25}  * $over]

# 1---> adc_96_clk500
create_clock -name adc_96_clk500 -period ${clk_period_500} [get_pins u_analog_top/ADC_CLK500M] -add
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -fall_from adc_96_clk500 -rise_to adc_96_clk500 -setup
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -rise_from adc_96_clk500 -fall_to adc_96_clk500 -setup
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -fall_from adc_96_clk500 -rise_to adc_96_clk500 -hold
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -rise_from adc_96_clk500 -fall_to adc_96_clk500 -hold

# 2---> adc_48_clk500
create_clock -name adc_48_clk500 -period ${clk_period_500} [get_pins u_analog_top/ADC48_CLK500M] -add
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -fall_from adc_48_clk500 -rise_to adc_48_clk500 -setup
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -rise_from adc_48_clk500 -fall_to adc_48_clk500 -setup
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -fall_from adc_48_clk500 -rise_to adc_48_clk500 -hold
set_clock_uncertainty [expr $clk_period_500 * 0.05 + 0.03 + $PLL_jitter] -rise_from adc_48_clk500 -fall_to adc_48_clk500 -hold

# 3---> clk_200m
create_clock -name clk_200m -period ${clk_period_200} [get_pins u_analog_top/CLK200M] -add
set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.03 + $PLL_jitter] -fall_from clk_200m -rise_to clk_200m -setup
set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.03 + $PLL_jitter] -rise_from clk_200m -fall_to clk_200m -setup
set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.03 + $PLL_jitter] -fall_from clk_200m -rise_to clk_200m -hold
set_clock_uncertainty [expr $clk_period_200 * 0.05 + 0.03 + $PLL_jitter] -rise_from clk_200m -fall_to clk_200m -hold

# 4---> MDC
create_clock -name mdc -period ${clk_period_25} [get_ports PAD22_MDC] -add
set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.03 + $PLL_jitter] -fall_from mdc -rise_to mdc -setup
set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.03 + $PLL_jitter] -rise_from mdc -fall_to mdc -setup
set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.03 + $PLL_jitter] -fall_from mdc -rise_to mdc -hold
set_clock_uncertainty [expr $clk_period_25 * 0.05 + 0.03 + $PLL_jitter] -rise_from mdc -fall_to mdc -hold

# 5---> analog io constraints
set_output_delay -max [expr 1.235 * $over] -clock adc_96_clk500 [get_pins u_analog_top/ADC_DATA*] -add
set_output_delay -min [expr 0.836 * $over] -clock adc_96_clk500 [get_pins u_analog_top/ADC_DATA*] -add

set_output_delay -max [expr 1.235 * $over] -clock adc_48_clk500 [get_pins u_analog_top/ADC48_DATA*] -add
set_output_delay -min [expr 0.836 * $over] -clock adc_48_clk500 [get_pins u_analog_top/ADC48_DATA*] -add

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

# 9---> set io delay for ASIC pad    TODO
set_input_delay -max [expr 10 * $over] -clock mdc [get_ports PAD23_MDIO] -add
set_input_delay -min [expr 1  * $over] -clock mdc [get_ports PAD23_MDIO] -add

set_output_delay -max [expr ${clk_period_500} * 0.7] -clock adc_96_clk500 [get_ports PAD.*_ADC_DATA*] -add
set_output_delay -min [expr ${clk_period_500} * 0.1] -clock adc_96_clk500 [get_ports PAD.*_ADC_DATA*] -add
set_output_delay -max [expr ${clk_period_500} * 0.7] -clock adc_96_clk500 [get_ports PAD21_clk_RD] -add
set_output_delay -min [expr ${clk_period_500} * 0.1] -clock adc_96_clk500 [get_ports PAD21_clk_RD] -add
set_output_delay -max [expr 10 * $over] -clock mdc [get_ports PAD23_MDIO] -add
set_output_delay -min [expr 0  * $over] -clock mdc [get_ports PAD23_MDIO] -add

# 10---> set reset constraints for ASIC pad
set_false_path -from [get_ports PAD20_RSTN]

# ---> uncertainty: 0.01ns margin, 0.02ns cts jitter and 0.05ns PLL jitter
set_clock_uncertainty -setup [expr 0.01 + 0.02 + $PLL_jitter] [all_clocks]
set_clock_uncertainty -hold 0.01 [all_clocks]

# 11---> input transition & load
# data port
set_input_transition -max 0.25 [remove_from_collection [all_inputs] [list PAD22_MDC]]
set_input_transition -min 0    [remove_from_collection [all_inputs] [list PAD22_MDC]]
# clk port
set_input_transition -max 0.15 [list PAD22_MDC]
set_input_transition -min 0    [list PAD22_MDC]

set_load 10 [all_outputs]

# 12---> design rule
set_max_transition 0.25 [current_design]
set_max_transition 0.15 -clock [all_clocks]
