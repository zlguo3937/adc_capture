# 1. Source the env variables
set current_path [pwd]

###############################
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
setenv VCS_ENABLE_ASLR_SUPPORT 1
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
###############################

source ${current_path}/config.tcl

# 2. Setting to enable VC SpyGlass LINT flow
set_app_var enable_cdc true
set_app_var enable_resetless_analysis true
set_app_var enable_dc_naming_style true
set_app_var bus_naming_style %s_%d
set_app_var enable_viapoint_for_violations true
set_app_var enable_nested_hierarchy true

set check_path [sh dirname [pwd]]

set_app_var default_waiver_file ${WAIVER_PATH}/cdc_waiver.tcl


# 4. Design read

# black-box the module
# In a design that contains one or more black boxes, the black boxes are elaborated with the following implicit hardware:
#    Each input port of a black box is connected inside the corresponding module entity to one input of one implicit combinatorial gate (of undefined type).
#    Each output port of a black box is driven inside the corresponding module by one output of one implicit combinatorial gate (of undefined type).
#    Each inout port of a black box has both characteristics above as an input and an output port.
set_blackbox -designs {ANALOG_WRAPPER}

define_design_lib WORK -path ./WORK/VCS
analyze -format sverilog -vcs "+define+JL_SYNTHESIS -f $filelist"
elaborate $TOP_MODULE -verbose

# 5. Check LINT & Generates a verbose report
report_link

read_sdc -echo $sdc_file

source -echo -verbose ${WORK_PATH}/script/check_cdc/config_cdc.tcl

# Stage available in report_cdc cmd:
# SETUP, SYNC, CONV, GLITCH, SETUPHIER, \
# INTEGRITY, DEBUG_CAUSE, DEBUG_CLUSTER, RC_DEBUG
set stage_rpt "SETUP SYNC CONV GLITCH INTEGRITY"

# Severity available in report_cdc cmd: fatal error warning, info
set severity_rpt "fatal error warning"

while {![file exists ${WAIVER_PATH}/cdc_waiver.tcl]} {
    exec touch ${WAIVER_PATH}/cdc_waiver.tcl
}
source -echo -verbose ${WAIVER_PATH}/cdc_waiver.tcl
#source -echo -verbose ${WAIVER_PATH}/user_waiver.tcl

source -echo -verbose ${WORK_PATH}/script/check_cdc/cdc_ignore.tcl

check_cdc -type setup

while {![file exists ${REPORT_PATH}/report_cdc]} {
    exec mkdir -p ${REPORT_PATH}/report_cdc
}

report_cdc -list -limit 0 -severity $severity_rpt -stage "SETUP" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_setup_vio_sum.rpt
report_cdc -verbose -limit 0 -severity $severity_rpt -stage "SETUP" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_setup_vio_detail.rpt
report_cdc -verbose -limit 0 -severity "info" -stage "SETUP" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_setup_info_detail.rpt

check_cdc -type integ

report_cdc -list -limit 0 -severity $severity_rpt -stage "INTEGRITY" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_integ_vio_sum.rpt
report_cdc -verbose -limit 0 -severity $severity_rpt -stage "INTEGRITY" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_integ_vio_detail.rpt
report_cdc -verbose -limit 0 -severity "info" -stage "INTEGRITY" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_integ_info_detail.rpt

check_cdc -type sync

report_cdc -list -limit 0 -severity $severity_rpt -stage "SYNC" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_sync_vio_sum.rpt
report_cdc -verbose -limit 0 -severity $severity_rpt -stage "SYNC" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_sync_vio_detail.rpt
report_cdc -verbose -limit 0 -severity "info" -stage "SYNC" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_sync_info_detail.rpt

check_cdc -type struct

report_cdc -list -limit 0 -severity $severity_rpt -stage "CONV GLITCH" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_struct_vio_sum.rpt
report_cdc -verbose -limit 0 -severity $severity_rpt -stage "CONV GLITCH" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_struct_vio_detail.rpt
report_cdc -verbose -limit 0 -severity "info" -stage "CONV GLITCH" -file ${REPORT_PATH}/report_cdc/$TOP_MODULE.cdc_struct_info_detail.rpt

report_violations -html

set currentTime [clock format [clock seconds] -format "%Y%m%d_%H%M"] 
exec mkdir -p ${work}/${currentTime}

checkpoint_session -session ${work}/${currentTime}/${TOP_MODULE}.cdc_session

# 6. Save the session setup and run data
#save_session -session lint_session

# To restore a saved session
# restore_session [-session lint_session]

# 7. Show results in GUI
view_activity
