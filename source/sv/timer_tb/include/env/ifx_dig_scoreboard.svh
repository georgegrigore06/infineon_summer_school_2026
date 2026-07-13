/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(ifx_dig_scoreboard)

  ifx_dig_env p_env;
  ifx_dig_config p_env_cfg;
  virtual ifx_dig_interface dig_vif;
  ifx_dig_regblock regblock;

  `uvm_analysis_imp_decl(_data_bus_uvc)
  uvm_analysis_imp_data_bus_uvc #(ifx_dig_data_bus_uvc_seq_item, ifx_dig_scoreboard) data_bus_uvc_imp;

  event reg_write_e;
  event reg_read_e;
  event regblock_reset_e;

  extern function new(string name = "ifx_dig_scoreboard", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

`include "ifx_dig_golden_model.svh"
`include "ifx_dig_checkers.svh"
`include "ifx_dig_coverage.svh"

  function void write_data_bus_uvc(input ifx_dig_data_bus_uvc_seq_item packet);
    begin
      `uvm_info("WRITE_DATA_BUS_UVC", $sformatf("Received packet from DATA_BUS_UVC monitor. \n"), UVM_NONE)
      if(packet.access_type == WRITE) begin
        ifx_dig_reg reg_obj = regblock.get_reg_by_address(packet.address);
        if(reg_obj != null)
          reg_obj.write_reg_value(packet.data);
        ->reg_write_e;
      end else if(packet.access_type == READ) begin
        check_read_data(packet.address, packet.data);
        ->reg_read_e;
      end
    end
  endfunction: write_data_bus_uvc

endclass : ifx_dig_scoreboard

function ifx_dig_scoreboard::new(string name = "ifx_dig_scoreboard", uvm_component parent);
  super.new(name, parent);
  this.dcov_00_pwm_configuration        = new();

  data_bus_uvc_imp        = new("data_bus_uvc_imp", this);

endfunction : new


function void ifx_dig_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO DAY2: Add infomessage for this phase

  regblock = ifx_dig_regblock::type_id::create("regblock");
  regblock.build();

  // TODO DAY5: Get a handler to the virtual interface using the uvm_config_db mechanism

endfunction : build_phase

function void ifx_dig_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // TODO DAY2: Add infomessage for this phase

endfunction : connect_phase

function void ifx_dig_scoreboard:: end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

endfunction : end_of_elaboration_phase

task ifx_dig_scoreboard::run_phase(uvm_phase phase);

  // TODO DAY5: Add code allowing the golden model, checkers and coverage to run in parallel

endtask : run_phase

