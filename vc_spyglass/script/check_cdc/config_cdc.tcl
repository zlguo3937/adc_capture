configure_cdc_nff_sync -depth 2

configure_cdc_tag -enable -tag *

configure_set_clock_group -enable true

#configure_cdc_tag -disable -tag SETUP_ASYNCRST_UDS_UNUSED


#*********************************************************
#--> SYNC CELL
#*********************************************************
configure_cdc_crossing -disable_clock_source_crossing true -disable_icg_cell true

configure_cdc_nff_sync -allowed_modules {synchronizer jlsemi_util_sync_pos_with_rst_low} -depth 2

configure_cdc_nff_sync -allow_quasi_static yes


#*********************************************************
#--> SYNC DATA
#*********************************************************
configure_cdc_data_sync -from_obj [get_pins u_digital_top/u_ctrl_sys/u_top_regfile/u_rf_capture_start/dev_rdata_reg/Q] -to_obj [get_pins u_digital_top/u_ctrl_sys/u_cdc_500_200/u_sync_rf_capture_start/dst_pulse] -des_qual [get_pins u_digital_top/u_ctrl_sys/u_cdc_500_200/u_sync_rf_capture_start/w_pulse_temp]


#*********************************************************
#--> RESET SYNC
#*********************************************************
configure_cdc_asyncrst_nff_sync -allowed_modules {jlsemi_util_async_reset_low_sync} -depth 2


#*********************************************************
#--> PORT
#*********************************************************
configure_unconstrained_ports -input_model no_cross -output_model no_cross -use_inferred_domains -all_bbox
#configure_unconstrained_ports -input_model virtual_diff_vector -output_model -use_inferred_domains -module ASIC


#*********************************************************
#--> CONVERGENCE
#*********************************************************
#configure_cdc_convergence -ignore_through_objects []


#*********************************************************
#--> GRAY SIGNAL
#*********************************************************
#set_gray_signals -gray_signals [get_pins u_digital_top/u_xxx/*ptr_reg/Q]
