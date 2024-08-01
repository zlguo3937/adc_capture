TARGET_FOLDER := adc_capture
IGNORE_FOLDER := adc_capture.gen

adc_prj_batch:
	mkdir -p adc_capture
	vivado -mode batch -source ./adc_capture_prj.tcl -log ./adc_capture/vivado.log -jou ./adc_capture/vivado.jou

adc_prj_gui:
	mkdir -p adc_capture
	vivado -mode gui -source ./adc_capture_prj.tcl -log ./adc_capture/vivado.log -jou ./adc_capture/vivado.jou &

clean:
	@echo "Deleting all files in $(TARGET_FOLDER), except $(IGNORE_FOLDER)"
	@rm -rf *.log *.jou *.str .Xil compile.prj local xar.prj .cxl* *.bak *.vf *.fsdb *.key
	@for file in $(TARGET_FOLDER)/*; do \
		if [ "$$(basename $$file)" != "$(IGNORE_FOLDER)" ]; then \
			rm -rf "$$file"; \
			echo "Deleted: $$file"; \
		else \
			echo "Ignored: $$file"; \
		fi \
	done
	@echo "Deletion complete, ignored folder: $(IGNORE_FOLDER)"

clean_compile_simlib:
	rm -rf compile_simlib

clean_prj:
	rm -rf *.log *.jou *.str adc_capture .Xil compile.prj local xar.prj .cxl* *.bak *.vf *.fsdb *.key

clean_all:
	rm -rf *.log *.jou *.str adc_capture compile_simlib .Xil compile.prj local xar.prj .cxl* *.bak *.vf *.fsdb *.key
