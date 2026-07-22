/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

task do_checkers();
  bit pwm_measure_timeout_b = 0;

  // TODO DAY6: Analyze the checkers and see if all of them are running correctly. If not, fix them.
  fork
    forever begin
      @(posedge dig_vif.clk_i);
      if(dig_vif.acc_en_i == 0) begin
        `uvm_info("dchk_02_rdata_o_when_no_access", "CHECK02: rdata_o while no access must be 0", UVM_NONE)
        dchk_02_rdata_o_when_no_access: assert (dig_vif.rdata_o == 0)
        else
          `uvm_error("dchk_02_rdata_o_when_no_access", $sformatf("Expecting 0 on rdata_o while no access ongoing but get %b", dig_vif.rdata_o))
      end
      @(dig_vif.acc_en_i, dig_vif.rdata_o);
    end

    forever begin
      if(configured_mode == PWM_MODE && configured_duty_cycle == 0) begin
        `uvm_info("dchk_03_pwm_on_0_duty_cycle", "CHECK03: output_o on 0 duty cycle must be 0", UVM_NONE)
        dchk_03_pwm_on_0_duty_cycle: assert (dig_vif.output_o == 0)
        else
          `uvm_error("dchk_03_pwm_on_0_duty_cycle", $sformatf("Expecting 0 on output when 0% duty cycle is configured but get %b", dig_vif.output_o))
      end
      @(configured_duty_cycle, configured_mode, dig_vif.output_o);
    end

    forever begin
      if(configured_mode == PWM_MODE && configured_duty_cycle == 1) begin
        `uvm_info("dchk_04_pwm_on_1_duty_cycle", "CHECK04: output_o on 100 duty cycle must be 1", UVM_NONE)
        dchk_04_pwm_on_1_duty_cycle: assert (dig_vif.output_o == 1)
        else
          `uvm_error("dchk_04_pwm_on_1_duty_cycle", $sformatf("Expecting 1 on output when 100% duty cycle is configured but get %b", dig_vif.output_o))
      end
      @(configured_duty_cycle, configured_mode, dig_vif.output_o);
    end

    forever begin
      wait(configured_mode == PWM_MODE && measured_pwm_uncertainty_b == 0);
      pwm_measure_timeout_b = 0;
      fork : measured_pwm_check_fork
        begin // timeout condition
        `uvm_info("measured_pwm_check_fork", $sformatf("Time: %t", $realtime), UVM_NONE)
          #(1s/configured_pwm_frequency);
          #3000ns; // for uncertainty
          pwm_measure_timeout_b = 1;
        end
        begin
          @(pwm_period_measured_e);
        end
        begin // disable conditions
          @(configured_mode, configured_mode);
        end
      join_any
      disable measured_pwm_check_fork;

      if(configured_mode == PWM_MODE && measured_pwm_uncertainty_b == 0) begin
        `uvm_info("dchk_05_pwm_period_and_duty_cycle", "CHECK05: output_o duty must match pwm duty", UVM_NONE)
        dchk_05_pwm_period_and_duty_cycle: assert (($sqrt((measured_pwm_duty_cycle - configured_duty_cycle) ** 2) <= 0.02) && (configured_pwm_frequency == measured_pwm_frequency) && (pwm_measure_timeout_b == 0))
        else
          `uvm_error("dchk_05_pwm_period_and_duty_cycle", $sformatf("Mismatch between expected and measured duty cycle and pwm frequency. \
                        \nExpected pwm_freq = %d ; measured pwm_freq = %f\
                        \nExpected pwm_duty = %f ; measured pwm_duty = %f\
                        \nTimeout condition = %b",
              configured_pwm_frequency, measured_pwm_frequency,
              configured_duty_cycle, measured_pwm_duty_cycle,
              pwm_measure_timeout_b))
      end
    end
  join

endtask

function void check_read_data(int address, int read_data);
  ifx_dig_reg regi;
  regi = regblock.get_reg_by_address(address);
  `uvm_info("dchk_01_rdata_o_equal_to_reg", "CHECK01: read_data must be equal to register value", UVM_NONE)
  if(regi != null) begin
    dchk_01_rdata_o_equal_to_reg: assert(regi.get_reg_value() != read_data)
    else
      `uvm_error("dchk_01_rdata_o_equal_to_reg", $sformatf("Mismatch between read_data = %d and register value = %d", read_data, regi.get_reg_value()))
  end
  else if(read_data != 0) `uvm_error("dchk_01_rdata_o_equal_to_reg", $sformatf("Expecting 0 on read_data for inexistent address, but got %d", read_data))
endfunction

