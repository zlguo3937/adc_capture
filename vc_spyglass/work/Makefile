# Define Work Directory
base_dir		=	$(abspath .)
parent_dir		=	$(dir $(base_dir))
script_dir		=	$(parent_dir)/script
lint_script_dir =	$(script_dir)/check_lint
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
	vc_static_shell -f $(lint_script_dir)/run_vs_lint_hdl.tcl -output_log_file ./run_vs_lint_hdl.log

# All Lint
check_lint_all:
	vc_static_shell -f $(lint_script_dir)/run_vs_lint_hdl.tcl -f $(lint_script_dir)/run_vs_lint.tcl -output_log_file ./run_vs_lint_all.log

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
	rm -rf *.log *.conf *.rc vcst_rtdb *.bak WORK
