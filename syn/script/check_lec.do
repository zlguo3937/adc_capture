tclmode

set currentTime [clock format [clock seconds] -format "%Y%m%d_%H%M"]
exec mkdir -p ${REPORT_PATH}/${currentTime}_lec
set REPORTS_PATH ${REPORT_PATH}/${currentTime}_lec

set TOP_MODULE ASIC

reset

usage -auto -elapse


// Input Files
source -verbose ../script/common_lec_setting.tcl
source -verbose ./common_setup.tcl


// Configuration
tcl_set_command_name_echo on
set_command_echo on
set_command_profile on
set_parallel_option -threads 4,8 -norelease_license
set_compare_options -threads 0

set_dofile_abort on

set_verification_information ${REPORTS_PATH}/${TOP_MODULE}.verification.info
set_hdl_options -use_library_first on

set_mapping_method -name first


// Choose Tool
if {[info exists LEC_TYPE] && $LEC_TYPE == "R2G"} {
    if {[info exists SYN_TOOL] && $SYN_TOOL == "Genus"} {
        set_naming_style RC
    } else {
        set_naming_style DC
    }
}

// G2G
if {$LEC_TYPE == "G2G"} {
    set_naming_style RC
} else {
    set_naming_style DC
}
