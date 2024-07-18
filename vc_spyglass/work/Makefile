# Define Work Directory
base_dir		=	$(abspath .)
parent_dir		=	$(dir $(base_dir))
script_dir		=	$(parent_dir)/script
lint_script_dir =	$(script_dir)/check_lint
lint_hdl_script_dir =	$(script_dir)/check_lint_hdl
lint_all_script_dir =	$(script_dir)/check_lint_all
cdc_script_dir 	= 	$(script_dir)/cdc
rdc_script_dir 	= 	$(script_dir)/rdc

# Capture design
TOP_MODULE 		= 	$(shell tclsh config.tcl | grep -E "^set top module:" | sed -E 's/set top module: *//')

# ---------------------------------------------------------------------------------------------------
# Lint
# ---------------------------------------------------------------------------------------------------
# Lint
check_lint:
	vc_static_shell -f $(lint_script_dir)/run_vs_lint.tcl -output_log_file ./run_vs_lint.log

# Lint-Hdl
check_lint_hdl:
	vc_static_shell -f $(lint_hdl_script_dir)/run_vs_lint_hdl.tcl -output_log_file ./run_vs_lint_hdl.log

# ---------------------------------------------------------------------------------------------------
# SDC Constraints Check
# ---------------------------------------------------------------------------------------------------
check_sdc:

# ---------------------------------------------------------------------------------------------------
# CDC rules Check
# ---------------------------------------------------------------------------------------------------
check_cdc:

# ---------------------------------------------------------------------------------------------------
# RDC rules Check
# ---------------------------------------------------------------------------------------------------
check_rdc:

# ---------------------------------------------------------------------------------------------------
# DFT rules Check
# ---------------------------------------------------------------------------------------------------
check_dft:

# ---------------------------------------------------------------------------------------------------
# Power rules Check
# ---------------------------------------------------------------------------------------------------
check_power:

# ---------------------------------------------------------------------------------------------------
# View the results with GUI mode
# ---------------------------------------------------------------------------------------------------



clean:
	rm -rf *.log *.rpt *.conf *.rc *.bak WORK *_cpdb *_rtdb *_libs *.json ../report/report_lint/* ../waiver/* verdiLog
