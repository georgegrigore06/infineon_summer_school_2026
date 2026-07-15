class ifx_dig_sfr_test extends ifx_dig_testbase;
    
    
    function new(string name = "ifx_dig_sfr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        drive_reset(3, CYCLES);
        

        phase.drop_objection(this);
    endtask

endclass