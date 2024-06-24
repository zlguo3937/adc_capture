//-------------------------------------------------------------
//    Copyright 2011 Synopsys, Inc.
//    All Rights Reserved Worldwide
//
// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary work of 
// Synopsys, Inc., and is fully protected under copyright and trade 
// secret laws. You may not view, use, disclose, copy, or distribute this 
// file or any information contained herein except pursuant to a valid 
// written license from Synopsys. 
//
//-------------------------------------------------------------

`ifndef UVM_CUSTOM_INSTALL_SLED_RECORDER
`define UVM_CUSTOM_INSTALL_SLED_RECORDER

`ifdef _SNPS_UVM_PKG_GLOBAL_IMPORT_
`ifndef _SNPS_UVM_PKG_IMPORTED

 import uvm_pkg::*;

 import "DPI-C" function string getenv(input string env_name);

`define _SNPS_UVM_PKG_IMPORTED
`endif

`include "uvm_sled_msglog.svh"
`include "uvm_sled_msglog_report_server.sv"
//`include "uvm_sled_recorder.svh"
`include "uvm_sled_message_catcher.svh"

class uvm_phase_component extends uvm_component;
      `uvm_component_utils(uvm_phase_component)

      virtual function void start_of_simulation_phase(uvm_phase phase);
         uvm_component top_comp, root;
         uvm_component top_comps[$];
         root = uvm_root::get();

      endfunction

      function new (string name="PHASE", uvm_component parent);
         super.new(name, parent);
      endfunction
 endclass
   

module uvm_custom_install_sled_recording;
`else 

//`include "uvm_sled_msglog.svh"
`include "uvm_sled_msglog_report_server.sv"

module uvm_custom_install_sled_recording;

import uvm_pkg::*;

import "DPI-C" function string getenv(input string env_name);

//`include "uvm_sled_recorder.svh"
`include "uvm_sled_message_catcher.svh"

`endif 

//static int user_verbosity = UVM_MEDIUM; 
//`include "uvm_macros.svh"

  static uvm_cmdline_processor sled_clp;

  string tr_args[$];
  uvm_coreservice_t cs;
  string rand_state;
//  uvm_sled_tr_database sled_db;
  string env_str,vc_env_str="",sanity_file_name="", env_auto_run="";
  int file_handle=0, is_sanity_exist=0;

  initial begin

    sled_clp = uvm_cmdline_processor::get_inst();
    cs = uvm_coreservice_t::get();
    vc_env_str = getenv("VCS_HOME");
    env_str = getenv("SLED_BACKEND");
    env_auto_run = getenv("SLED_AUTORUN");
    vc_env_str = getenv("VC_HOME");
    if (vc_env_str!="") begin
        sanity_file_name = {vc_env_str,"/etc/.sanity"};
        file_handle = $fopen(sanity_file_name,"r");
        if (file_handle!=0) begin
            is_sanity_exist = 1;
            $fclose(file_handle);
         end
     end

     if(env_auto_run != "" && !sled_clp.get_arg_matches("+UVM_VCS_SLED_TRACE_OFF", tr_args)) begin
         static sled_report_catcher _sled_catcher = new();
         uvm_report_cb::add(null,_sled_catcher);
         uvm_config_db#(uvm_bitstream_t)::set(uvm_root::get(), "*", "recording_detail", UVM_FULL);

     end    
end
endmodule

`endif // UVM_CUSTOM_INSTALL_SLED_RECORDER

