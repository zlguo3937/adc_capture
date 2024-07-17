configure_console_messages  -show both -tags [ get_tags -app DESIGN ]

# configure_lint_tag -enable -tag *

#### Enabling/Disabling VC Spyglass LINT tags
#### configure_lint_tag -enable -tag "<tag_name>" -goal <goal_name>
#### configure_lint_tag_parameter -tag "<tag_name>" -parameter <parameter_name> -value {<value>} -goal <goal_name>
#### configure_lint_setup -goal <goal_name>
configure_lint_methodology -path ${SCRIPT_PATH}/check_lint/custom_goal -goal custom_rtl_handoff
configure_lint_setup -goal custom_rtl_handoff

#configure_tag -disable -tag "UTSFM" -goal custom_rtl_handoff
#configure_tag -disable -tag "UTSFCM" -goal custom_rtl_handoff
#configure_tag -disable -tag "SM_DNS" -goal custom_rtl_handoff
#configure_tag -disable -tag "VC_WRN_FUNC" -goal custom_rtl_handoff

# Design should not have different timescales for different modules
configure_tag -disable -tag "CheckDelayTimescale-ML" -goal custom_rtl_handoff

# Detects clock buffers
configure_tag -disable -tag "BufClock" -goal custom_rtl_handoff

# Match the bit-width with the base number part
configure_tag -disable -tag "STARC05-2.10.3.7" -goal custom_rtl_handoff

#configure_tag -disable -tag "AutomaticFuncTask-ML" -goal custom_rtl_handoff
#configure_tag -disable -tag "DisallowCaseX-ML" -goal custom_rtl_handoff
#configure_tag -disable -tag "ReserveName" -goal custom_rtl_handoff

# Source file name should be same as the name of the module in the file.
configure_tag -disable -tag "STARC05-1.1.1.1" -goal custom_rtl_handoff


#configure_tag -disable -tag "STARC05-2.3.1.4" -goal custom_rtl_handoff
#configure_tag -disable -tag "STARC05-2.8.5.1" -goal custom_rtl_handoff

# Reports logic paths where depth exceeds the specified number of levels
configure_tag -disable -tag "LogicDepth" -goal custom_rtl_handoff

#configure_tag -disable -tag "STARC05-1.3.1.3" -goal custom_rtl_handoff
#configure_tag -disable -tag "STARC05-1.4.3.2" -goal custom_rtl_handoff

# Tristate port detected
configure_tag -disable -tag "TristatePort-ML" -goal custom_rtl_handoff

#configure_tag -disable -tag "W401" -goal custom_rtl_handoff

# Ensure that a tristate is not used below top-level of design
configure_tag -disable -tag "W438" -goal custom_rtl_handoff

# Output port signal is being read (within the module)
configure_tag -disable -tag "W446" -goal custom_rtl_handoff

#configure_tag -disable -tag "W280" -goal custom_rtl_handoff
#configure_tag -disable -tag "W159" -goal custom_rtl_handoff

# Design should not have different timescales for different modules
configure_tag -disable -tag "DiffTimescaleUsed-ML" -goal custom_rtl_handoff

configure_lint_tag_parameter -tag "LogNMux" -parameter LOGMUX_MAX -value "9" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "sim_race01" -parameter CHECK_SEQ_ASSIGN -value {yes} -goal custom_rtl_handoff
