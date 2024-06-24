`ifndef UVM_VERDI_DUMP_HIER_TREE_SVH
`define UVM_VERDI_DUMP_HIER_TREE_SVH

typedef class uvm_port_component_base;
typedef class uvm_component;
typedef class uvm_config_object_wrapper;
typedef class uvm_port_base;


function bit is_verdi_trace_dht_used_by_sep(byte sep);
    string verdi_trace_values[$], split_values[$];
    static uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    static bit result = 0;

    void'(clp.get_arg_values("+UVM_VERDI_TRACE=",verdi_trace_values));
    foreach (verdi_trace_values[i]) begin
      uvm_split_string(verdi_trace_values[i], sep, split_values);
      foreach (split_values[j]) begin
        case (split_values[j])
          "HIER": result = 1;
          // "UVM_AWARE": result = 1; // 9001175642 turn off HIER tree by default
          "COMPWAVE": result = 1;
        endcase
      end
    end

    return result;
endfunction

function bit is_verdi_trace_dht_used();
    static bit is_verdi_trace_dht = 0;
    static bit is_verdi_trace_dht_checked = 0;

    if (is_verdi_trace_dht_checked==0) begin
        is_verdi_trace_dht_checked = 1;
        is_verdi_trace_dht = is_verdi_trace_dht_used_by_sep("|") || is_verdi_trace_dht_used_by_sep("+");
    end

    return is_verdi_trace_dht;
endfunction

// uvm_component::new part 1
function uvm_component_new_func(uvm_component uvm_this, string name, uvm_component parent, uvm_root top);
    uvm_port_component_base port_component;

    if (is_verdi_trace_dht_used() && !$cast(port_component, uvm_this)) begin
      string label, message, full_name, type_name;

      label = {"Creating ", name};
      full_name = {(parent==top?"":{parent.get_full_name(),"."}),name};
      type_name = uvm_this.get_type_name();
      $sformat(message,"label:%s name:%s full_name:%s type_name:%s full_type_name:%s",label,name,full_name,type_name,type_name);
      if (name!="DHIER_COMP") begin
          if (uvm_this.uvm_report_enabled(UVM_LOW, UVM_INFO, "SNPS_COMP_TRACE")) begin
              uvm_this.uvm_report_info("SNPS_COMP_TRACE", message, UVM_LOW, `uvm_file, `uvm_line);
          end
      end
    end
endfunction


// uvm_port_base::new
function uvm_port_base_new_func(string full_name, string type_name, string name);
        string label, message;

        label = {"Creating ", name};
        $sformat(message,"label:%s name:%s full_name:%s type_name:%s full_type_name:%s",label,name,full_name,type_name,type_name);
        if (uvm_report_enabled(UVM_LOW, UVM_INFO, "SNPS_PORT_TRACE")) begin
              uvm_report_info("SNPS_PORT_TRACE", message, UVM_LOW, `uvm_file, `uvm_line);
        end
endfunction

function uvm_port_base_connect_func(string this_get_name, string caller_name, string provider_get_name, string provider_get_full_name);
        string label, message, provider_name;

        label = {"Connecting ", this_get_name, " with ", provider_get_name};
        provider_name = provider_get_full_name;
        $sformat(message,"label:%s caller_name:%s provider_name:%s",label,caller_name, provider_name);
        if (uvm_report_enabled(UVM_LOW, UVM_INFO, "SNPS_PORT_CONN_TRACE")) begin
              uvm_report_info("SNPS_PORT_CONN_TRACE", message, UVM_LOW, `uvm_file, `uvm_line);
        end
endfunction


/*Begin set attribute support and dump to vcs, use for regression build*/
function bit is_verdi_trace_tlm_used_by_sep(byte sep);
    string verdi_trace_values[$], split_values[$];
    static uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    static bit result = 0;

    void'(clp.get_arg_values("+UVM_VERDI_TRACE=",verdi_trace_values));
    foreach (verdi_trace_values[i]) begin
      uvm_split_string(verdi_trace_values[i], sep, split_values);
      foreach (split_values[j]) begin
        case (split_values[j])
          "TLM": result = 1;
        endcase
      end
    end

    return result;
endfunction

function bit is_verdi_trace_tlm_used();
    static bit is_verdi_trace_tlm_checked = 0;
    static bit is_verdi_trace_tlm = 0;

    if (is_verdi_trace_tlm_checked==0) begin
        is_verdi_trace_tlm_checked = 1;
        is_verdi_trace_tlm = is_verdi_trace_tlm_used_by_sep("|")||is_verdi_trace_tlm_used_by_sep("+");
    end

    return is_verdi_trace_tlm;
endfunction

function bit is_verdi_recorder_enabled ();
    static uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    static bit is_verdi_recorder_option_checked = 0;
    static bit is_verdi_rec_enabled = 0; 
    string trace_args[$];

    if (!is_verdi_recorder_option_checked) begin
        is_verdi_recorder_option_checked = 1;

        if ((clp.get_arg_matches("+UVM_TR_RECORD",trace_args) &&
            clp.get_arg_matches("+UVM_VERDI_TRACE", trace_args))||is_verdi_trace_tlm_used())
            is_verdi_rec_enabled = 1;
    end
    return is_verdi_rec_enabled;
endfunction

// need add to "uvm_component::is_sequencer"
function bit uvm_component_is_sequencer(uvm_component comp);
    uvm_sequencer_base sqr_base;

    if ($cast(sqr_base,comp))
        return 1;
    else
        return 0;
endfunction

// need add to "uvm_component::is_driver"
function bit uvm_component_is_driver(uvm_component comp);
    string child_name;
    uvm_component child;
    uvm_port_component_base port;

    if (comp.get_first_child(child_name))
        do begin
           child = comp.get_child(child_name);
           if ($cast(port,child)) begin
               if (child_name=="seq_item_port"||child_name=="rsp_port")
                   return 1;
           end
        end while (comp.get_next_child(child_name));

    return 0;
endfunction

// need add to "uvm_component::check_component_type"
function string uvm_component_check_component_type(uvm_component thisN, uvm_component comp);
  string ret_str;
  ret_str = "TVM";

  if (uvm_component_is_sequencer(comp)/*rewrite flow will change it to uvm_component::is_sequencer*/)
      ret_str = "TVM:sequencer";
  if (uvm_component_is_driver(comp)/*rewrite flow will change it to uvm_component::is_driver*/)
      ret_str = "TVM:driver";

  return ret_str;
endfunction

function void uvm_component_create_stream_func(uvm_component thisN, uvm_transaction tr, string stream_name, ref uvm_tr_stream stream);
begin
    if (is_verdi_recorder_enabled()) begin
        string t_str;
        t_str = uvm_component_check_component_type(thisN, thisN)/*rewirte flow will change it to uvm_component::check_component_type*/;
        stream = thisN.get_tr_stream(stream_name,t_str);
        tr.enable_recording(stream); //9001476755
    end else
        stream = thisN.get_tr_stream(stream_name);
end
endfunction

function string uvm_tr_database_get_object_id(uvm_tr_database db, uvm_object obj);
    return "NULL";
endfunction

function void uvm_component_m_begin_tr_func(input uvm_component thisN, input uvm_transaction tr, uvm_tr_database db, ref string desc, ref string label, ref string kind);
    uvm_sequence_base seq_base;
    uvm_phase starting_phase;
    uvm_sequence_base parent_seq;
    uvm_sequence_item seq_item;
    static int parent_inst_id = 0;

    desc = {desc,
            $psprintf("Object ID: %0s (@%0d)\n", $vcs_get_object_id(tr), tr.get_inst_id()),
            $psprintf("Sequencer ID: %0s (@%0d)\n",  $vcs_get_object_id(thisN), thisN.get_inst_id())};

    if ($cast(seq_base,tr)) begin
      starting_phase = seq_base.get_starting_phase();
      desc = {desc,
              "Phase: ", starting_phase ? starting_phase.get_name() : "N/A", "\n"};
    end

    // No value for VCS transaction recording to display "Transactions"
    if (!is_verdi_recorder_enabled() && label == "Transactions")
        label = "";
    if (is_verdi_recorder_enabled())
    begin
        desc = {desc, //9001130255
            $psprintf("Object ID: %0s (@%0d)\n", uvm_tr_database_get_object_id(db, tr), tr.get_inst_id()),
            $psprintf("Sequencer ID: %0s (@%0d)\n", uvm_tr_database_get_object_id(db, thisN), thisN.get_inst_id())};
    if ($cast(seq_base,tr)) begin
        starting_phase = seq_base.get_starting_phase();
        desc = {desc,
                "Phase: ", starting_phase ? starting_phase.get_name() : "N/A", "\n"};
    end

    if ($cast(seq_base,tr)) begin
        parent_seq = seq_base.get_parent_sequence();
        if(parent_seq!=null) begin
            parent_inst_id = parent_seq.get_inst_id();
            desc = {desc,
                    $psprintf("Parent Sequence ID: %0d\n", parent_inst_id)};
        end
    end else if($cast(seq_item, tr)) begin
        parent_seq = seq_item.get_parent_sequence();
        if(parent_seq!=null) begin
            parent_inst_id = parent_seq.get_inst_id();
            desc = {desc,
                    $psprintf("Parent Sequence ID: %0d\n",  parent_inst_id)};
        end
    end
    end

    // Use 'kind' to pass the 'desc' during open_recorder() to record
    // the description in the initial $msglog(..., START) call for VCS
    if (!is_verdi_recorder_enabled()) begin
        kind = desc; // {kind, "\n", desc};
        desc = "";
    end
endfunction
/*End set attribute support and dump to vcs, use for regression build*/

//UVM aware part
function bit is_verdi_trace_aware_used_by_sep(byte sep);
    string verdi_trace_values[$], split_values[$];
    static uvm_cmdline_processor clp;
    static bit result = 0;

    clp = uvm_cmdline_processor::get_inst();
    void'(clp.get_arg_values("+UVM_VERDI_TRACE=",verdi_trace_values));
    foreach (verdi_trace_values[i]) begin
      uvm_split_string(verdi_trace_values[i], sep, split_values);
      foreach (split_values[j]) begin
        case (split_values[j])
          "UVM_AWARE": result = 1;
        endcase
      end
    end

    return result;
endfunction

function bit is_verdi_trace_aware_used();
    static bit is_verdi_trace_aware = 0;
    static bit is_verdi_trace_aware_checked = 0;

    if (is_verdi_trace_aware_checked==0) begin
        is_verdi_trace_aware_checked = 1;
        is_verdi_trace_aware = is_verdi_trace_aware_used_by_sep("|") || is_verdi_trace_aware_used_by_sep("+");
    end
    return is_verdi_trace_aware;
endfunction

function bit is_verdi_trace_no_implicit_get_used_by_sep(byte sep);
    string verdi_trace_values[$], split_values[$];
    static uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    static bit result = 0;

    void'(clp.get_arg_values("+UVM_VERDI_TRACE=",verdi_trace_values));
    foreach (verdi_trace_values[i]) begin
      uvm_split_string(verdi_trace_values[i], sep, split_values);
      foreach (split_values[j]) begin
        case (split_values[j])
          "NO_IMPLICIT_GET": result = 1;
        endcase
      end
    end

    return result;
endfunction

function bit is_verdi_trace_no_implicit_get_used();
    static bit is_verdi_trace_no_implicit_get = 0;
    static bit is_verdi_trace_no_implicit_get_checked = 0;

    if (is_verdi_trace_no_implicit_get_checked==0) begin
        is_verdi_trace_no_implicit_get_checked = 1;
        is_verdi_trace_no_implicit_get = is_verdi_trace_no_implicit_get_used_by_sep("|") || is_verdi_trace_no_implicit_get_used_by_sep("+");
    end

    return is_verdi_trace_no_implicit_get;
endfunction

function void uvm_component_apply_config_settings(uvm_component thisN, bit verbose, string name, uvm_resource_base r);
       string cfgapl_str = "", apl_val = "";
       uvm_resource#(uvm_integral_t) rit;
       uvm_cmdline_processor clp;
       string trace_args[$];

        // if(verbose)
        //   uvm_report_info("CFGAPL",$sformatf("applying configuration to field %s", name),UVM_NONE);
       clp = uvm_cmdline_processor::get_inst();
       $sformat(cfgapl_str,"applying configuration to field %s", name);
       if ($cast(rit, r)) begin
         thisN.set_int_local(name, rit.read(thisN));
         $sformat(apl_val," type=uvm_integral_t value=%0d",rit.read(thisN));
       end
       else begin
          uvm_resource#(uvm_bitstream_t) rbs;
          if($cast(rbs, r)) begin
            thisN.set_int_local(name, rbs.read(thisN));
            $sformat(apl_val," type=uvm_bitstream_t value=%0b",rbs.read(thisN));
          end
          else begin
             uvm_resource#(int) ri;
             if($cast(ri, r)) begin
               thisN.set_int_local(name, ri.read(thisN));
               $sformat(apl_val," type=int value=%0d",ri.read(thisN));
             end
             else begin
                uvm_resource#(int unsigned) riu;
                if($cast(riu, r)) begin
                  thisN.set_int_local(name, riu.read(thisN));
                  $sformat(apl_val," type=int unsigned value=%0d",riu.read(thisN));
                end
                else begin
                   uvm_resource#(uvm_active_passive_enum) rap;
                   if ($cast(rap, r)) begin
                     thisN.set_int_local(name, rap.read(thisN));
                     $sformat(apl_val," type=uvm_active_passive_enum value=%0d",rap.read(thisN));
                   end
                   else begin
                      uvm_resource#(string) rs;
                      if($cast(rs, r)) begin
                        thisN.set_string_local(name, rs.read(thisN));
                        $sformat(apl_val," type=string value=%s",rs.read(thisN));
                      end
                      else begin
                         uvm_resource#(uvm_config_object_wrapper) rcow;
                         if ($cast(rcow, r)) begin
                            uvm_config_object_wrapper cow; 
                            cow = rcow.read();
                            thisN.set_object_local(name, cow.obj, cow.clone);
                            $sformat(apl_val," type=uvm_config_object_wrapper value=%s","?");
                         end
                         else begin
                            uvm_resource#(uvm_object) ro;
                            if($cast(ro, r)) begin
                               thisN.set_object_local(name, ro.read(thisN), 0);
                               $sformat(apl_val," type=uvm_object value=%s","?");
                            end
                            else if (verbose) begin
                               uvm_report_info("CFGAPL", $sformatf("field %s has an unsupported type", name), UVM_NONE);
                            end
                         end // else: !if($cast(rcow, r))
                      end // else: !if($cast(rs, r))
                   end // else: !if($cast(rap, r))
                end // else: !if($cast(riu, r))
             end // else: !if($cast(ri, r))
          end // else: !if($cast(rbs, r))
       end // else: !if($cast(rit, r))
	if (is_verdi_trace_aware_used()||clp.get_arg_matches("+UVM_CONFIG_DB_TRACE", trace_args)) begin
        if (!is_verdi_trace_no_implicit_get_used()&&(name!="recording_detail")&&(apl_val!="")) begin
            $sformat(cfgapl_str,"%s%s",cfgapl_str,apl_val);
            uvm_report_info("CFGAPL",cfgapl_str,UVM_NONE);
        end
    end
endfunction

function longint uvm_recorder_verdi_get_array_limit(uvm_recorder thisN);
    if(1) begin // change condition to thisN.max_array_limit_check==0
      string val_str = ""; 
      //add a stmt "thisN.max_array_limit_check = 1;" in here
      if ($value$plusargs("UVM_ARRAY_NUM_LIMIT=%s", val_str))
          ;//thisN.max_array_num_limit = val_str.atoi();
    end 
    return 1; //change to " return thisN.max_array_num_limit"
endfunction

`ifdef UVM_DISABLE_APPLY_CFG_SETTINGS 
function void uvm_test_for_class_uvm_root();
  return ;
endfunction
`endif


`endif
