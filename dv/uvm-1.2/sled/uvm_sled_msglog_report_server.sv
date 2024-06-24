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

`ifndef UVM_SLED_MSGLOG_REPORT_SERVER 
`define UVM_SLED_MSGLOG_REPORT_SERVER
  
import "DPI-C" function void sled_log(input string stream, input int severity, input string message, input longint unsigned timestamp, input bit different_stream );  
// define macros since $msglog does not accept args for msg_type or msg_severity
`define uvm_sled_msglog_oneshot(stream, typ,  sev, msg, different_stream) \
  begin \
    sled_log(stream, sev,msg, $time, different_stream);\
  end

// decode verbosity and severity
// according to ./base/uvm_object_globals.svh, severity:
//   UVM_INFO=0, UVM_WARNING=1, UVM_ERROR=2, UVM_FATAL=3
// according to ./base/uvm_object_globals.svh, verbosity:
//   UVM_NONE=0, UVM_LOW=100, UVM_MEDIUM=200, UVM_HIGH=300, UVM_FULL=400, UVM_DEBUG=500
`define uvm_sled_msglog_decode(stream, typ,  sev,  msg, different_stream) \
  case (sev) \
    3 : `uvm_sled_msglog_oneshot(stream, FAILURE, 3,  msg, different_stream) \
    2 : `uvm_sled_msglog_oneshot(stream, FAILURE, 2,  msg, different_stream) \
    1 : `uvm_sled_msglog_oneshot(stream, FAILURE,  1,  msg, different_stream) \
    0 : `uvm_sled_msglog_oneshot(stream, NOTE, 0, msg, different_stream) \
    default : `uvm_sled_msglog_oneshot(stream, NOTE, 0, msg, different_stream) \
  endcase

`endif // UVM_MSGLOG_REPORT_SERVER 

