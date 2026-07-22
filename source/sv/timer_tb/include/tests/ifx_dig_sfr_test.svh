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

        drive_reset(100, TIME_LENGTH);
        
        write_reg_fields(.reg_name("PWM_MODE"), .fields_names({"duty_cycle", "frequency_sel"}), .fields_values({512, 2'b11}), .read_after_write(1));
        write_reg_fields(.reg_name("CTRL0"), .fields_names({"mode"}), .fields_values({2'b01}), .read_after_write(1));
        `WAIT_MS(20)



        phase.drop_objection(this);
    endtask

endclass