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
  ifx_dig_pin_sequencer pin_sequencer;
  ifx_dig_pin_driver pin_driver;

  function new(string name, uvm_component parent);
    super.new(name, parent);

  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO DAY2: Add infomessage for this phase
    `uvm_info (get_type_name(), $sformatf(">>>>> ENV BUILD_PHASE starts <<<<<"), UVM_LOW)

    scoreboard = ifx_dig_scoreboard::type_id::create("scoreboard", this);

    if (!uvm_config_db #(ifx_dig_config)::get(this, "*", "p_dig_cfg", p_dig_cfg))
    `uvm_fatal("DIG_ENV/NOCFG", "No config specified for Environment")

    data_bus_uvc_agt              = ifx_dig_data_bus_uvc_agent::type_id::create("data_bus_uvc_agt", this);
    pin_driver = ifx_dig_pin_driver::type_id::create("pin_driver", this);
    pin_sequencer = ifx_dig_pin_sequencer::type_id::create("pin_sequencer", this);

    `uvm_info (get_type_name(), $sformatf(">>>>> ENV BUILD_PHASE done <<<<<"), UVM_LOW)

  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // TODO DAY2: Add infomessage for this phase
    `uvm_info (get_type_name(), $sformatf(">>>>> ENV CONNECT_PHASE starts <<<<<"), UVM_LOW)

    scoreboard.p_env = this;
    scoreboard.p_env_cfg = p_dig_cfg;

    pin_driver.seq_item_port.connect(pin_sequencer.seq_item_export);
    pin_driver.vif = p_dig_cfg.dig_vif;

    // TODO DAY5: Connect the TLM ports of the data bus monitor to the corresponding TLM export in the scoreboard


    `uvm_info (get_type_name(), $sformatf(">>>>> ENV CONNECT_PHASE done <<<<<"), UVM_LOW)

  endfunction : connect_phase


  function void start_of_simulation_phase(uvm_phase phase);
  endfunction : start_of_simulation_phase

  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
  endtask : reset_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info (get_type_name(), $sformatf(">>>>> ENV RUN_PHASE starts <<<<<"), UVM_LOW)


  endtask : run_phase

endclass
