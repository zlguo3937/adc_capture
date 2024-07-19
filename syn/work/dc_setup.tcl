set design_root ./
set work_area [format "%s%s" $design_root syn_work/]

set cache_write syn_work
set cache_read syn_work


# ===============================================================================
# Logical Library Settings
# ===============================================================================
set_app_var search_path "$search_path $ADDITIONAL_SEARCH_PATH"
puts "11. set search_path"

# This variables are automatically set if you perform ultra command.
# Specify for use during optimization.
# You do not need to do anything to access the standard library,
# Dc is setup to use this library by default.

set_app_var synthetic_library $DW_FOUNDATION_FILES
puts "12. set synthetic_library"

set_app_var target_library $TARGET_LIBRARY_FILES
puts "13. set target_library"

set_app_var link_library "* $target_library $synthetic_library $IO_LIBRARY_FILES $MEM_LIBRARY_FILES"
puts "14. set link_library"

set_app_var symbol_library $SYMBOL_LIBRARY_FILES
puts "15. set symbol_library"

if {$mb_en == 1} {
        set_dont_use { \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/CK* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/DC* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/TIE* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/DEL* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/*OPT* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/*D0* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/*SDFSYN* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/SDFCS* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/SDFNCS* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/FA1D* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/MAO* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/MOA* \
            }
} else {
        set_dont_use { \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/MB8SRLSDF* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/CK* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/DC* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/TIE* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/DEL* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/*OPT* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/*D0* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/*SDFSYN* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/SDFCS* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/SDFNCS* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/FA1D* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/MAO* \
            tcbn28hpcplusbwp40p140ssg0p9vm40c/MOA* \
            }
}

## ===============================================================================
## Physical Library Settings
## ===============================================================================
#set_app_var mw_reference_library $MW_REFERENCE_LIB_DIRS
#set_app_var mw_design_library $MW_DESIGN_LIB
#
#create_mw_lib   -technology $TECH_FILE \
#                -mw_reference_library $mw_reference_library \
#                $mw_design_library
#open_mw_lib     $mw_design_library
#set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
#                   -tech2itf_map $MAP_FILE


set auto_link_options "-all"
set command_log_file ./command.log
define_design_lib WORK -path $work_area
set compile_no_new_cells_at_top_level false
set port_complement_naming_style %s_BAR
set uniquify_naming_style %s_%d

# Support conformal LEC mapping between RTL and netlist with Multibit feature
set_app_var bus_multiple_name_separator_style _MB_

# The assignment is incomplete and the tool must implement
# latches to hold the current value when the unassigned condition occurs
set_app_var hdlin_check_no_latch true

set hdlin_vhdl93_concat false
set hdlin_auto_save_templates TRUE

set hdlin_translate_off_skip_text true
set hdlin_enable_analysis_info false
set bc_enable_analysis_info false

set verilogout_no_tri true
set verilog_single_bit false
set verilogout_equation false

set supress-error [concat $suppress_errors [list UID-437 UID-439 UID-401 EQN-10 OPT-318]]
set synlib_wait_for_design_license DesignWare-Foundation

set write_name_nets_same_as_ports true

set hdlin_enable_vpp true
set hlo_resource_allocation constraint_driven
set hdlin_dont_infer_mux_for_resource_share false
set hdlin_enable_presto true

set timing_enable_multiple_clocks_per_reg true
set hdlin_while_loop_iterations 2048
