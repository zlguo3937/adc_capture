set collection_result_display_limit 9999999

#set_cdc_ignore_path -from [get_pins u_digital_top/u_top/core/u_gmii_xgmii_bridge/xgmii_tx_fifo/mem_reg/Q] -to_clock {"div5_clk_fm_PMA_CLK_1G"}
#set_cdc_ignore_path -from [get_pins u_digital_top/u_top/core/u_gmii_xgmii_bridge/xgmii_tx_fifo/fifo_full_reg/Q] -to_clock {"div5_clk_fm_PMA_CLK_1G" "div2_div5_clk_fm_PMA_CLK_1G"}
