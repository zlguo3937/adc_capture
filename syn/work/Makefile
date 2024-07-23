compile_ultra:
	@mkdir -p ../report/syn
	dcnxt_shell -f ../script/run_syn.tcl | tee compile_ultra_syn.log

compile:
	@mkdir -p ../report/syn
	dc_shell -f ../script/run_syn.tcl | tee compile_syn.log

check_lec:
	@mkdir -p ../report/lec
	lec -tclmode -lp -nogui -do ../script/check_lec.do -log run_lec.log

dc_gui:
	design_vision &

clean:
	rm -rf cksum_dir *.log *.svf *.mr *.pvl *.syn ../unmapped/* ../mapped/* ../report/* alib-52 syn_work
