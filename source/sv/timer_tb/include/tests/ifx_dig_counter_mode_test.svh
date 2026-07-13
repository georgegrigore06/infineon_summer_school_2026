/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

 class ifx_dig_counter_mode_test extends ifx_dig_testbase;

   `uvm_component_utils(ifx_dig_counter_mode_test)

   rand logic[3:0] select_input;
   rand logic out_function;
   rand logic[1:0] select_trigger;
   rand logic[1:0] select_capture_event;
   rand logic[9:0] target_value;
   mode_t op_mode = COUNTER_MODE;

   constraint select_input_c {
     select_input inside {[1: 15]};
   }

   function new(string name = "ifx_dig_counter_mode_test", uvm_component parent);
     super.new(name, parent);
   endfunction


   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     // TODO DAY2: Add infomessage for this phase

   endfunction : build_phase

   task run_phase(uvm_phase phase);
     super.run_phase(phase);

     `uvm_info(get_full_name(), "=== RUN PHASE STARTING ===", UVM_NONE)
   endtask

   task main_phase(uvm_phase phase);

     phase.raise_objection(this);

     if(!this.randomize())
       `uvm_error(get_name(),"ERROR: Randomize failed!")

     // TODO DAY3: Refactor reset driving logic to use drive_reset task
     // TODO DAY4: Refactor test logic to use the write_reg_fields and read_reg tasks for register accesses
     `uvm_info("COUNTER_MODE_TEST", "Release reset", UVM_NONE)
     dig_env.p_dig_cfg.dig_vif.rstn_i = 0;
     `WAIT_NS(10)
     dig_env.p_dig_cfg.dig_vif.rstn_i = 1;
     `WAIT_MS(1)

     // MODE0
     `uvm_info("COUNTER_MODE_TEST", "Configure COUNTER MODE", UVM_NONE)
     data_bus_write_seq.address = `CNT_TIMER_MODE0_ADDR;
     // select input 1 + toggle output
     data_bus_write_seq.data = 16'b0000_0000_0000_0000;
     // select input
     this.select_input = 1;
     data_bus_write_seq.data[3:0] = this.select_input;
     // select trigger option
     data_bus_write_seq.data[5:4] = this.select_trigger;
     // select out function
     data_bus_write_seq.data[8] = this.out_function;
     // select capture event
     data_bus_write_seq.data[13:12] = this.select_capture_event;
     data_bus_write_seq.start(dig_env.data_bus_uvc_agt.sequencer);

     data_bus_read_seq.address = `CNT_TIMER_MODE0_ADDR;
     data_bus_read_seq.start(dig_env.data_bus_uvc_agt.sequencer);

     // MODE1
     target_value = 5;
     `uvm_info("COUNTER_MODE_TEST", "Configure COUNTER MODE", UVM_NONE)
     data_bus_write_seq.address = `CNT_TIMER_MODE1_ADDR;
     // set target value
     data_bus_write_seq.data[9:0] = target_value;
     data_bus_write_seq.start(dig_env.data_bus_uvc_agt.sequencer);

     data_bus_read_seq.address = `CNT_TIMER_MODE1_ADDR;
     data_bus_read_seq.start(dig_env.data_bus_uvc_agt.sequencer);

     // set counter mode - use regs function
     `uvm_info("COUNTER_MODE_TEST", "Change to COUNTER MODE", UVM_NONE)
      write_reg_fields("CTRL0", {"mode"}, {op_mode}, .read_after_write(1));

      //TODO DAY3: Add stimulus to toggle the selected input 10 times with a period of 100ns
      //TODO DAY4: Refactor the stimulus to toggle the selected input using a dedicated pin toggle sequence

     `WAIT_MS(20)


     phase.drop_objection(this);
   endtask

 endclass

