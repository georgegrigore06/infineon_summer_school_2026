/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */


class ifx_dig_testbase extends uvm_test;
  `uvm_component_utils(ifx_dig_testbase)

  typedef enum { TIME_LENGTH, CYCLES } reset_length_t;

  ifx_dig_config          dig_cfg;

  // HINT --  add here declaration for dig_env
  ifx_dig_env             dig_env;


  //=========================================================================
  // Sequences.
  //-------------------------------------------------------------------------
  //=========================================================================

  ifx_dig_data_bus_uvc_sequence data_bus_seq;
  ifx_dig_data_bus_uvc_write_sequence data_bus_write_seq;
  ifx_dig_data_bus_uvc_read_sequence data_bus_read_seq;

  //=========================================================================
  // Variables.
  //-------------------------------------------------------------------------
  //=========================================================================

  uvm_report_server report_server;// used to display relevant info at the end of the test
  ifx_pin_toggle_sequence pin_toggle_seq; // sequence for toggling pins

  //=========================================================================
  // Methods.
  //-------------------------------------------------------------------------
  //=========================================================================

  function new(string name = "ifx_dig_testbase", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task reset_phase(uvm_phase phase);
  endtask : reset_phase

  // TODO DAY3: Implement drive reset task which can drive reset for a given length in cycles or time depending on the input arguments
  task drive_reset(int length, reset_length_t reset_type);
  endtask : drive_reset

  // TODO DAY3: Implement logic for driving pulses to the counting inputs of the DUT
  task drive_input_pulses(int input_idx, int num_pulses, int half_period_ns);
    repeat(num_pulses) begin
    end
  endtask : drive_input_pulses

  // Hook that can be overloaded in sub-classes to add configuration statements
  //-----------------------------------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO DAY2: Add infomessage for this phase

    //------------------=====================================---------------
    //-=========================- CREATE CONFIGURATION OBJECT -=========================-
    //------------------=====================================---------------
    dig_cfg = ifx_dig_config::type_id::create("dig_cfg", this);

    //------------------=====================================---------------
    //-=========================- INTERFACE GET -=========================-
    //------------------=====================================---------------
    //-----------Digital interface-----------
    if (!uvm_config_db#(virtual ifx_dig_interface)::get(this, "", "dig_if", dig_cfg.dig_vif))
      `uvm_fatal("TEST_BASE/NOVIF", "No virtual interface specified for TEST BASE")

    //------------------=====================================---------------
    //-=========================- CREATE ENV  -=========================-
    //------------------=====================================---------------
    dig_env = ifx_dig_env::type_id::create("dig_env", this);

    //------------------=====================================---------------
    //-=========================- SET CONFIGURATION OBJECTS -=========================-
    //------------------====================/******************************************************************************=================---------------
    uvm_config_db #(ifx_dig_config)::set(this, "*", "p_dig_cfg", dig_cfg);

    //  configuration objects for their corresponding agents
    uvm_config_db #(ifx_dig_data_bus_uvc_config)::set(uvm_top, "data_bus_uvc_agt" , "cfg", dig_cfg.data_bus_uvc_cfg);

    //------------------=====================================---------------
    //-=========================- CREATE SEQUENCES -=========================-
    //------------------=====================================---------------

    data_bus_seq        = ifx_dig_data_bus_uvc_sequence::type_id::create("data_bus_seq", this);
    data_bus_read_seq   = ifx_dig_data_bus_uvc_read_sequence::type_id::create("data_bus_read_seq", this);
    data_bus_write_seq  = ifx_dig_data_bus_uvc_write_sequence::type_id::create("data_bus_write_seq", this);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // TODO DAY2: Add infomessage for this phase

    // add necessary connections
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    // stop running after 1000 error
    set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_COUNT);
    report_server = get_report_server();
    report_server.set_max_quit_count(1000);

  endfunction : end_of_elaboration_phase

  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);

  endfunction : start_of_simulation_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask : run_phase

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
  endtask : main_phase

  //=========================================================================
  // GENERAL METHODS for STIMULI.
  //-------------------------------------------------------------------------
  //=========================================================================

  task write_reg_fields(string reg_name, string fields_names[]={}, int fields_values[]={}, read_after_write = 0);
    ifx_dig_data_bus_uvc_write_sequence write_seq;
    ifx_dig_reg reg_obj = dig_env.scoreboard.regblock.get_reg_by_name(reg_name);

    write_seq         = ifx_dig_data_bus_uvc_write_sequence::type_id::create("write_seq", this);
    write_seq.address = reg_obj.get_address();
    write_seq.data    = reg_obj.get_reg_value();
    `uvm_info("DEBUG", $sformatf("Reg value before write = %b", write_seq.data), UVM_NONE)

    foreach(fields_names[idx]) begin
      ifx_dig_field field_obj = reg_obj.get_field_by_name(fields_names[idx]);
      int field_val           = (2**field_obj.get_size() -1) & fields_values[idx];
      for(int pos=0 ;pos<=field_obj.get_size()-1; pos++) begin
        write_seq.data[pos+field_obj.get_lsb_possition()] = field_val[pos];
      end
    end
    `uvm_info("write_reg_fields", $sformatf("Write register %s fields %p with values %p", reg_name, fields_names, fields_values), UVM_NONE)
    write_seq.start(dig_env.data_bus_uvc_agt.sequencer);

    if(read_after_write)
      read_reg(reg_name);

  endtask : write_reg_fields


  // TODO DAY4: Implement a task for reading a register using the data bus read sequence
  task read_reg(string reg_name);
    ifx_dig_data_bus_uvc_read_sequence read_seq;
    ifx_dig_reg reg_obj = dig_env.scoreboard.regblock.get_reg_by_name(reg_name);

    read_seq         = ifx_dig_data_bus_uvc_read_sequence::type_id::create("read_seq", this);
    read_seq.address = reg_obj.get_address();

    `uvm_info("read_reg", $sformatf("Read register %s", reg_name), UVM_NONE)
    read_seq.start(dig_env.data_bus_uvc_agt.sequencer);

  endtask : read_reg

endclass: ifx_dig_testbase


