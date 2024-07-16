configure_console_messages  -show both -tags [ get_tags -app DESIGN ]

# configure_lint_tag -enable -tag *

#### Enabling/Disabling VC Spyglass LINT tags
#### configure_lint_tag -enable -tag "<tag_name>" -goal <goal_name>
#### configure_lint_tag_parameter -tag "<tag_name>" -parameter <parameter_name> -value {<value>} -goal <goal_name>
#### configure_lint_setup -goal <goal_name>

configure_lint_tag -enable -tag -goal custom_rtl_handoff -severity Info
