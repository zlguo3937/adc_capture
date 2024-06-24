//
// -------------------------------------------------------------
//    Copyright 2004-2013 Synopsys, Inc.
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//
//-----------------------------------------------------------------
`protect
`ifndef SNPS_MACROS__SV
`define SNPS_MACROS__SV

`define UVM_VCS_ENC

`ifdef UVM_VCS_DTL
`define UVM_VCS_CHECK(if_expr) \
(if_expr) && (!uvm_root::snps_uvm_save_restore_enabled)
`else 
`define UVM_VCS_CHECK(if_expr) \
if_expr
`endif



  //VCS sets this variable to value 1 when using uvm save-restore flow.
  //Variable  snps_uvm_save_restore_enabled will be assigned value 1 when restoring the
  //simulation snashot.
`define UVM_VCS_DECLARATIONS \
`ifdef UVM_VCS_DTL \
  static bit snps_uvm_save_restore_enabled; \
\
  task refresh_test(string test_name=""); \
  \
    uvm_report_server l_rs; \
    uvm_factory factory=uvm_factory::get(); \
    bit testname_plusarg; \
    int test_name_count; \
    string test_names[$]; \
    string msg; \
    uvm_component old_uvm_test_top_comp; \
    uvm_component old_uvm_test_top_childs[$];\
    uvm_component uvm_test_top,new_uvm_test_top;\
  \
    process phase_runner_proc; // store thread forked below for final cleanup\
    uvm_cmdline_processor clp_inst; \
    clp_inst = uvm_cmdline_processor::get_inst(); \
   \
    //Indicates save-restore enabled and this variable used in uvm_component::new to disable the check related to creating components after build_phase.\
`ifdef UVM_VCS_DTL_RESEED \
   uvm_pkg::change_uvm_global_random_seed(); \
`endif \
    snps_uvm_save_restore_enabled=1;\
  \
    testname_plusarg = 0; \
  \
    old_uvm_test_top_comp=uvm_root::get().find("uvm_test_top"); \
    old_uvm_test_top_comp.get_children(old_uvm_test_top_childs); \
    // Set up the process that decouples the thread that drops objections from \
    // the process that processes drop/all_dropped objections. Thus, if the \
    // original calling thread (the "dropper") gets killed, it does not affect \
    // drain-time and propagation of the drop up the hierarchy. \
    // Needs to be done in run_test since it needs to be in an \
    // initial block to fork a process. \
    uvm_objection::m_init_objections(); \
  \
    // if test now defined, create it using common factory \
    if (test_name != "") begin \
    	uvm_factory factory = uvm_factory::get(); \
  \
      $cast(uvm_test_top, factory.create_component_by_name(test_name, "", "uvm_test_top", null)); \
  \
      if (uvm_test_top == null) begin \
        msg = testname_plusarg ? {"command line +UVM_TESTNAME=",test_name} : \
                                 {"call to run_test(",test_name,")"}; \
        uvm_report_fatal("INVTST", \
            {"Requested test from ",msg, " not found." }, UVM_NONE); \
      end \
    end \
  \
    if (m_children.num() == 0) begin \
      uvm_report_fatal("NOCOMP", \
            {"No components instantiated. You must either instantiate", \
             " at least one component before calling run_test or use", \
             " run_test to do so. To run a test using run_test,", \
             " use +UVM_TESTNAME or supply the test name in", \
             " the argument to run_test(). Exiting simulation."}, UVM_NONE); \
      return; \
    end \
  \
    begin \
    	if(test_name=="") \
    		uvm_report_info("RNTST", "Running test ...", UVM_LOW); \
    	else if (test_name == uvm_test_top.get_type_name()) \
    		uvm_report_info("RNTST", {"Running test ",test_name,"..."}, UVM_LOW); \
    	else \
    		uvm_report_info("RNTST", {"Running test ",uvm_test_top.get_type_name()," (via factory override for test \"",test_name,"\")..."}, UVM_LOW);\
    end \
    //Copy the old childs which are under uvm_test_top to the new test created \
    foreach(old_uvm_test_top_childs[i]) begin \
         void'(uvm_test_top.m_add_child(old_uvm_test_top_childs[i])); \
    end \
    $$shallow_copy(uvm_test_top,old_uvm_test_top_comp); \
    `ifdef UVM_VCS_DTL_REFRESH \
     uvm_test_top.vcs_call_refresh_component(); \
     `endif \
    clp_inst.refresh_args(); \
    m_do_factory_settings();\
  \
  endtask \
  `endif


`define UVM_VCS_GLOBAL_DECLARATIONS \
`ifdef UVM_VCS_DTL \
// task to support changing seeding when +ntb_random_seed is specified \
task change_uvm_global_random_seed; \
   if ($test$plusargs("ntb_random_reseed") && ($test$plusargs("ntb_random_seed_automatic") || $test$plusargs("ntb_random_seed") )) begin \
      `uvm_info("DTL/RESEED", "Changing UVM global random seed", UVM_HIGH); \
      `uvm_info("DTL/RESEED", $sformatf("Old UVM global random seed is %d", uvm_pkg::uvm_global_random_seed), UVM_HIGH);     \
       uvm_pkg::uvm_global_random_seed = $get_initial_random_seed(); \
`ifdef UVM_DIRECTC_OPTS       \
`ifdef UVM_SV_SEED \
       uvm_pkg::uvm_random_seed_table_lookup.delete(); \
`else \
       vc_uvmReseed(); \
`endif \
`else \
       uvm_pkg::uvm_random_seed_table_lookup.delete(); \
`endif     \
      `uvm_info("DTL/RESEED", $sformatf("New UVM global random seed is %d", uvm_pkg::uvm_global_random_seed), UVM_HIGH);     \
   end \
endtask:change_uvm_global_random_seed \
\
//task to support running different test after restore \
task refresh_test ; \
   string tname; \
   uvm_root root; \
   tname = ""; \
   root  = uvm_root::get(); \
  if($test$plusargs("UVM_TESTNAME")) begin \
    if($value$plusargs("UVM_TESTNAME=%s",tname)) begin \
        `uvm_info("REFRESH",$sformatf("UVM_TESTNAME provided at command line=%0s",tname),UVM_NONE); \
        root.refresh_test(tname); \
    end \
  end \
  else begin \
    `uvm_fatal("REFRESH","NO +UVM_TESTNAME specfied in command line, aborting simulation"); \
  end \
\
endtask \
\
`endif


`define UVM_VCS_CLP_TF \
`ifdef UVM_VCS_DTL \
function void refresh_args();\
  string s;\
  string sub;\
  int doInit  = 1; \
  do begin\
    s = uvm_dpi_get_next_arg(doInit);\
    doInit = 0; \
    if(s!="") begin\
      m_argv.push_front(s);\
      if(s[0] == "+") begin\
        m_plus_argv.push_front(s);\
      end \
\
      if(s.len() >= 4 && (s[0]=="-" || s[0]=="+")) begin\
        sub = s.substr(1,3);\
        sub = sub.toupper();\
        if(sub == "UVM")\
          m_uvm_argv.push_front(s);\
      end \
    end\
  end while(s!=""); \
  `uvm_info("DTL/REFRESH_ARGS", $sformatf("Command Line Arguments refreshed after loading new tests\nCached list of arguments is = %p", m_argv), UVM_FULL); \
endfunction \
`endif


`endif
`endprotect
