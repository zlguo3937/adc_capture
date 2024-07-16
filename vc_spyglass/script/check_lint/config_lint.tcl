configure_console_messages  -show both -tags [ get_tags -app DESIGN ]

# configure_lint_tag -enable -tag *

#### Enabling/Disabling VC Spyglass LINT tags
#### configure_lint_tag -enable -tag "<tag_name>" -goal <goal_name>
#### configure_lint_tag_parameter -tag "<tag_name>" -parameter <parameter_name> -value {<value>} -goal <goal_name>
#### configure_lint_setup -goal <goal_name>

configure_lint_tag -enable -tag "RegInputOutput-ML" -goal custom_rtl_handoff -severity Info
configure_lint_tag_parameter -tag "RegInputOutput-ML" -parameter CHKTOPMODULE -value {yes} -goal custom_rtl_handoff

configure_lint_tag -enable -tag "FlopEconst" -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "FlopEconst" -parameter REPORT_INFERRED_CELL -value {yes} -goal custom_rtl_handoff

configure_lint_tag -enable -tag -goal custom_rtl_handoff
configure_lint_tag -enable -tag -goal custom_rtl_handoff
configure_lint_tag -enable -tag -goal custom_rtl_handoff
configure_lint_tag -enable -tag -goal custom_rtl_handoff

configure_lint_tag -enable -tag -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff

configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Warning
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Error
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag_parameter -tag "" -parameter  -value {yes} -goal custom_rtl_handoff
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Warning
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
configure_lint_tag -enable -tag "" -goal custom_rtl_handoff -severity Error
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
