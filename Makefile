export BASE_DIR=$(abspath .)
base_dir=$(BASE_DIR)
rtl_dir := $(base_dir)/hw/rtl
csv_dir := $(base_dir)/doc
script_dir := $(base_dir)/script

# ********************************************************************************************
# prepare - generate all files for project
# ********************************************************************************************
prepare: clean yaml verilog filelist

# ********************************************************************************************
# Generate filelist for synthesis and simulation
# ********************************************************************************************
filelist:
	@mkdir -p $(base_dir)/builds/filelist
	@echo "Generating filelist to absolute paths in $(base_dir)/builds/filelist/"
	@python3 $(script_dir)/yml2list/gen_filelist.py $(BASE_DIR)/project.yml $(BASE_DIR)/builds/filelist/

# ********************************************************************************************
# Generate regfile yaml
# ********************************************************************************************
yaml:
	@mkdir -p $(base_dir)/builds/yaml
	@python3 $(script_dir)/csv2yml/csv_2_yaml.py $(csv_dir)/top_regfile.csv $(base_dir)/builds/yaml/top_regfile.yml
	@echo "Conversion top_regfile.yml successfully!"

# ********************************************************************************************
# Generate regfile verilog
# ********************************************************************************************
verilog:
	@mkdir -p $(base_dir)/builds/verilog
	@python3 $(script_dir)/yml2hdl/yml2verilog.py $(base_dir)/builds/yaml/top_regfile.yml $(base_dir)/builds/verilog/top_regfile.v top_regfile

# ********************************************************************************************
# Delete builds/* and any other files not be used
# ********************************************************************************************
clean:
	rm -rf $(base_dir)/builds/filelist/* $(base_dir)/builds/verilog/* $(base_dir)/builds/yaml/*
