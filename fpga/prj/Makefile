adc_prj_batch:
	mkdir -p adc_capture
	vivado -mode batch -source ./adc_capture_prj.tcl -log ./adc_capture/vivado.log -jou ./adc_capture/vivado.jou

adc_prj_gui:
	mkdir -p adc_capture
	vivado -mode gui -source ./adc_capture_prj.tcl -log ./adc_capture/vivado.log -jou ./adc_capture/vivado.jou &

clean:
	rm -rf *.log *.jou *.str adc_capture .Xil compile.prj local synopsys_sim.setup xar.prj .cxl* *.bak
