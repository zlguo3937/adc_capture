//------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//   
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//   
//       http://www.apache.org/licenses/LICENSE-2.0
//   
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------


`ifndef UVM_DPI_SLED__SVH
`define UVM_SPI_SLED__SVH

`ifdef VCSMX_FAST_UVM
`define uvm_context_prop
`else
`define uvm_context_prop context
`endif


`ifndef UVM_SLED_NO_DPI
 import "DPI-C" context function void sled_log(string stream, int severity, const char* message, longint unsigned timestamp, bit different_stream);

`else
 function void sled_log(string stream, char* severity, const char* message, longint unsigned timestamp, different_stream);
    uvm_report_fatal("UVM_SLED",
    $sformatf("uvm_sled DPI routines are compiled off. "));
 endfunction

`endif

`endif
