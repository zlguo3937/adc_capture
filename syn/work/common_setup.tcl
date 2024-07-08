# ===============================================================================
# User defined variables for logical library setup in dc_setup.tcl
# ===============================================================================
set SYN_ROOT_PATH /local/zlguo/prj/ip-8b-riscv-cpu; puts "1.  set working PATH: $SYN_ROOT_PATH"

set RTL_PATH $SYN_ROOT_PATH/hw/rtl; puts "2.  set RTL code PATH: $RTL_PATH"

set CONFIG_PATH $SYN_ROOT_PATH/syn/config; puts "3.  set config files PATH: $CONFIG_PATH"

set SCRIPT_PATH $SYN_ROOT_PATH/syn/script; puts "4.  set script files PATH: $SCRIPT_PATH"

set UNMAPPED_PATH $SYN_ROOT_PATH/syn/unmapped; puts "5.  set unmapped files PATH: $UNMAPPED_PATH"

set MAPPED_PATH $SYN_ROOT_PATH/syn/mapped; puts "6.  set mapped files PATH: $MAPPED_PATH"

set REPORT_PATH $SYN_ROOT_PATH/syn/report; puts "7.  set report files PATH: $REPORT_PATH"

set WORK_PATH $SYN_ROOT_PATH/syn/work; puts "8.  set work run files PATH: $WORK_PATH"

set DC_PATH /synopsys/syn/R-2020.09-SP4; puts "9.  set tool PATH: $DC_PATH"

set LIB_ROOT_PATH /library/tsmc/cln28hpcp

set LIB_PATH $LIB_ROOT_PATH/STD/tcbn28hpcplusbwp7t40p140_180b/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp7t40p140_180a

set DC_LIB_PATH $DC_PATH/libraries/syn

set SYMBOL_PATH $DC_PATH/libraries/syn

puts "10. set Library PATH: $LIB_PATH\n                              $DC_LIB_PATH"

# Directories containing logical libraries, logical design and script files.
set ADDITIONAL_SEARCH_PATH "$LIB_PATH $DC_LIB_PATH $SYMBOL_PATH $RTL_PATH $SCRIPT_PATH $CONFIG_PATH"

set DW_FOUNDATION_FILES "dw_foundation.sldb standard.sldb"

# Logical technology library file.
set TARGET_LIBRARY_FILES tcbn28hpcplusbwp7t40p140tt0p8v0p8v85c.db

# Symbol library file.
set SYMBOL_LIBRARY_FILES generic.sdb

## ===============================================================================
## User defined variables for physical library setup in dc_setup.tcl
## ===============================================================================
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
