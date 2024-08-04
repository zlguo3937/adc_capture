# ==============================================================================================================
# User defined variables for logical library setup in dc_setup.tcl
# ==============================================================================================================
set SYN_ROOT_PATH /local/zlguo/prj/adc_capture
puts "\n1.  set working PATH: $SYN_ROOT_PATH\n"

set RTL_PATH $SYN_ROOT_PATH/hw/rtl
puts "2.  set RTL code PATH: $RTL_PATH\n"

set CONFIG_PATH $SYN_ROOT_PATH/syn/config
puts "3.  set config files PATH: $CONFIG_PATH\n"
exec mkdir -p $CONFIG_PATH

set SCRIPT_PATH $SYN_ROOT_PATH/syn/script
puts "4.  set script files PATH: $SCRIPT_PATH\n"

set UNMAPPED_PATH $SYN_ROOT_PATH/syn/unmapped
exec mkdir -p $UNMAPPED_PATH
puts "5.  set unmapped files PATH: $UNMAPPED_PATH\n"

set MAPPED_PATH $SYN_ROOT_PATH/syn/mapped
puts "6.  set mapped files PATH: $MAPPED_PATH\n"
exec mkdir -p $MAPPED_PATH

set REPORT_PATH $SYN_ROOT_PATH/syn/report
puts "7.  set report files PATH: $REPORT_PATH\n"
exec mkdir -p $REPORT_PATH

set WORK_PATH $SYN_ROOT_PATH/syn/work
puts "8.  set work run files PATH: $WORK_PATH\n"

set DC_PATH /synopsys/syn/V-2023.12-SP3
puts "9.  set tool PATH: $DC_PATH\n\n"

set LIB_ROOT_PATH /library/tsmc/cln28hpcp

set LIB_PATH $LIB_ROOT_PATH/STD/tcbn28hpcplusbwp40p140_180b/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a
set IO_PATH  $LIB_ROOT_PATH/IO/tphn28hpcpgv18_170a/Front_End/timing_power_noise/NLDM/tphn28hpcpgv18_170a
set MEM_PATH $SYN_ROOT_PATH/hw/library/ts1n28hpcpsvtb32768x36m16swso_180a/NLDM

set DC_LIB_PATH $DC_PATH/libraries/syn

set SYMBOL_PATH $DC_PATH/libraries/syn

puts "10. set STD Library PATH: $LIB_PATH\n"
puts "    set IO  Library PATH: $IO_PATH\n"
puts "    set MEM Library PATH: $MEM_PATH\n"
puts "    set DC  Library PATH: $DC_LIB_PATH\n"

# Directories containing logical libraries, logical design and script files.
set ADDITIONAL_SEARCH_PATH "$LIB_PATH $IO_PATH $MEM_PATH $DC_LIB_PATH $SYMBOL_PATH $RTL_PATH $SCRIPT_PATH $CONFIG_PATH"

## .db files
# Logical technology library file.
set TARGET_LIBRARY_FILES tcbn28hpcplusbwp40p140ssg0p9vm40c.db

set IO_LIBRARY_FILES    tphn28hpcpgv18tt0p9v1p8v85c.db
set MEM_LIBRARY_FILES   ts1n28hpcpsvtb32768x36m16swso_180a_tt1v25c.db
set DW_FOUNDATION_FILES "dw_foundation.sldb standard.sldb"


## .lib files
set TARGET_LIB_FILES $LIB_PATH/tcbn28hpcplusbwp40p140ssg0p9vm40c.lib
set IO_LIB_FILES     $IO_PATH/tphn28hpcpgv18tt0p9v1p8v85c.lib
set MEM_LIB_FILES    $MEM_PATH/ts1n28hpcpsvtb32768x36m16swso_180a_tt1v25c.lib


# Symbol library file.
set SYMBOL_LIBRARY_FILES generic.sdb

set file_list $SYN_ROOT_PATH/builds/filelist/rtl_syn.f

set mb_en 1

## ==============================================================================================================
## User defined variables for physical library setup in dc_setup.tcl
## ==============================================================================================================
#set MW_DESIGN_LIB                 ______________  ; puts "User-defined Milkyway design library name: $MW_DESIGN_LIB"
#
#set MW_REFERENCE_LIB_DIRS         ../ref/libs/mw_lib/_______  ; puts "Milkyway reference libraries: $MW_REFERENCE_LIB_DIRS"
#
#set TECH_FILE                     ../ref/libs/tech/cb13_6m.tf  ; puts "Milkyway technology file: $TECH_FILE"
#
#set TLUPLUS_MAX_FILE              ../ref/libs/tlup/cb13_6m_max.tluplus  ; puts "Max TLUPlus file: $TLUPLUS_MAX_FILE"
#
#set TLUPLUS_MIN_FILE              ../ref/libs/tlup/cb13_6m_min.tluplus  ; puts "Min TLUPlus file: $TLUPLUS_MIN_FILE"
#
#set MAP_FILE                      ../ref/libs/tlup/cb13_6m.map  ; puts "Mapping file for TLUplus: $MAP_FILE"


# ================================================================================================================
# Setup for Conformal LEC
# ================================================================================================================
set FLOW            HIER
set LEC_TYPE        R2G
set LEC_VERSION     23.20
set design          ASIC

set extra_define    SYNTHESIS

set lib_files       "$TARGET_LIB_FILES $IO_LIB_FILES $MEM_LIB_FILES"

set golden_flist    $UNMAPPED_PATH/ASIC.v
set revised_flist   $MAPPED_PATH/ASIC.v

set vsdc_file       $MAPPED_PATH/${design}.vsdc

set usr_constraint  $SCRIPT_PATH/adc_capture.sdc

