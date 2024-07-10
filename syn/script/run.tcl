# step 1 Read&elaborate the RTL file list & check
# =====================================================================================
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

# step 12 compile flow
# =====================================================================================
source $SCRIPT_PATH/adc_capture.sdc
compile -map_effort high -area_effort high -boundary_optimization

# step 11 wirte post_process files
# =====================================================================================
write -format verilog -hierarchy -output $MAPPED_PATH/outputsspi.v
write -format ddc -hier -o $MAPPED_PATH/outputsspi.ddc
write_sdc $MAPPED_PATH/outputsspi.sdc
write_sdf $MAPPED_PATH/outputsspi.sdf

# step 12generate report files
# =====================================================================================
report_timing -delay max $REPORT_PATH/reportsspi_setup_rt.rpt
report_timing -delay min $REPORT_PATH/reportsspi_hold_rt.rpt
report_constraint -verbose $REPORT_PATH/reportsspi_rc.rpt
