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
