# 1. Source the env variables
set current_path [pwd]
source -echo -verbose ${current_path}/config.tcl

setenv VCS_ENABLE_ASLR_SUPPORT 1

set currentTime [clock format [clock seconds] -format "%Y%m%d_%H%M"]
exec mkdir -p ${work}/${currentTime}_rdc

set rdc_path ${work}/${currentTime}_rdc

# 2. Setting to enable VC SpyGlass LINT flow
set_app_var enable_rdc true
set_app_var enable_dc_naming_style true
set_app_var bus_naming_style %s_%d

set check_path [sh dirname [pwd]]

set_app_var default_waiver_file ${WAIVER_PATH}/rdc_waiver.tcl


# 4. Design read

# black-box the module
# In a design that contains one or more black boxes, the black boxes are elaborated with the following implicit hardware:
#    Each input port of a black box is connected inside the corresponding module entity to one input of one implicit combinatorial gate (of undefined type).
#    Each output port of a black box is driven inside the corresponding module by one output of one implicit combinatorial gate (of undefined type).
#    Each inout port of a black box has both characteristics above as an input and an output port.
set_blackbox -designs {ANALOG_WRAPPER}

define_design_lib WORK -path ${work}/${currentTime}/VCS
analyze -format sverilog -vcs "+define+JL_SYNTHESIS -f $filelist"
elaborate $TOP_MODULE -verbose


# 5. Check LINT & Generates a verbose report
report_link

read_sdc -echo $sdc_file

source -echo -verbose ${WORK_PATH}/script/check_rdc/config_rdc.tcl

# Stage available in report_rdc cmd:
# all, corruption, debug_cause, debug_cluster, \
# integrity, setup, setupHier
set stage_rpt "all"

# Severity available in report_rdc cmd:
# fatal error warning, info
set severity_rpt "fatal error warning"

while {![file exists ${WAIVER_PATH}/rdc_waiver.tcl]} {
    exec touch ${WAIVER_PATH}/rdc_waiver.tcl
}
source -echo -verbose ${WAIVER_PATH}/rdc_waiver.tcl
#source -echo -verbose ${WAIVER_PATH}/user_waiver.tcl


check_rdc -type setup

while {![file exists ${REPORT_PATH}/report_rdc]} {
    exec mkdir -p ${REPORT_PATH}/report_rdc
}

report_rdc -list -limit 0 -severity $severity_rpt -stage "setup" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_setup_vio_sum.rpt
report_rdc -verbose -limit 0 -severity $severity_rpt -stage "setup" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_setup_vio_detail.rpt
report_rdc -verbose -limit 0 -severity "info" -stage "setup" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_setup_info_detail.rpt


check_rdc -type corruption

report_rdc -list -limit 0 -severity $severity_rpt -stage "corruption" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_corruption_vio_sum.rpt
report_rdc -verbose -limit 0 -severity $severity_rpt -stage "corruption" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_corruption_vio_detail.rpt
report_rdc -verbose -limit 0 -severity "info" -stage "corruption" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_corruption_info_detail.rpt


check_rdc -type conv

report_rdc -list -limit 0 -severity $severity_rpt -stage "conv" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_conv_vio_sum.rpt
report_rdc -verbose -limit 0 -severity $severity_rpt -stage "conv" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_conv_vio_detail.rpt
report_rdc -verbose -limit 0 -severity "info" -stage "conv" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_conv_info_detail.rpt


check_rdc -type glitch

report_rdc -list -limit 0 -severity $severity_rpt -stage "glitch" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_glitch_vio_sum.rpt
report_rdc -verbose -limit 0 -severity $severity_rpt -stage "glitch" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_glitch_vio_detail.rpt
report_rdc -verbose -limit 0 -severity "info" -stage "glitch" -file ${REPORT_PATH}/report_rdc/$TOP_MODULE.rdc_glitch_info_detail.rpt


report_violations -html

while {![file exists ${REPORT_PATH}/report_rdc]} {
    exec mkdir -p ${REPORT_PATH}/report_rdc
}
checkpoint_session -session ${rdc_path}/${TOP_MODULE}.rdc_session

# 6. Save the session setup and run data
#save_session -session lint_session

# To restore a saved session
# restore_session [-session lint_session]

# 7. Show results in GUI
view_activity
