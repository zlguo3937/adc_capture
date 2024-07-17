configure_console_messages  -show both -tags [ get_tags -app DESIGN ]

# configure_lint_tag -enable -tag *

#### Enabling/Disabling VC Spyglass LINT tags
#### configure_lint_tag -enable -tag "<tag_name>" -goal <goal_name>
#### configure_lint_tag_parameter -tag "<tag_name>" -parameter <parameter_name> -value {<value>} -goal <goal_name>
#### configure_lint_setup -goal <goal_name>

# ======================================================================================================
# ------------------------------------------ lint_rtl --------------------------------------------------
# ======================================================================================================
configure_lint_tag -enable -tag "RegInputOutput-ML" -goal custom_rtl_handoff -severity Info
configure_lint_tag_parameter -tag "RegInputOutput-ML" -parameter CHKTOPMODULE -value {yes} -goal custom_rtl_handoff

configure_lint_tag -enable -tag "FlopEConst" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "FlopEConst" -parameter REPORT_INFERRED_CELL -value {yes} -goal custom_rtl_handoff

configure_lint_tag -enable -tag "STARC05-2.3.3.1" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W415a" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W287b" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W224" -goal custom_rtl_handoff

configure_lint_tag -enable -tag "W528" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "W528" -parameter CHECKFULLBUS -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "W528" -parameter CHECKFULLRECORD -value {yes} -goal custom_rtl_handoff

# ======================================================================================================
# ------------------------------------- lint_rtl_enhanced ----------------------------------------------
# ======================================================================================================
configure_lint_tag -enable -tag "AutomaticFuncTask-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "badimplicitSM1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "badimplicitSM2" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "badimplicitSM4" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "BlockHeader" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "bothedges" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "BufClock" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "CheckDelayTimescale-ML" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "checkPinConnectedToSupply" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "CombLoop" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "CombLoop" -parameter ENABLEE2Q -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "CombLoop" -parameter REPORT_FLOP_RESET_LOOP -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "CombLoop" -parameter STRICT -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DisallowCaseX-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "DuplicateCaseLabel-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "FlopClockConstant" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "FlopSRConst" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "ImproperRangeIndex-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "InferLatch" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "infiniteloop" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "InstPortConnType-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "LatchFeedback" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "mixedsenselist" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "NoAssignX-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "NoFeedThrus-ML" -goal custom_rtl_handoff -severity Warning
configure_lint_tag_parameter -tag "NoFeedThrus-ML" -parameter CHECKTOPDU -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "NoGenLabel-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "NoGenLabel-ML" -parameter CHECK_DUP_LABEL -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "NoGenLabel-ML" -parameter GENLABELTYPE -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "NoXInCase-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "ParamWidthMismatch-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "PragmaComments-ML" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "ReportPortInfo-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ReserveName" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "ReserveNameSystemVerilog-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "SameControlNDataNet-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "SetBeforeRead-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "SigAssignZ-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "sim_race02" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "sim_race07" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-1.1.1.1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-1.2.1.2" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-1.3.1.3" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-1.4.3.2" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-1.4.3.4" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.1.3.1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.1.4.5" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.1.5.3" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.1.6.5" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.10.1.4a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.10.1.4b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.10.2.3" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.10.3.2a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.11.3.1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.2.3.1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.2.3.3" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.3.1.2c" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.3.1.5b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.3.1.6" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.3.4.1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.3.4.1v" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.4.1.5" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.5.1.2" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.5.1.7" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.5.1.9" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.8.1.3" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.8.1.5" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.8.5.1" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.9.1.2a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.9.1.2b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-2.1.1.2" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "TristatePort-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "TristateSig-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "UndrivenInTerm-ML" -goal custom_rtl_handoff -severity Error

configure_lint_tag_parameter -tag "UndrivenInTerm-ML" -parameter CHECKINHIERARCHY -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "UndrivenInTerm-ML" -parameter CHECKRTLCINST -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UndrivenNet-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "UndrivenNet-ML" -parameter CHECKINHIERARCHY -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UndrivenOutPort-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "UndrivenOutPort-ML" -parameter CHECKINHIERARCHY -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UnrecSynthDir-ML" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W110" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W110a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W116" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W122" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W123" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W123" -parameter IGNOREMODULEINSTANCE -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W127" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W156" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W163" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W164a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W164b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W167" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W188" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W19" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W193" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W210" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W215" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W216" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W218" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W238" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W239" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W240" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "W241" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "W245" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W263" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W287a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W287b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W289" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W292" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W293" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W314" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W316" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W317" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W336" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W336" -parameter TREAT_LATCH_AS_COMBINATIONAL -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W337" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W339a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "STARC05-3.3.1.4b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W342" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W343" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W352" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W362" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W362" -parameter NOCHECKOVERFLOW -value { W362 } -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W392" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W392" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W392" -parameter IGNORE_SYNC_RESET_FOR_ASYNC_RESET_FLOP -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W398" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W401" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W402b" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "W414" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W414" -parameter TREAT_LATCH_AS_COMBINATIONAL -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W415" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W415" -parameter ASSUME_DRIVER_LOAD -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "W415" -parameter CHECKCONSTASSIGN -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "W415" -parameter HANDLE_EQUIVALENT_DRIVERS -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W416" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W421" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W422" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W423" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W424" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W426" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W438" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W442a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W442b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W442c" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W442f" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W443" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W444" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W450L" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W464" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W467" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W479" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W480" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W481a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W481b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W486" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "W494" -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "W494" -parameter CHKTOPMODULE -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W495" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W496a" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W496b" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W499" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W502" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W505" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W527" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W552" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "W561" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W575" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W576" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W66" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W71" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W553" -goal custom_rtl_handoff -severity Warning

# ======================================================================================================
# ------------------------------------- lint_rtl_optional ----------------------------------------------
# ======================================================================================================
configure_lint_tag -enable -tag "AllocExpr" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DisconnSpec" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ForLoopWait" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "IncompleteType" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "IntGeneric" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LinkagePort" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LoopBound" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "NoTimeOut" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "PortType" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "PreDefAttr" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ResFunction" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UserDefAttr" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W182g" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W182h" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W182k" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W182n" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "SignedUnsignedExpr-ML" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "SignedUnsignedExpr-ML" -parameter STRICT -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "sim_race01" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "BothPhase" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ClockStyle" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DiffTimescaleUsed-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "MultipleWait" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "NoSigCaseX-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "SigVarInit" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.1.2.5v" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.1.8.6" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.10.3.7" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "STARC05-2.10.3.7" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.3.1.4" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.3.2.4" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "SynthIfStmt" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W129" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W182c" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W189" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W190" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W213" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W226" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "W226" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W250" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W253" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W254" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W280" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W294" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W425" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W427" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W430" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "WhileInSubProg" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ArrayIndex" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "ArrayIndex" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DisallowCaseZ-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DisallowXInCaseZ-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ParamOverrideMismatch-ML" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "STARC05-2.3.2.2" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W111" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W159" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W446" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "W456a" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "W456a" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W491" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W551" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.3.6.1" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UseMuxBusses" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "W428" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UndrivenNUnloaded-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "UnloadedInPort-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LogicDepth" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "ClockEdges" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DisabledAnd" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "DisabledOr" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "FlopDataConstant" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "IntReset" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LatchDataConstant" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LatchEnableConstant" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LatchGatedClock" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "LatchGatedClock" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LatchReset" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "LogNMux" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "LogNMux" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "MuxSelConst" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "MuxSelConst" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "RegOutputs" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "SetResetConverge-ML" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-1.3.1.7" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "STARC05-1.3.1.7" -parameter STRICT -value {no} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "STARC05-2.5.1.4" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "TristateConst" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "W422L" -goal custom_rtl_handoff

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



set collection_result_display_limit 9999999
set RESET_NAME {rstn rst_n}

configure_console_messages  -show both -tags [ get_tags -app DESIGN ]
configure_hdl_tag -enable -tag *

configure_hdl_tag -disable -tag SYN_NBA_INTRADLY_NBA
configure_hdl_tag -disable -tag CODING_NAMING_ALPHABET_FIRST
configure_hdl_tag -disable -tag CODING_NAMING_INSTNAME_LONG
configure_hdl_tag -disable -tag CODING_NAMING_MODNAME_LONG
configure_hdl_tag -disable -tag CODING_NAMING_OBJNAME_LONG
configure_hdl_tag -disable -tag SYN_DECL_NET_ASSIGN
configure_hdl_tag -disable -tag CODING_ALWAYS_CMPLX_ARITH
configure_hdl_tag -disable -tag CODING_ALWAYS_ONLYUSE_ALWAYS_COMB
configure_hdl_tag -disable -tag CODING_ALWAYS_USE_ALWAYS_COMB
configure_hdl_tag -disable -tag CODING_ALWAYS_USE_ALWAYS_FF
configure_hdl_tag -disable -tag CODING_COMMENT_HEADER
configure_hdl_tag -disable -tag CODING_COMMENTS_AUTHOR_FIELD_MISSING
configure_hdl_tag -disable -tag CODING_COMMENTS_DATE_FIELD_MISSING
configure_hdl_tag -disable -tag CODING_COMMENTS_DESCRIPTION_FIELD_MISSING
configure_hdl_tag -disable -tag CODING_COMMENTS_FILE_NAME_FIELD_MISSING
configure_hdl_tag -disable -tag CODING_COMMENTS_MODIFICATION_FIELD
configure_hdl_tag -disable -tag CODING_EXPR_AVOID_DLY
configure_hdl_tag -disable -tag CODING_EXPR_NEG_DLY
configure_hdl_tag -disable -tag NAMING_FUNC_LOWER_CASE
configure_hdl_tag -disable -tag NAMING_INST_MIN_CHARS
configure_hdl_tag -disable -tag NAMING_MOD_MIN_NAME_LENGTH
configure_hdl_tag -disable -tag NAMING_PARAMETER_BASE_FORMAT
configure_hdl_tag -disable -tag NAMING_PORT_NO_OF_CHARS
configure_hdl_tag -disable -tag NAMING_SIGNAL_NO_GENERIC
configure_hdl_tag -disable -tag SYN_SYNC_ACTIVE_LOW
configure_hdl_tag -disable -tag CODING_RST_FIRSTLINE
configure_hdl_tag -disable -tag SYN_EXPR_UNSYNTH_REAL
configure_hdl_tag -disable -tag CODING_DFT_SCAN_EN_CNTRBLE
configure_hdl_tag -disable -tag CODING_DECL_SIZE_MISSING

# output signal used in internal module
configure_hdl_tag -disable -tag CODING_HW_REENTRANT_PATH

configure_hdl_tag -disable -tag SEQ_RST_CONST_CONN
configure_hdl_tag -disable -tag CODING_COMMENT_AUTHOR_HEADER
configure_hdl_tag -disable -tag CODING_COMMENT_DATE_HEADER
configure_hdl_tag -disable -tag CODING_COMMENT_EDIT_HEADER
configure_hdl_tag -disable -tag CODING_COMMENT_FILE_NAME_HEADER
configure_hdl_tag -disable -tag CODING_COMMENT_FUNCTION_HEADER
configure_hdl_tag -disable -tag CODING_COMMENT_LINE_TYPE
configure_hdl_tag -disable -tag CODING_COMMENT_TYPE_HEADER
configure_hdl_tag -disable -tag CODING_DECL_COMMENT
configure_hdl_tag -disable -tag CODING_DECL_SIGNAL_LOWER_CASE
configure_hdl_tag -disable -tag CODING_DECL_USE_LOGIC
configure_hdl_tag -disable -tag CODING_EXPR_DLY_FF
configure_hdl_tag -disable -tag CODING_EXPR_SELF_ASSIGN
configure_hdl_tag -disable -tag CODING_INDENT_IMPROPER
configure_hdl_tag -disable -tag CODING_INDENT_NO_TAB
configure_hdl_tag -disable -tag CODING_INST_CASE_SENSITIVE
configure_hdl_tag -disable -tag CODING_MODULE_NAME_CASE_SENSITIVE
configure_hdl_tag -disable -tag CODING_NAME_ACTIVEHIGH_RST
configure_hdl_tag -disable -tag CODING_NAME_ACTIVELOW_RST
configure_hdl_tag -disable -tag CODING_NAME_ASYNC_RST
configure_hdl_tag -disable -tag CODING_NAME_CLOCK
configure_hdl_tag -disable -tag CODING_NAME_FF_OUT
configure_hdl_tag -disable -tag CODING_NAME_FUNC
configure_hdl_tag -disable -tag CODING_NAME_MAX_CHAR
configure_hdl_tag -disable -tag CODING_NAME_SYNC_RST
configure_hdl_tag -disable -tag CODING_NAMING_ACTIVE_LOW_POLARITY
configure_hdl_tag -disable -tag CODING_NAMING_INST_NUMPREFIX
configure_hdl_tag -disable -tag CODING_PARAMETER_NOT_USED
configure_hdl_tag -disable -tag CODING_PARAMETER_UPPER_CASE
configure_hdl_tag -disable -tag CODING_PORT_FDTHROU
configure_hdl_tag -disable -tag CODING_PORT_NO_OF_PORTS
configure_hdl_tag -disable -tag CODING_SIGNAL_LOWER_CASE
configure_hdl_tag -disable -tag NAMING_ARRAY_NOT_HARD_CODED
configure_hdl_tag -disable -tag NAMING_CASE_PARAM_ITEM
configure_hdl_tag -disable -tag CONN_NET_HEAVY_FANOUT

configure_hdl_tag -disable -tag CODING_ALWAYS_DONT_USE_ALWAYS_FF
configure_hdl_tag -disable -tag CODING_ALWAYS_NO_ELSE
configure_hdl_tag -disable -tag CODING_CASE_INCOMPLETE
configure_hdl_tag -disable -tag CODING_CLOCK_POS_EDGE
configure_hdl_tag -disable -tag CODING_CONSTANT_VAL_XZ
configure_hdl_tag -disable -tag CODING_DECL_BITS_BACKWARD
configure_hdl_tag -disable -tag CODING_PORT_BIDIR
configure_hdl_tag -disable -tag CODING_PORTMAP_NO_LOGICEXPR
configure_hdl_tag -disable -tag CODING_RANGE_DESCENDING
configure_hdl_tag -disable -tag CODING_STMT_ARITH_IFEXPR
configure_hdl_tag -disable -tag CODING_STMT_NO_DIV
configure_hdl_tag -disable -tag SIMSYN_STMT_X_ASSIGN
configure_hdl_tag -disable -tag SYN_EXPR_STRING
configure_hdl_tag -disable -tag SYN_STMT_TASKCALL
configure_hdl_tag -disable -tag SYN_EXPR_SHIFT_OP

configure_unobservable_logic_identification -blackbox_endpoints yes
