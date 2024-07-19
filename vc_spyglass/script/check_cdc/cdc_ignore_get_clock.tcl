set collection_result_display_limit 9999999

#set_cdc_ignore_path -from [get_pins u_digital_top/u_top/core/u_gmii_xgmii_bridge/xgmii_tx_fifo/mem_reg/Q] -to_clock [get_attribute [get_pins u_digital_top/u_top/core/u_gmii_xgmii_bridge/xgmii_tx_fifo/rclk] clocks]
