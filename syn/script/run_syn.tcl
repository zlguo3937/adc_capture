# step 1 Read&elaborate the RTL file list & check
# =====================================================================================

set currentTime [clock format [clock seconds] -format "%Y%m%d_%H%M"]
exec mkdir -p ${REPORT_PATH}/${currentTime}_syn
set REPS_PATH ${REPORT_PATH}/${currentTime}_syn


set TOP_MODULE ASIC


analyze -format sverilog -vcs "-f $file_list" -define JL_SYNTHESIS
#elaborate $TOP_MODULE  -architecture sverilog
elaborate $TOP_MODULE

current_design $TOP_MODULE


if {[link] == 0} {
     echo link with error!;
      exit;
}


if {[check_design] == 0} {
     echo check design with error! ;
      exit;
}


# step 2 reset the design first
# =====================================================================================
reset_design 


# step 3 write the unmapped ddc file 
# =====================================================================================
uniquify
set uniquify_naming_style %s_%d
write -f ddc -hierarchy -output ${UNMAPPED_PATH}/${TOP_MODULE}.ddc
write -format verilog -hierarchy -output ${UNMAPPED_PATH}/${TOP_MODULE}.v

define_name_rules verilog -preserve_struct_ports
change_names -rules verilog -hier -log_changes ${REPS_PATH}/${TOP_MODULE}.precompile.change_name.rpt

# step 12 compile flow
# =====================================================================================
source $SCRIPT_PATH/adc_capture.sdc
#---> dont_touch
set_dont_touch          [get_cells -hier *dont_touch*] true
set_dont_touch          [get_cells -hier *DONT_TOUCH*] true
set_dont_touch_network  [remove_from_collection [all_clocks] [list mdc_v_clk adc_96_v_clk500 adc_48_v_clk500 clk_v_200m]]
#set_dont_touch_network  [all_clocks]

check_design > $REPS_PATH/${TOP_MODULE}.check_design_precompile.rpt

#compile -map_effort high -area_effort high -boundary_optimization
compile_ultra -incr -scan -no_autoungroup -no_seq_output_inversion -no_boundary_optimization

optimize_netlist -area

change_names -rules verilog -hier


# step 11 wirte post_process files
# =====================================================================================
write -format verilog -hierarchy -output $MAPPED_PATH/${TOP_MODULE}.v
write -format ddc -hier -out $MAPPED_PATH/${TOP_MODULE}.ddc
write_sdc $MAPPED_PATH/${TOP_MODULE}.sdc
write_sdf $MAPPED_PATH/${TOP_MODULE}.sdf

saif_map -type ptpx -write_map $REPS_PATH/${TOP_MODULE}.mapped.SAIF.namemap

set_svf -off
set_vsdc -off


# step 12 generate report files
# =====================================================================================
redirect -tee -file $REPS_PATH/precompile.rpt {link}
#redirect -append -tee -file $REPORT_PATH/precompile.rpt {check_timing}
redirect -tee -file $REPS_PATH/${TOP_MODULE}.check_design_compiled.rpt {check_design}
redirect -tee -file $REPS_PATH/${TOP_MODULE}.echo_sdc.rpt {source -echo -ver $SCRIPT_PATH/adc_capture.sdc}
redirect -tee -file $REPS_PATH/${TOP_MODULE}.port.rpt {report_port -verbose}
redirect -tee -file $REPS_PATH/${TOP_MODULE}.clocks.rpt {report_clock *}
redirect -tee -file $REPS_PATH/${TOP_MODULE}.clock_groups.rpt {report_clock -groups}
#redirect -tee -file $REPS_PATH/${TOP_MODULE}.clock_skew.rpt {report_clock skew}
redirect -tee -file $REPS_PATH/${TOP_MODULE}.check_timing.rpt {check_timing}
report_timing -from [all_inputs]                -to [all_outputs]              -max 100 -cap -transition -net -input_pins -nosplit > ${REPS_PATH}/${TOP_MODULE}.IN2OUT.rpt
report_timing -from [all_inputs]                -to [all_registers -data_pins] -max 100 -cap -transition -net -input_pins -nosplit > ${REPS_PATH}/${TOP_MODULE}.IN2REG.rpt
report_timing -from [all_registers -clock_pins] -to [all_registers -data_pins] -max 100 -cap -transition -net -input_pins -nosplit > ${REPS_PATH}/${TOP_MODULE}.REG2REG.rpt
report_timing -from [all_registers -clock_pins] -to [all_outputs]              -max 100 -cap -transition -net -input_pins -nosplit > ${REPS_PATH}/${TOP_MODULE}.REG2OUT.rpt


redirect -tee -file ${REPS_PATH}/${TOP_MODULE}.constraint.rpt {report_constraint -verbose}
redirect -tee -file ${REPS_PATH}/${TOP_MODULE}.setup.rpt {report_timing -delay max}
redirect -tee -file ${REPS_PATH}/${TOP_MODULE}.hold.rpt {report_timing -delay min}

report_timing -loop -max 100                 > ${REPS_PATH}/${TOP_MODULE}.loop.rpt
report_constraint -all_violators -nosplit    > ${REPS_PATH}/all_violation.rpt
report_qor                                   > ${REPS_PATH}/${TOP_MODULE}.qor.rpt
report_clock_gating -gated -ungated -nosplit > ${REPS_PATH}/${TOP_MODULE}.clock_gating.rpt
report_area                                  > ${REPS_PATH}/${TOP_MODULE}.area.rpt
report_power -hier                           > ${REPS_PATH}/${TOP_MODULE}.power.rpt
report_area -hier -nosplit                   > ${REPS_PATH}/${TOP_MODULE}.hier_area.rpt
report_timing -cap -transition -nets -input_pins -delay_type max -slack_lesser_than 0 -nworst 1 -max_paths 20000 -significant_digits 4 -nosplit > ${REPS_PATH}/${TOP_MODULE}.max_timing.rpt

