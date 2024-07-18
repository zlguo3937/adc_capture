# ===============================================================================
# Logical Library Settings
# ===============================================================================
set cache_write syn_work
set cache_read syn_work

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
