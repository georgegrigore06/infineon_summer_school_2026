class ifx_dig_sfr_test extends ifx_dig_testbase;
    
    `uvm_component_utils(ifx_dig_sfr_test)

    rand logic [15:0] data;

    function new(string name = "ifx_dig_sfr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        
        super.run_phase(phase);
        phase.raise_objection(this);
        void'(this.randomize());

        drive_reset(100, TIME_LENGTH);
        
        write_reg_fields(.reg_name("CNT_TIMER_MODE0"), .read_after_write(1), .is_random(1), .random_data(data));
        `WAIT_NS(100);
        write_reg_fields(.reg_name("CTRL0"), .read_after_write(1), .is_random(1), .random_data(data));
        `WAIT_NS(500);
        read_reg("ACT_CNT_VALUE");
        `WAIT_NS(100);



        phase.drop_objection(this);
    endtask

endclass