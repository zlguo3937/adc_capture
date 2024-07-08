# Define Work Directory
base_dir		=	$(abspath .)
parent_dir		=	$(dir $(base_dir))
script_dir		=	$(parent_dir)/scripts
lint_script_dir =	$(script_dir)/lint
cdc_script_dir 	= 	$(script_dir)/cdc
rdc_script_dir 	= 	$(script_dir)/rdc

# Capture TOP_MODULE
TOP_MODULE 		= 	$(shell tclsh Config.tcl | grep -E "^set top module:" | sed -E 's/set top module: *//')

# ---------------------------------------------------------------------------------------------------
# Lint
# ---------------------------------------------------------------------------------------------------
# Initial Lint
check_lint_init:
	spyglass -shell -tcl $(lint_script_dir)/sg_lint_init.tcl

# Advanced Lint
check_lint_adv:
	spyglass -shell -tcl $(lint_script_dir)/sg_lint_adv.tcl

# All Lint
check_lint_all:
	spyglass -shell -tcl $(lint_script_dir)/sg_lint.tcl

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
lint_gui:
	spyglass -project $(TOP_MODULE)_sg_lint.prj &

lint_init_gui:
	spyglass -project $(TOP_MODULE)_sg_lint_init.prj &

lint_adv_gui:
	spyglass -project $(TOP_MODULE)_sg_lint_adv.prj &

check_sdc_gui:
	spyglass -project $(TOP_MODULE)_check_sdc.prj &

cdc_gui:
	spyglass -project $(TOP_MODULE)_cdc.prj &

rdc_gui:
	spyglass -project $(TOP_MODULE)_rdc.prj &

dft_gui:
	spyglass -project $(TOP_MODULE)_dft.prj &

power_gui:
	spyglass -project $(TOP_MODULE)_power.prj &



clean:
	rm -rf *.log spyglass-1 *_sg_lint *_sg_cdc *_sg_rdc spyglass-* *.prj ../reports/* $(TOP_MODULE)*
