test:
	@echo "Start to compile"
	vcs -full64 -f ~/prj/adc_capture/hw/filelist/sim.f -debug_access+all +lint=TFIPC-L -l com.log
	@echo "End to compile"
	@echo "Start to simulate"
	./simv +fsdb+region -l jlsemi_util_clkdiv_odd_tb.log
	@echo "End of run simulation"

waveform:
	verdi -f ~/prj/adc_capture/hw/filelist/sim.f -ssf -sswr &

filelist:
	verdi -f ~/prj/adc_capture/hw/filelist/rtl.f -ssf -sv &

clean:
	rm -rf *.log *.rc *.conf verdiLog ucli.key simv.daidir simv csrc jlsemi_util_clkdiv_odd_tb.fsdb
