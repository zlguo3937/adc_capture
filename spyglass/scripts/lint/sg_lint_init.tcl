puts [clock format [clock second] -format "%Y-%m-%d %H:%M:%S"]

# 1. set the project environment
set current_path [pwd]
source ${current_path}/Config.tcl

# 2.set waiver
source ${WORK_PATH}/scripts/lint/set_top_waiver.tcl

# 3.new project
#new_project sg_lint -projectwdir ${WORK_PATH}/project/  -force
new_project ${TOP_MODULE}_sg_lint_init -force

# 4.read design file
read_file -type sourcelist $filelist

# 5.read waiver file
read_file -type awl $TOP_WAIVER_FILE

# 6.set common option and parameter
source ${WORK_PATH}/scripts/lint/set_option_and_parameter.tcl

# 7.methodology and goal setup
#set METHODOLOGY_TYPE initial_rtl
#
#set GOAL_TYPE all
#
#if { $METHODOLOGY_TYPE == "initial_rtl" } {
#    current_methodology $env(current_methodology_initial_rtl)
#    set regression_mandatory_list {lint/lint_rtl adv_lint/adv_lint_struct}
#    set regression_optional_list  {lint/design_audit lint/lint_functional_rtl}
#} else {
#    current_methodology $env(current_methodology_rtl_handoff)
#    set regression_mandatory_list {lint/lint_rtl adv_lint/adv_lint_verify}
#    set regression_optional_list  {lint/lint_functional_rtl lint/lint_abstract}
#}
#
#append regression_all_list {regression_mandatory_list regression_optional_list}
#
#if { $GOAL_TYPE == "mandatory" } {
#    current_goal Group_Run -goal ${regression_mandatory_list} -top $TOP_MODULE
#} elseif { $GOAL_TYPE == "optional" } {
#    current_goal Group_Run -goal ${regression_optional_list} -top $TOP_MODULE
#} else {
#    current_goal Group_Run -goal ${regression_all_list} -top $TOP_MODULE
#}
#
#unset regression_all_list

#Use this command to enable reporting of incremental messages so that you can compare results of a previously run goal with the current goal.
#if { ![file exists ${WORK_PATH}/out/${TOP_MODULE}.vdb] } {
#    set_goal_option report_incr_messages yes
#	#Specifies path of previous Violation Database file for consideration in Incremental Mode
#	#set_goal_option old_vdbfile ${WORK_PATH}/out/${TOP_MODULE}.vdb
#} else {
#    set_goal_option report_incr_messages no
#}
current_goal Group_Run -goal {lint/lint_rtl lint/lint_rtl_enhanced lint/lint_turbo_rtl lint/lint_functional_rtl lint/lint_abstract}

# 8.set rules
source ${WORK_PATH}/scripts/lint/set_sg_lint_rules.tcl

# 9.run goal
run_goal

# 10.analyze results
set LINT_PATH ${REPORT_PATH}/lint/lint_init

if {![file exists ${LINT_PATH}]} {
    file mkdir ${LINT_PATH}
    puts "Directory ${LINT_PATH} created.\n"
} else {
    puts "Directory ${LINT_PATH} already exists.\n"
}

write_report goal_summary > $LINT_PATH/${TOP_MODULE}_lint_goal_summary.rpt
write_report goal_setup   > $LINT_PATH/${TOP_MODULE}_lint_goal_setup.rpt
write_report moresimple   > $LINT_PATH/${TOP_MODULE}_lint_moresimple.rpt
write_report summary      > $LINT_PATH/${TOP_MODULE}_lint_summary.rpt
write_report waiver       > $LINT_PATH/${TOP_MODULE}_lint_waiver.rpt

set file_goal_summary   $LINT_PATH/${TOP_MODULE}_lint_goal_summary.rpt
set file_goal_setup     $LINT_PATH/${TOP_MODULE}_lint_goal_setup.rpt
set file_moresimple     $LINT_PATH/${TOP_MODULE}_lint_moresimple.rpt
set file_summary        $LINT_PATH/${TOP_MODULE}_lint_summary.rpt
set file_waiver         $LINT_PATH/${TOP_MODULE}_lint_waiver.rpt
set sg_log              $WORK_PATH/work/${TOP_MODULE}_sg_lint_init/${TOP_MODULE}/Group_Run/spyglass.log

if {[file exists $file_goal_summary]} {
    puts "$file_goal_summary"
    exec gvim $file_goal_summary &
} else {
    puts "Warning: There's no $file_goal_summary."
}

if {[file exists $file_goal_setup]} {
    puts "$file_goal_setup"
    exec gvim $file_goal_setup &
} else {
    puts "Warning: There's no $file_goal_setup."
}

if {[file exists $file_moresimple]} {
    puts "$file_moresimple"
    exec gvim $file_moresimple &
} else {
    puts "Warning: There's no $file_moresimple."
}

if {[file exists $file_summary]} {
    puts "$file_summary"
    exec gvim $file_summary &
} else {
    puts "Warning: There's no $file_summary."
}

if {[file exists $file_waiver]} {
    puts "$file_waiver"
    exec gvim $file_waiver &
} else {
    puts "Warning: There's no $file_waiver."
}

if {[file exists $sg_log]} {
    puts "$sg_log"
    exec gvim $sg_log &
} else {
    puts "Warning: There's no $sg_log."
}

# 11.save & close project
save_project  -force ${TOP_MODULE}_sg_lint_init.prj
close_project -force

puts "\n---------------------------------------------------------------------------------------------------"
puts " Please select the one of following command to open SG_Lint project:\n"
puts " 1:"
puts " spyglass -project ${TOP_MODULE}_sg_lint_init.prj &\n"
puts " 2:"
puts " make lint_gui\n"
puts " Before open the gui results, you must be at $WORK_PATH/work !"
puts "---------------------------------------------------------------------------------------------------"
