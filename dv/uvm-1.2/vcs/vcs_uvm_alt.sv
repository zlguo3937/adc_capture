`protect

class uvm_fgp_thread_object_base;
    static uvm_fgp_thread_object_base registeredObjs[$];
    static function void initObjs();
        foreach (registeredObjs[i]) begin
            registeredObjs[i].initDynamicArray();
        end
    endfunction

    virtual function void initDynamicArray();
    endfunction
endclass

class uvm_fgp_thread_object#(type T = uvm_object) extends uvm_fgp_thread_object_base;
`define MAX_FIXED_FGP_UVM_T_SIZE 16
    T faObjs[`MAX_FIXED_FGP_UVM_T_SIZE];
    T daObjs[];
    
    function new();
        for (int i = 0; i < `MAX_FIXED_FGP_UVM_T_SIZE; i++) begin
            faObjs[i] = null;
        end
        uvm_fgp_thread_object_base::registeredObjs.push_back(this);
    endfunction

    function int unsigned get_thread_index();
        return 0;
    endfunction

    function int unsigned get_max_thread();
        return 0;
    endfunction


    // this function is only be available after fgp initialization phase 
    virtual function void initDynamicArray();
        int unsigned size = get_max_thread();
        if (size <= `MAX_FIXED_FGP_UVM_T_SIZE) begin
            return;
        end
        
        size = size - `MAX_FIXED_FGP_UVM_T_SIZE;
        daObjs = new [size];
        for (int i = 0; i < size; i++) begin
            daObjs[i] = null;
        end
    endfunction

    function T get_wrapper();
        T obj = null;
        int unsigned index = get_thread_index();
        if (index < `MAX_FIXED_FGP_UVM_T_SIZE) begin
            if (faObjs[index] == null) begin
                faObjs[index] = new;
            end
            obj = faObjs[index];
        end
        else begin
            index = index - `MAX_FIXED_FGP_UVM_T_SIZE;
            if (daObjs[index] == null) begin
                daObjs[index] = new;
            end
            obj = daObjs[index];
        end
        return obj;
    endfunction
endclass

class uvm_fgpinit_phase extends uvm_topdown_phase;
   local static uvm_fgpinit_phase m_inst;
   int flag;
   static const string type_name = "uvm_fgpinit_phase";
   static function uvm_fgpinit_phase get();
      if(m_inst == null) begin
         m_inst = new;
         m_inst.flag = 0;
      end
      return m_inst;
   endfunction
   protected function new(string name="vcs_fgp_init");
      super.new(name);
   endfunction
   virtual function string get_type_name();
      return type_name;
   endfunction

   function void fgp_uvm_component_info(uvm_component c1, uvm_component c2, string name, int flag);

   endfunction

   virtual function void execute (uvm_component comp, uvm_phase phase); 
        uvm_agent isAgent;
        uvm_env isEnv;
        uvm_component empty;
        string name;
        int type_flag;
        if (!flag) begin
            flag = 1;
            if ($test$plusargs("VCS_UVM_FGP_DIAG")) begin
                $display("FGP before running phase");
            end
            traverse_all_component(comp);

            fgp_uvm_component_info(empty,empty,name,type_flag);    

            uvm_fgp_thread_object_base::initObjs();
        end
   endfunction

    function void traverse_all_component(uvm_component comp);
    string name;
    int type_flag;
    uvm_agent isAgent;
    uvm_env isEnv;
    uvm_monitor isMon;
    uvm_driver isDrv;
    uvm_test isTest;
    uvm_sequencer isSeqr;
    uvm_component parent;
    begin
        name = comp.get_name();
        parent = comp.get_parent();
        type_flag = 0;
        if ($cast(isAgent,comp)) begin
            type_flag = 1;
        end
        else if ($cast(isDrv,comp)) begin
            type_flag = 2;
        end
        else if ($cast(isMon,comp)) begin
            type_flag = 3;
        end
        else if ($cast(isSeqr,comp)) begin
            type_flag = 4;
        end
        else if ($cast(isEnv,comp) || $cast(isTest,comp)) begin
            type_flag = 5;
        end
        fgp_uvm_component_info(parent,comp,name,type_flag);
        if ($test$plusargs("VCS_UVM_FGP_DIAG")) begin
            $display("fgpUvmComponentInfo: %s, %d ",comp.get_full_name(),type_flag);
        end
        if (comp.get_first_child(name)) begin
            do
                this.traverse_all_component(comp.get_child(name));
            while (comp.get_next_child(name));
        end

    end
   endfunction

endclass 


class uvm_fgpinit_obj;
    function new();
        uvm_domain dm = uvm_domain::get_common_domain();
        uvm_phase run = dm.find (uvm_run_phase::get());
        dm.add (uvm_fgpinit_phase::get(),null, null, run);   
    endfunction
endclass

`endprotect

