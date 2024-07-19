set collection_result_display_limit 9999999

configure_rdc_glitch -enable

configure_rdc_convergence -enable

configure_reset_propagation -allow_reset_overlap true

#configure_rdc_corrupt -skip_resetless_flop true

configure_rdc_nff_sync -enable

configure_rdc_tag -enable -tag *

#set_rdc_qualifier -cell {CKLNQD2BWP40P140}


#*********************************************************
#--> SYNC CELL
#*********************************************************
set_rdc_synchronizer -sync_cell {jlsemi_util_sync_pos_with_rst_low jlsemi_util_async_reset_low_sync}

configure_rdc_qualifier -allow_reset_order_on_qual true -allow_resetless_dest_on_qual true -allow_async_rst_as_qual true -allow_merged_qualifier true -allow_block_cell {CKMUX2D2BWP40P140 CKLNQD2BWP40P140 MUX2D2BWP40P140}


#*********************************************************
#--> PORT
#*********************************************************
configure_unconstrained_ports -input_model no_cross -output_model no_cross -use_inferred_domains -all_bbox



#*********************************************************
#--> RESET Order
#*********************************************************
#set_rdc_define_assertion_sequence -from_reset [get_object_name [get_pins -hierarchical *sw_rstn*]] -to_reset {u_analog_top_RSTB2DIG u_digital_top/ANA_RSTB2DIG u_digital_top/u_pin_mux/rst_n_shf_reg_8_/Q}


