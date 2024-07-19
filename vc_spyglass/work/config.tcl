# ***************************************************************************************************
#                           User Config
# ***************************************************************************************************
# 1. source project env
set WORK_ROOT_HOME              /local/zlguo/prj/adc_capture
set RTL_PATH                    ${WORK_ROOT_HOME}/hw/rtl
set LIBRARY_PATH                /library/tsmc/cln28hpcp
set IO_PATH                     ${LIBRARY_PATH}/IO/tphn28hpcpgv18_170a/Front_End
set STD_PATH                    ${LIBRARY_PATH}/STD/tcbn28hpcplusbwp40p140_180b/Front_End
set MEM_PATH                    ${WORK_ROOT_HOME}/hw/library/ts1n28hpcpsvtb32768x36m16swso_180a/NLDM

# 2. source filelist
set filelist                    ${WORK_ROOT_HOME}/builds/filelist/rtl_spyglass.f

# 3. source sdc file
set sdc_file                    ${WORK_ROOT_HOME}/syn/script/adc_capture.sdc

# 4.set top module
set TOP_MODULE                  ASIC

# 5. The following command reads Cell library files in .db format (# Refer to the Reading the Liberty Files section for details.)
set search_path ". ${IO_PATH}/timing_power_noise/NLDM/tphn28hpcpgv18_170a ${STD_PATH}/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a ${MEM_PATH}"
set link_library "tphn28hpcpgv18tt0p9v1p8v85c.db tcbn28hpcplusbwp40p140ssg0p9vm40c.db ts1n28hpcpsvtb32768x36m16swso_180a_tt1v25c.db"

set lib_io                      $IO_PATH/timing_power_noise/NLDM/tphn28hpcpgv18_170a/tphn28hpcpgv18tt0p9v1p8v85c.lib
set lib_std                     $STD_PATH/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a/tcbn28hpcplusbwp40p140ssg0p9vm40c.lib
#set lib_nvm                     $LIBRARY_PATH/NVM/(xxx.lib)
set lib_sram_0                  $MEM_PATH/ts1n28hpcpsvtb32768x36m16swso_180a_tt1v25c.lib

puts "set source project env:   ${WORK_ROOT_HOME}"
puts "set source library env:   ${LIBRARY_PATH}"
puts "set source filelist:      ${filelist}"
puts "set source sdc file:      ${sdc_file}"
puts "set top module:           ${TOP_MODULE}"
puts "set library file:         $lib_io"
puts "set library file:         $lib_std"
#puts "set library file:         $lib_nvmd"
puts "set library file:         $lib_sram_0"
#puts "set library file:         $lib_sram_2"

# 6. Setting black-box file
set blkbox_file_ana             ${RTL_PATH}/analog/ANALOG_WRAPPER.sv
#set blkbox_file_xxx             ${RTL_PATH}/xxx (you must config the run_vs_lint.tcl script which in path: script/check_lint)


# ***************************************************************************************************
#                           Work Directory define
# ***************************************************************************************************
# 1. set spyglass run dir
set WORK_PATH                   ${WORK_ROOT_HOME}/vc_spyglass
set REPORT_PATH                 ${WORK_PATH}/report
set SCRIPT_PATH                 ${WORK_PATH}/script
set WAIVER_PATH                 ${WORK_PATH}/waiver
set work                        ${WORK_PATH}/work
