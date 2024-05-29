export BASE_DIR=$(abspath .)
base_dir=$(BASE_DIR)
rtl_dir := $(base_dir)/hw/rtl
csv_dir := $(base_dir)/doc

# ********************************************************************************************
# Generate filelist for synthesis and simulation
# ********************************************************************************************
syn_filelist := $(rtl_dir)/rtl_syn.f
sim_filelist := $(rtl_dir)/rtl_sim.f

filelist: rtl_syn rtl_sim
rtl_syn:
	@mkdir -p $(base_dir)/builds/filelist
	@echo "Generating rtl_syn.f to absolute paths in $(base_dir)/builds/filelist/rtl_syn.f"
	@cd $(rtl_dir) && cat $(syn_filelist) | while read -r line; do \
		if [ -n "$$line" ]; then \
			realpath "$$line" >> $(base_dir)/builds/filelist/rtl_syn.f; \
		fi \
	done
rtl_sim:
	@echo "Generating rtl_sim.f to absolute paths in $(base_dir)/builds/filelist/rtl_sim.f"
	@cd $(rtl_dir) && cat $(sim_filelist) | while read -r line; do \
		if [ -n "$$line" ]; then \
			realpath "$$line" >> $(base_dir)/builds/filelist/rtl_sim.f; \
		fi \
	done
	@echo "Conversion rtl_syn.f rtl_sim.f completed."

clean:
	rm -rf $(base_dir)/builds/filelist	
