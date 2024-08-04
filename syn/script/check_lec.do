tclmode

// Input Files
source -verbose ./common_setup.tcl

set currentTime [clock format [clock seconds] -format "%Y%m%d_%H%M"]
exec mkdir -p ${REPORT_PATH}/${currentTime}_lec
set report_lec ${REPORT_PATH}/${currentTime}_lec


reset

usage -auto -elapse


// Configuration
tcl_set_command_name_echo on
set_command_echo on
set_command_profile on
set_parallel_option -threads 4,8 -norelease_license
set_compare_options -threads 0

set_dofile_abort on

set_verification_information ${report_lec}/${design}.verification.info
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
    set_analyze_option -auto -effort_analyze_abort high
} else {
    set_analyze_option -auto -effort_analyze_abort high -seq_merge
    check_verification_infomation
	set_system_mode setup
	set_datapath_option -auto -module -verbose
	set_datapath_option -auto -flowgraph -verbose
}

// R2G
if {[info exists LEC_TYPE] && $LEC_TYPE == "R2G"} {
	set_naming_rule -golden "_" -parameter
	set_naming_rule -golden "_" -array_deliniter
	set_naming_rule -golden "%s\[%d\]" -instance_array
	set_naming_rule -golden "%s_reg" -register
	set_naming_rule -golden "%L_%s" "%L_%d__%s" "%s" -variable
	set_naming_rule -golden "%L_%s" "%L_%d__%s" "%s" -instance
	set_naming_rule -ungroup_separator {____}
	set_naming_rule -golden -mdportflatten
	set_multibit_option -prefix {} -delimiter _MB_
}

set_flatten_mode -seq_constant
set_flatten_mode -seq_constant_x_to 0
set_flatten_mode -nodff_to_dlat_zero
set_flatten_mode -nodff_to_dlat_feedback
set_flatten_mode -hier_seq_merge
set_flatten_mode -gated_clock
set_flatten_mode -balanced_modeling

read_library -both -statetable -liberty $lib_files

if {[info exists extra_define] && $extra_define != ""} {
	read_design -golden -sv09 -merge bbox -lastmod -noelaborate -define $extra_define -file $golden_flist
	elaborate_design -golden -root $design -rootonly

	if {[info exists LEC_TYPE] && $LEC_TYPE == "R2G"} {
		set_hdl_options -synthesis_executable [exec which dc_shell]
		write_blackbox_wrapper -directory dw_generic DW* -auto_substitute
	}

	read_design -revised -sv09 -merge bbox -lastmod -noelaborate -define $extra_define $revised_flist
	elaborate_design -revised -root $design -rootonly
} else {
	read_design -golden -sv09 -merge bbox -lastmod -noelaborate -file $golden_flist
	elaborate_design -golden -root $design -rootonly

	if {[info exists LEC_TYPE] && $LEC_TYPE == "R2G"} {
		set_hdl_options -synthesis_executable [exec which dc_shell]
		write_blackbox_wrapper -directory dw_generic DW* -auto_substitute
	}

	read_design -revised -sv09 -merge bbox -lastmod -noelaborate $revised_flist
	elaborate_design -revised -root $design -rootonly
}

// Constant
if {[info exists usr_constraint]} {
	source -verbose $usr_constraint
}

uniquify -all -nolibrary

if {[info exists LEC_TYPE] && $LEC_TYPE == "R2G" && [info exists vsdc_file]} {
	read_setup_information $vsdc_file -type vsdc -report
}

report_design_data
report_black_box -detail -inst > ${report_lec}/${design}.bbox

set lec_version [regsub {(-)[A-Za-z]} $LEC_VERSION ""]
set wlec_analyze_dp_flowgraph true
set share_dp_analysis true
set lec_version_required "23.20"
if {$lec_version >= $lec_version_required && $wlec_analyze_dp_flowgraph} {
	set DATAPATH_SOLVER_OPTION "-flowgraph"
} elseif {$share_dp_analysis} {
	set DATAPATH_SOLVER_OPTION "-share"
} else {
	set DATAPATH_SOLVER_OPTION ""
}

tclmode

// Hier
if { $FLOW == "HIER" } {
	set prepend_string ""
	append prepend_string "analyze_setup -seq_merge;\n"
	append prepend_string "report_design_data;\n"
	append prepend_string "set cur_module \[get_root_module\];\n"
	append prepend_string "write_mapped_points -replace -SHOW_ORIG_RTL_NAMES ${report_lec}/modules/\$cur_module.mapped_points.rpt;\n"
	append prepend_string "report_unmapped_points -summary > ${report_lec}/modules/\$cur_module.unmapped_points_sum.rpt;\n"
	append prepend_string "report_unmapped_points -extra -unreachable -notmapped > ${report_lec}/modules/\$cur_module.unmapped_points.rpt;\n"
	append prepend_string "analyze_datapath -module -verbose;\n"
	append prepend_string "eval analyze_datapath $DATAPATH_SOLVER_OPTION -verbose;\n"

	#compare_string "analyze_compare -verbose"; #smart mode only
	#go_hier_compare hier.do -verbose -check_noneq; #smart mode only
	#write_hier_compare_dofile hier.do -replace -usage \
	-format TCL -constraint -noexact_pin_match -verbose \
	-prepend_string "report_design_data; usage;" \
	-balanced_extraction -input_output_pin_equivalence \
	-function_pin_mapping -effort high -threshold 1000

	write_hier_compare_dofile high.do -verbose \
	-noexact_pin_match -constraint -usage \
	-replace -balanced_extraction -input_output_pin_equivalence \
	-extract_icg -function_pin_mapping \
	-prepend_string $prepend_string

	run_hier_compare hier.do -dynamic_hierarchy -check_noneq
	report_hier_compare_result -all -usage
	report_hier_compare_result -abort -usage
	report_hier_compare_result -noneq -usage
	//report_verification -hier -verbose
}

// Flat
if { $FLOW == "FLAT" } {
	set_system_mode lec -nomap
	report_pin_constraints
	map_key_points
	//analyze_datapath -merge -verbose
	add_compared_points -all
	compare -NONEQ_Print
	//report_verification -compare_result -verbose
}

set_system_mode lec

report_black_box > ${report_lec}/${design}.black_box.rpt
report_design_data > ${report_lec}/${design}.design_data.rpt
report_pin_constraints > ${report_lec}/${design}.pin_constraints.rpt
report_unmapped_points -summary > ${report_lec}/${design}.unmapped_points_sum.rpt
report_unmapped_points -extra -unreachable -notmapped > ${report_lec}/${design}.unmapped_points.rpt
report_compare_data -class nonequivalent -verbose > ${report_lec}/${design}.noneq_points.rpt
report_statistics > ${report_lec}/${design}.statistics.rpt
report_environment > ${report_lec}/${design}.env.rpt

if {$LEC_TYPE == "R2G"} {
	report_verification -hier -verbose > ${report_lec}/${design}.verification.rpt
} else {
	report_verification -verbose > ${report_lec}/${design}.verification.rpt
}

save_session ${report_lec}/${design}.session
