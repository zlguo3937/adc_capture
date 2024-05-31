export BASE_DIR=$(abspath .)
base_dir=$(BASE_DIR)
rtl_dir := $(base_dir)/hw/rtl
csv_dir := $(base_dir)/doc
syn_filelist := $(rtl_dir)/rtl_syn.f
sim_filelist := $(rtl_dir)/rtl_sim.f
script_dir := $(base_dir)/script

# ********************************************************************************************
# prepare - generate all files for project
# ********************************************************************************************
prepare: filelist yaml verilog

# ********************************************************************************************
# Generate filelist for synthesis and simulation
# ********************************************************************************************
filelist: rtl_syn rtl_sim
rtl_syn:
	@mkdir -p $(base_dir)/builds/filelist
	@echo "Generating filelist to absolute paths in $(base_dir)/builds/filelist/"
	@cd $(rtl_dir) && cat $(syn_filelist) | while read -r line; do \
		if [ -n "$$line" ]; then \
			realpath "$$line" >> $(base_dir)/builds/filelist/rtl_syn.f; \
		fi \
	done
	@echo "Conversion rtl_syn.f completed."
rtl_sim:
	@cd $(rtl_dir) && cat $(sim_filelist) | while read -r line; do \
		if [ -n "$$line" ]; then \
			realpath "$$line" >> $(base_dir)/builds/filelist/rtl_sim.f; \
		fi \
	done
	@echo "Conversion rtl_syn.f rtl_sim.f completed."

# ********************************************************************************************
# Generate regfile yaml
# ********************************************************************************************
yaml:
	@mkdir -p $(base_dir)/builds/yaml
	@python3 script_dir/csv2yml/csv_2_yaml.py csv_dir/top_regfile.csv $(base_dir)/builds/yaml/top_regfile.yml
	@echo "Conversion top_regfile.yml completed."

# ********************************************************************************************
# Generate regfile verilog
# ********************************************************************************************
verilog:
	python3 $(base_dir)/script/yml2verilog.py $(base_dir)/doc/config cfg.yml

# ********************************************************************************************
# Delete builds/* and any other files not be used
# ********************************************************************************************
clean:
	rm -rf $(base_dir)/builds/filelist	$(base_dir)/builds/yaml
