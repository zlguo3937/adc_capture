set over 0.7

set period_500   2.0
set period_250   4.0
set period_200   5.0
set period_100   10.0
set period_25    40
set period_v_500 2.0
set period_v_200 5.0
set PLL_jitter   0.05

set clk_period_500      [expr ${period_500} * ${over}]
set clk_period_250      [expr ${period_250} * ${over}]
set clk_period_200      [expr ${period_200} * ${over}]
set clk_period_100      [expr ${period_100} * ${over}]
set v_clk_period_500    [expr ${period_v_500} * ${over}]
set v_clk_period_200    [expr ${period_v_200} * ${over}]
set clk_period_25       [expr ${period_25}    * ${over}]

# Create clock
create_clock -period ${clk_period_100} -name C_CLK_100M -waveform [list 0 [expr 0.5 * ${clk_period_100}]] [get_ports CLK_100M] -add
set_clock_uncertainty [expr $clk_period_100 * 0.05 + 0.03 + $PLL_jitter] -fall_from C_CLK_100M -rise_to C_CLK_100M -setup
set_clock_uncertainty [expr $clk_period_100 * 0.05 + 0.03 + $PLL_jitter] -rise_from C_CLK_100M -fall_to C_CLK_100M -setup
set_clock_uncertainty [expr $clk_period_100 * 0.05 + 0.01 + $PLL_jitter] -fall_from C_CLK_100M -rise_to C_CLK_100M -hold
set_clock_uncertainty [expr $clk_period_100 * 0.05 + 0.01 + $PLL_jitter] -rise_from C_CLK_100M -fall_to C_CLK_100M -hold

# Generate clock
create_generated_clock -name G_CLK_500M -master_clock C_CLK_100M -source [get_ports CLK_100M] -multiply_by 5 [get_pins u_clk_wiz_0/ADC_CLK500M] -add
create_generated_clock -name G_CLK_200M -master_clock C_CLK_100M -source [get_ports CLK_100M] -multiply_by 2 [get_pins u_clk_wiz_0/CLK200M] -add

create_generated_clock -name G_CLK_RD -master_clock C_CLK_100M -source [get_pins u_clk_wiz_0/ADC_CLK500M] -divide_by 2 [get_ports PAD21_CLK_RD] -add
        
# Virtual clock
create_clock -name C_V_CLK_MDC  -period 5 -waveform [list 0 [expr 0.5 * 5]]
create_clock -name C_V_CLK_200M -period 5 -waveform [list 0 [expr 0.5 * 5]]

#set_clock_groups -asynchronous -group [get_clocks C_CLK_100M] -group [get_clocks G_CLK_500M] -group [get_clocks G_CLK_RD]
set_clock_groups -name all_clock_group -asynchronous -group { C_CLK_100M G_CLK_500M G_CLK_RD } -group { G_CLK_200M C_V_CLK_MDC C_V_CLK_200M }


set_property ASYNC_REG true [get_cells u_digital_top/u_crg/u_asyncrstn_sync_to_pktctrl_rstn/rst_n_sync0_reg]
set_property ASYNC_REG true [get_cells u_digital_top/u_crg/u_asyncrstn_sync_to_pktctrl_rstn/rst_n_sync1_reg]
set_property ASYNC_REG true [get_cells u_digital_top/u_crg/u_asyncrstn_sync_to_rstn_200m/rst_n_sync0_reg]
set_property ASYNC_REG true [get_cells u_digital_top/u_crg/u_asyncrstn_sync_to_rstn_200m/rst_n_sync1_reg]


# ---> IO delay
set mdio_mdc_max_delay_fm_sta 4
set mdio_max_delay_fm_phy 8.3

set_input_delay  0 -clock C_V_CLK_MDC [get_ports PAD22_MDC]  -add
set_input_delay  0 -clock C_V_CLK_MDC [get_ports PAD23_MDIO] -add
set_output_delay 0 -clock C_V_CLK_MDC [get_ports PAD23_MDIO] -add

set_output_delay -max [expr ${clk_period_250} * 0.7] -clock G_CLK_RD [get_ports *_ADC_DATA*] -add
set_output_delay -min [expr ${clk_period_250} * 0.1] -clock G_CLK_RD [get_ports *_ADC_DATA*] -add

set_input_delay -max [expr ${clk_period_500} * 0.7] -clock C_CLK_100M [get_ports PAD20_RSTN] -add
set_input_delay -min [expr ${clk_period_500} * 0.1] -clock C_CLK_100M [get_ports PAD20_RSTN] -add


