test:
	@echo "Start to compile"
	vcs +v2k -sverilog \
	-timescale=1ns/1ns \
	-f ../../builds/filelist/rtl_sim.f \
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
	verdi -f ../../builds/filelist/rtl_sim.f -sv -top tb_ASIC &

filelist:
	verdi -f ../../builds/filelist/rtl_sim.f -sv -top ASIC &

filelist_syn:
	verdi -f ../../builds/filelist/rtl_syn.f -sv -top ASIC &

filelist_fpga:
	verdi -f ../../builds/filelist/rtl_fpga.f -sv -top ASIC &

clean:
	rm -rf *.log *.conf verdiLog ucli.key simv.daidir simv csrc *.fsdb *.fsdb.* *.conf *.txt *.rc *.vf
