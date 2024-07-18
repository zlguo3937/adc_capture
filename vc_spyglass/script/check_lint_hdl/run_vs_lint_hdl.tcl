# 1. Source the env variables
set current_path [pwd]
source ${current_path}/config.tcl

# 2. Setting to enable VC SpyGlass LINT flow
set enable_lang_checker true
set check_path [sh dirname [pwd]]

# use absolute path so that wherever the session is oppend, the waiver file can be written
set_app_var default_waiver_file ${WAIVER_PATH}/lint_hdl_waiver.tcl



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

source -echo -verbose ${WORK_PATH}/script/check_lint_hdl/config_lint_hdl.tcl

# Stage available in report_hdl cmd: Builtin_Check, Custom, Debug_Cause, Debug_Cluster, Language_Check, \
# Lint_Formal_Check, Netlist, Quick_Lint, Sg_Builtin_Check, Spyglass_Check, Structural_Check
set stage_rpt "Builtin_Check Language_Check Quick_Lint Sg_Builtin_Check Spyglass_Check Structural_Check"

# Family available in report_hdl cmd: CLK, CODING, CONN, NAMING, RST, SVSYN, SYN, TESTBENCH, UVM, XPROP, all
set family_rpt "CLK CODING CONN NAMING RST SVSYN SYN XPROP"

# Severity available in report_hdl cmd: fatal error warning, info
set severity_rpt "fatal error warning"

while {![file exists ${WAIVER_PATH}/lint_hdl_waiver.tcl]} {
    exec touch ${WAIVER_PATH}/lint_hdl_waiver.tcl
}
source -echo -verbose ${WAIVER_PATH}/lint_hdl_waiver.tcl
#source -echo -verbose ${WAIVER_PATH}/user_waiver.tcl

check_hdl -structure

check_hdl -lang

while {![file exists ${REPORT_PATH}/report_lint_hdl]} {
    exec mkdir -p ${REPORT_PATH}/report_lint_hdl
}
report_violations -app lint -verbose -file ${REPORT_PATH}/report_lint_hdl/$TOP_MODULE.lint_violations.rpt -limit 0
report_lint -list -limit 0 -severity $severity_rpt -stage $stage_rpt -family $family_rpt -file ${REPORT_PATH}/report_lint_hdl/$TOP_MODULE.lint_vio_sum.rpt
report_lint -verbose -limit 0 -severity $severity_rpt -stage $stage_rpt -family $family_rpt -file ${REPORT_PATH}/report_lint_hdl/$TOP_MODULE.lint_vio_detail.rpt
report_lint -verbose -limit 0 -severity "info" -stage $stage_rpt -family $family_rpt -file ${REPORT_PATH}/report_lint_hdl/$TOP_MODULE.lint_info_detail.rpt

report_violations -html

checkpoint_session -session ${TOP_MODULE}.lint_hdl_session

# 6. Save the session setup and run data
#save_session -session lint_session

# To restore a saved session
# restore_session [-session lint_session]

# 6. Show results in GUI
view_activity
