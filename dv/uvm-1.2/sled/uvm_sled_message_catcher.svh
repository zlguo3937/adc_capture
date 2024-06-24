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
`ifndef UVM_SLED_MESSAGE_CATCHER_SVH
`define UVM_SLED_MESSAGE_CATCHER_SVH
//================================
// Report Catacher Implementations
//================================

`include "macros/uvm_global_defines.svh"

class sled_msglog;
 static function string map_name(string text);
   string result;
   if (text[0]>="0" && text[0]<="9")  // msglog does not accept 0-9 in the first character
     result = {"_",text};  
   else 
     result = text;

   foreach(result[i]) begin
     if (!( (result[i]>="a" && result[i]<="z") ||
            (result[i]>="A" && result[i]<="Z") ||
            (result[i]>="0" && result[i]<="9") ||
            (result[i]=="_")))
       if (result[i]==".") 
        result[i] = "$";  // use "#" to denote testbench logical hierarchy separator
       else  
        result[i] = "_";
   end
   return result;
 endfunction

endclass

class uvm_capture_phase_cb extends uvm_phase_cb;
`uvm_object_utils(uvm_capture_phase_cb)

static string m_current_phase = "";

function new(string name="unnamed-uvm_phase_cb");
    super.new(name);
endfunction : new    

function void phase_state_change(uvm_phase phase, uvm_phase_state_change change);
m_current_phase = phase.get_name();

endfunction
endclass



class sled_report_catcher extends uvm_report_catcher;
`uvm_object_utils(sled_report_catcher)
//    int sled_catcher_counter = 0;
    `uvm_register_cb(sled_report_catcher, uvm_capture_phase_cb)
    int sled_catcher_counter = 0; 
    uvm_capture_phase_cb ub;
    uvm_domain domains[string];
    uvm_domain common;
    uvm_phase phases[$];


    //declarate callback class handle


    function new(string name = "verdi_sled_catcher");
        super.new(name);
        ub = new();
        common = uvm_domain::get_uvm_domain();
//        uvm_domain::get_domains(domains);
//        foreach(domains[c]) begin
        common.m_get_transitive_children(phases);
        foreach(phases[c]) begin
        uvm_phase_cb_pool::add(phases[c], uvm_capture_phase_cb::type_id::create("uvm_capture_phase_cb"));


//        end
        end
    endfunction    
    

    virtual function action_e catch();

    static uvm_cmdline_processor sled_clp;
    string stream, msg_name, msg, finfo, title,id;
    string tr_args[$];
    bit different_stream;

    uvm_report_object client;
//    uvm_phase_cb_pool::add(phase, uvm_capture_phase_cb::type_id::create("uvm_capture_phase_cb"));
    sled_clp = uvm_cmdline_processor::get_inst();

//     uvm_phase_cb_pool::add(bld, uvm_capture_phase_cb::type_id::create("uvm_capture_phase_cb"));




    if (get_fname() != "")
    finfo = $psprintf("%s(%0d):", get_fname(), get_line());
      else    
          finfo = "";
      msg_name = "report_server";

      msg = { finfo, get_message()};
      if(sled_clp.get_arg_matches("+UVM_SLED_DIFFERENT_STREAM", tr_args)) begin
          different_stream = 1;
      end
      if(sled_clp.get_arg_matches("+UVM_SLED_PHASE_STREAM", tr_args)) begin
          $sformat(stream, "LOG.%0s", get_id());
    //      stream   = sled_msglog::map_name(stream);
          if(uvm_capture_phase_cb::m_current_phase != "")
            `uvm_sled_msglog_decode(uvm_capture_phase_cb::m_current_phase, get_verbosity(), get_severity(), msg, different_stream)
       end       
       else begin
           $sformat(stream, "LOG.%0s", get_id());
           stream   = sled_msglog::map_name(stream);
      `uvm_sled_msglog_decode(stream, get_verbosity(), get_severity(), msg, different_stream)
      end
      catch = action_e'(get_action());
      catch = ((catch == UNKNOWN_ACTION) ? THROW : catch);
    endfunction
endclass :sled_report_catcher    





`endif
