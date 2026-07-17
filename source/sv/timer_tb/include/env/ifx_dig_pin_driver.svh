class ifx_dig_pin_driver extends uvm_driver #(ifx_dig_pin_toggle);

    `uvm_component_utils(ifx_dig_pin_driver)

    virtual interface ifx_dig_interface vif;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase (uvm_phase phase);
        foreach(vif.inputs_i[idx]) vif.inputs_i[idx] = 0;
        
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge vif.clk_i);
            for(int i=0; i<req.num_of_toggles; i++)
            begin
                vif.inputs_i[req.selected_pin] = 1;
                #(req.half_period_ns);
                vif.inputs_i[req.selected_pin] = 0;
                #(req.half_period_ns);
            end
            seq_item_port.item_done();
        end

    endtask

endclass