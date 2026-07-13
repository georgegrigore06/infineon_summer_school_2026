/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_env extends uvm_env;

  `uvm_component_utils(ifx_dig_env)

  ifx_dig_scoreboard scoreboard;

  ifx_dig_config p_dig_cfg;

  ifx_dig_data_bus_uvc_agent data_bus_uvc_agt;

  // TODO DAY4: Declare an object called pin_sequencer for the pin_toggle sequencer and create the instance in the appropriate phase

  function new(string name, uvm_component parent);
    super.new(name, parent);

  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO DAY2: Add infomessage for this phase
    `uvm_info (get_type_name(), $sformatf(">>>>>>>>>>>>ENV BUILD_PHASE starts<<<<<<<<<"), UVM_LOW)

    scoreboard = ifx_dig_scoreboard::type_id::create("scoreboard", this);

    if (!uvm_config_db #(ifx_dig_config)::get(this, "*", "p_dig_cfg", p_dig_cfg))
    `uvm_fatal("DIG_ENV/NOCFG", "No config specified for Environment")

    data_bus_uvc_agt              = ifx_dig_data_bus_uvc_agent::type_id::create("data_bus_uvc_agt", this);

  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // TODO DAY2: Add infomessage for this phase

    scoreboard.p_env = this;
    scoreboard.p_env_cfg = p_dig_cfg;

    // TODO DAY5: Connect the TLM ports of the data bus monitor to the corresponding TLM export in the scoreboard


  endfunction : connect_phase


  function void start_of_simulation_phase(uvm_phase phase);
  endfunction : start_of_simulation_phase

  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
  endtask : reset_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info (get_type_name(), $sformatf(">>>>>>>>>>>>ENV RUN_PHASE starts<<<<<<<<<"), UVM_LOW)


  endtask : run_phase

endclass
