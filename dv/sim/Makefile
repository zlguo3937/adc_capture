test:
	@echo "Start to compile"
	vcs -full64 +v2k \
	-timescale=1ns/1ns \
	-f ~/prj/adc_capture/hw/filelist/sim.f \
	-debug_access+all -debug_region=cell+lib \
	+lint=TFIPC-L \
	-top tb_ASIC \
	+define+UNIT_DELAY \
	-l com.log
	@echo "End to compile"
	@echo "Start to simulate"
	./simv +fsdb+region -l tb_ASIC.log
	@echo "End of run simulation"

waveform:
	verdi -f ~/prj/adc_capture/hw/filelist/sim.f -sv -top tb_ASIC &

filelist:
	verdi -f ~/prj/adc_capture/hw/filelist/rtl.f -sv -top ASIC &

clean:
	rm -rf *.log *.conf verdiLog ucli.key simv.daidir simv csrc *.fsdb *.fsdb.*
