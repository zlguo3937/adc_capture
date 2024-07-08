#set top waiver file
set TOP_WAIVER_FILE ${WORK_PATH}/waiver/${TOP_MODULE}_lint.awl
if { ![file exists $TOP_WAIVER_FILE] } {
    exec touch $TOP_WAIVER_FILE
} 
