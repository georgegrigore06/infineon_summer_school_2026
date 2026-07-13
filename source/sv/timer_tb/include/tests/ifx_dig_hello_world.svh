`timescale 1 ns / 100 ps

class ifx_dig_hello_world extends uvm_test;
virtual ifx_dig_interface dig_vif;
`uvm_component_utils(ifx_dig_hello_world)

function new(string name = "ifx_dig_hello_world", uvm_component parent);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info(get_full_name(), "=== RUN PHASE STARTING ===", UVM_NONE)
    uvm_config_db#(virtual ifx_dig_interface)::get(this, "", "dig_if", dig_vif)

    $display("Start of test");
    dig_vif.rstn_i = 0;
    repeat(2) @(negedge dig_vif.clk_i);
    dig_vif.rstn_i = 1;
    `WAIT_US(500)
    $display("Hello UVM World!");
    `WAIT_US(500)
endtask


endclass