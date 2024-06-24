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

// TITLE: UVM HDL Backdoor Access support routines.
//
// These routines provide an interface to the DPI/PLI
// implementation of backdoor access used by registers.
//
// If you DON'T want to use the DPI HDL API, then compile your
// SystemVerilog code with the vlog switch
//:   vlog ... +define+UVM_HDL_NO_DPI ...
//


`ifndef UVM_HDL__SVH
`define UVM_HDL__SVH

`ifdef VCSMX_FAST_UVM
`define uvm_context_prop
`else
`define uvm_context_prop context
`endif

`ifndef UVM_HDL_MAX_WIDTH
`define UVM_HDL_MAX_WIDTH 1024
`endif

/* 
 * VARIABLE: UVM_HDL_MAX_WIDTH
 * Sets the maximum size bit vector for backdoor access. 
 * This parameter will be looked up by the 
 * DPI-C code using:
 *   vpi_handle_by_name(
 *     "uvm_pkg::UVM_HDL_MAX_WIDTH", 0);
 */
parameter int UVM_HDL_MAX_WIDTH = `UVM_HDL_MAX_WIDTH;


typedef logic [UVM_HDL_MAX_WIDTH-1:0] uvm_hdl_data_t;

                            
`ifndef UVM_HDL_NO_DPI

  // Function: uvm_hdl_check_path
  //
  // Checks that the given HDL ~path~ exists. Returns 0 if NOT found, 1 otherwise.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_check_path(string path);


  // Function: uvm_hdl_deposit
  //
  // Sets the given HDL ~path~ to the specified ~value~.
  // Returns 1 if the call succeeded, 0 otherwise.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_deposit(string path, uvm_hdl_data_t value);

`ifdef UVM_HDL_REAL_FUNC  

  // Function: uvm_hdl_deposit_real
  // Sets the given HDL ~path~ to the specified ~value(Real type)~.

  import "DPI-C" `uvm_context_prop function int uvm_hdl_deposit_real(string path, real value);
`endif

  // Function: uvm_hdl_force
  //
  // Forces the ~value~ on the given ~path~. Returns 1 if the call succeeded, 0 otherwise.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_force(string path, uvm_hdl_data_t value);

`ifdef UVM_HDL_REAL_FUNC
  // Function: uvm_hdl_force_real;
  // Forces the ~value(Real type)~ on the given ~path~. Returns 1 if the call succeeded, 0 otherwise.

  import "DPI-C" `uvm_context_prop function int uvm_hdl_force_real(string path, real value);
`endif

`ifdef UVM_HDL_REAL_FUNC
// Function -- NODOCS -- uvm_hdl_force_time_real
  //
  // Forces the ~value~ on the given ~path~ for the specified amount of ~force_time~.
  // If ~force_time~ is 0, <uvm_hdl_deposit> is called.
  // Returns 1 if the call succeeded, 0 otherwise.
  //
  task uvm_hdl_force_time_real(string path, real value, time force_time = 0);
    if (force_time == 0) begin
      void'(uvm_hdl_deposit_real(path, value));
      return;
    end
    if (!uvm_hdl_force_real(path, value))
      return;
    #force_time;
    void'(uvm_hdl_release_and_read_real(path, value));
  endtask
`endif


  // Function: uvm_hdl_force_time
  //
  // Forces the ~value~ on the given ~path~ for the specified amount of ~force_time~.
  // If ~force_time~ is 0, <uvm_hdl_deposit> is called.
  // Returns 1 if the call succeeded, 0 otherwise.
  //
  task uvm_hdl_force_time(string path, uvm_hdl_data_t value, time force_time = 0);
    if (force_time == 0) begin
      void'(uvm_hdl_deposit(path, value));
      return;
    end
    if (!uvm_hdl_force(path, value))
      return;
    #force_time;
    void'(uvm_hdl_release_and_read(path, value));
  endtask


  // Function: uvm_hdl_release_and_read
  //
  // Releases a value previously set with <uvm_hdl_force>.
  // Returns 1 if the call succeeded, 0 otherwise. ~value~ is set to
  // the HDL value after the release. For 'reg', the value will still be
  // the forced value until it has been procedurally reassigned. For 'wire',
  // the value will change immediately to the resolved value of its
  // continuous drivers, if any. If none, its value remains as forced until
  // the next direct assignment.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_release_and_read(string path, inout uvm_hdl_data_t value);

 `ifdef UVM_HDL_REAL_FUNC

  // Function: uvm_hdl_release_and_read_real
  //
  // Releases a value (Real type) previously set with <uvm_hdl_force>.
  // Returns 1 if the call succeeded, 0 otherwise. ~value~ is set to
  // the HDL value after the release. The value will still be
  // the forced value until it has been procedurally reassigned.
  //

  import "DPI-C" `uvm_context_prop function int uvm_hdl_release_and_read_real(string path, inout real value);
`endif

  // Function: uvm_hdl_release
  //
  // Releases a value previously set with <uvm_hdl_force>.
  // Returns 1 if the call succeeded, 0 otherwise.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_release(string path);

`ifdef UVM_HDL_REAL_FUNC
  // Function: uvm_hdl_release_real
  //
  // Releases a value(real type) previously set with <uvm_hdl_force>.
  // Returns 1 if the call succeeded, 0 otherwise.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_release_real(string path);
`endif

  // Function: uvm_hdl_read()
  //
  // Gets the value at the given ~path~.
  // Returns 1 if the call succeeded, 0 otherwise.
  //
  import "DPI-C" `uvm_context_prop function int uvm_hdl_read(string path, output uvm_hdl_data_t value);

`ifdef UVM_HDL_REAL_FUNC

  // Function: uvm_hdl_read_real()
  // Gets the value (real type) at the given ~path~. 

  import "DPI-C" `uvm_context_prop function int uvm_hdl_read_real(string path, output real value);
`endif  

  import "DPI-C" `uvm_context_prop function string uvm_hdl_read_string(string path);

  import "DPI-C" `uvm_context_prop function int uvm_memory_load(string nid, string scope, string fileName, string radix, string startaddr, string endaddr, string types);

`else

  function int uvm_hdl_check_path(string path);
    uvm_report_fatal("UVM_HDL_CHECK_PATH", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction

  function int uvm_hdl_deposit(string path, uvm_hdl_data_t value);
    uvm_report_fatal("UVM_HDL_DEPOSIT", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction

`ifdef UVM_HDL_REAL_FUNC
 function int  uvm_hdl_deposit_real(string path, real value);
    uvm_report_fatal("UVM_HDL_DEPOSIT_REAL", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction
`endif

  function int uvm_hdl_force(string path, uvm_hdl_data_t value);
    uvm_report_fatal("UVM_HDL_FORCE", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction

`ifdef UVM_HDL_REAL_FUNC
  function int uvm_hdl_force_REAL(string path, real value);
    uvm_report_fatal("UVM_HDL_FORCE_REAL", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction
`endif

  task uvm_hdl_force_time(string path, uvm_hdl_data_t value, time force_time=0);
    uvm_report_fatal("UVM_HDL_FORCE_TIME", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
  endtask

  function int uvm_hdl_release(string path, output uvm_hdl_data_t value);
    uvm_report_fatal("UVM_HDL_RELEASE", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction

`ifdef UVM_HDL_REAL_FUNC
  function int uvm_hdl_release_real(string path, output real value);
    uvm_report_fatal("UVM_HDL_RELEASE_REAL", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction
`endif

  function int uvm_hdl_read(string path, output uvm_hdl_data_t value);
    uvm_report_fatal("UVM_HDL_READ", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction

`ifdef UVM_HDL_REAL_FUNC
  function int uvm_hdl_read_real(string path, output real value);
    uvm_report_fatal("UVM_HDL_READ_REAL", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
    return 0;
  endfunction
`endif

  function string uvm_hdl_read_string(string path);
    uvm_report_fatal("UVM_HDL_READ_STRING", 
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
//    string result="";
    return "";
  endfunction

  function int uvm_memory_load(string nid, string scope, string fileName, string radix, string startaddr, string endaddr, string type1);
    uvm_report_fatal("UVM_MEMORY_READ",
      $sformatf("uvm_hdl DPI routines are compiled off. Recompile without +define+UVM_HDL_NO_DPI"));
  endfunction

`endif


`endif
