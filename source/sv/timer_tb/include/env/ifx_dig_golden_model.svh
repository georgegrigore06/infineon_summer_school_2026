/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */


bit input_synch_b;

mode_t configured_mode;
int configured_pwm_frequency;
real configured_duty_cycle;


event pwm_period_measured_e; // triggers after a PWM period has been measured on the DUT

event update_expected_output_o_e; // trigger when output must change after a counter or timer event

event counter_clear_e; // triggered when counter is cleared

int measured_pwm_frequency;
real measured_pwm_duty_cycle;
bit measured_pwm_uncertainty_b;
int expected_counter_value;
int expected_capture_value;
bit expected_tm_running;


bit expected_output_o; // expected output while not in PWM_MODE
bit output_toggled;

// register variables
bit[3:0] configured_input_select_b;
bit configured_sw_input_b;
int configured_target_value;
int configured_trigger_selection;
int configured_capture_selection;

virtual ifx_dig_interface vif;

  bit ext_in_mux_b;
  bit ext_in_mux_synch_b;

task golden_model();
  fork
    monitor_inputs();
    update_reg_variables();
    monitor_pwm_output();

    model_counter_mode();
    model_timer_mode();
    model_capture_mode();

    model_expected_output_o();

    monitor_reset();

    predict_registers();
    
    collect_coverage();
  join
endtask


task monitor_inputs();


  fork
    forever begin
      if(configured_input_select_b != 0)
        ext_in_mux_b = dig_vif.inputs_i[configured_input_select_b-1];
      @(dig_vif.inputs_i);
    end

    forever @(posedge dig_vif.clk_i) begin
        ext_in_mux_synch_b = ext_in_mux_b;
      end

    forever begin
      if(configured_input_select_b == 0)
        input_synch_b = configured_sw_input_b;
      else
        input_synch_b = ext_in_mux_synch_b;
      @(configured_input_select_b, configured_sw_input_b, ext_in_mux_synch_b);
    end
  join
endtask


task update_reg_variables();
  forever begin
    // TODO DAY5: Brick 1 - read the register fields that define the current configuration.
    configured_mode              = mode_t'(regblock.get_field_value("CTRL0", "mode"));
    configured_input_select_b    = 0;
    configured_sw_input_b        = 0;
    configured_trigger_selection = 0;
    configured_target_value      = 0;
    configured_capture_selection = 0;

    // TODO DAY5: Brick 2 - detect a clear command and notify the rest of the model.


    // TODO DAY5: Brick 3 - decode the PWM frequency selection into a real frequency value.
   

    // TODO DAY5: Brick 4 - Decode duty cycle value from register value.
    configured_duty_cycle = 0;

    @(reg_write_e, regblock_reset_e);
  end
endtask


task monitor_reset();
  forever begin
    regblock.reset();
    ->regblock_reset_e;
    @(negedge dig_vif.rstn_i);
  end
endtask


task monitor_pwm_output();
  realtime t_rise, t_fall, t_period;

  forever begin
    wait(configured_mode == PWM_MODE);
    fork: pwm_monitoring_fork
      begin
        case(configured_duty_cycle)
          0.0: begin
            // do nothing here - dedicated checker
            // frequency and duty cycle cannot be measure
            measured_pwm_uncertainty_b = 1;
          end
          1.0: begin
            // do nothing here - dedicated checker
            // frequency and duty cycle cannot be measure
            measured_pwm_uncertainty_b = 1;
          end
          default: begin
            measured_pwm_uncertainty_b = 1;
            @(negedge dig_vif.output_o) t_fall = $realtime();
            forever begin
              @(posedge dig_vif.output_o) t_rise = $realtime();
              @(negedge dig_vif.output_o);
              t_period = $realtime() - t_fall; // period measured from falling to falling
              t_fall   = $realtime();

              measured_pwm_frequency  = 1.0s/t_period;
              measured_pwm_duty_cycle = (t_fall - t_rise)/t_period;

              measured_pwm_uncertainty_b = 0;
              ->pwm_period_measured_e;
            end
          end
        endcase
      end
      begin // any of these changes should reset the monitoring
        @(configured_mode, configured_duty_cycle, configured_pwm_frequency);
      end
    join_any
    disable pwm_monitoring_fork;
  end
endtask


task model_counter_mode();
  forever begin
    if(configured_mode != COUNTER_MODE) begin
      expected_counter_value = 0;
      wait(configured_mode == COUNTER_MODE);
    end else begin
      wait_counter_trigger_event(this.configured_trigger_selection);
      if(configured_mode == COUNTER_MODE) begin // reevaluate condition in case it changed while waiting for the trigger
        @(posedge dig_vif.clk_i);
        expected_counter_value += 1;
        if(expected_counter_value == configured_target_value) begin
          -> update_expected_output_o_e;
//          @(counter_clear_e); // TODO - is this ok?
          @(posedge dig_vif.clk_i);
          expected_counter_value = 0;
        end
      end
    end
  end
endtask



task model_timer_mode();
  forever begin
    wait(this.configured_mode == TIMER_MODE);
    fork
      // timer function
      begin
        this.expected_counter_value = 0;
        wait_counter_trigger_event(this.configured_trigger_selection); // timer has the same selections as counter
        forever begin
          @(posedge dig_vif.clk_i);
          if(this.output_toggled == 0)
            this.expected_counter_value += 1;
          if(this.expected_counter_value == this.configured_target_value)begin
            -> update_expected_output_o_e;
            this.output_toggled = 1;
          end
        end
      end
      // re-start timer
      begin
        restart_timer_event();
        this.output_toggled = 0;
        this.expected_counter_value = 0;
      end
      // clear counter command
      forever begin
        @(counter_clear_e);
        this.expected_counter_value = 0;
      end
      // configuration changed
      begin
        wait(this.configured_mode != TIMER_MODE);
        this.expected_counter_value = 0;
        this.output_toggled = 0;
      end
    join_any
    disable fork;
  end
endtask


task model_capture_mode();
  forever begin
    wait(this.configured_mode == COUNTER_MODE || this.configured_mode == TIMER_MODE);
    fork
      // clear capture counter value
      begin
        wait_counter_trigger_event(this.configured_trigger_selection);
        this.expected_capture_value = 0;
      end
      // clear captured value
      begin
        wait_counter_trigger_event(this.configured_capture_selection);
        this.expected_capture_value = this.expected_counter_value;
      end
      // tm running update
      forever begin
        @(this.expected_counter_value);
        if(this.expected_counter_value > 0)
          this.expected_tm_running = 1;
        else
          this.expected_tm_running = 0;
      end
      // configuration changed
      begin
        wait(configured_mode != COUNTER_MODE && configured_mode != TIMER_MODE);
        this.expected_capture_value = 0;
        this.expected_tm_running = 0;
      end
    join_any
    disable fork;
  end
endtask


task predict_registers();
  fork
    forever @(expected_counter_value) begin
        regblock.predict_field_value("ACT_CNT_VALUE", "counter", expected_counter_value);
      end
  join
endtask


task wait_counter_trigger_event(int selection);
  bit condition_matched = 0;
  do begin
    fork
      begin
        case(selection)
          0: @(posedge input_synch_b);
          1: @(negedge input_synch_b);
          2: @(input_synch_b);
          3: begin
            #1s;
          end
        endcase
        condition_matched = 1;
      end
      begin
        @(selection);
      end
    join_any
    disable fork;
  end while (!condition_matched);
  @(posedge dig_vif.clk_i); // delay after event trigger
endtask


task restart_timer_event();
  case(configured_trigger_selection)
    0: @(negedge input_synch_b);
    1: @(posedge input_synch_b);
    2: @(input_synch_b);
    3: begin
      #1s;
    end
  endcase
endtask


task model_expected_output_o();
  // TODO Day 5: Initialize the expected DUT output before processing output events.
  forever begin
    // TODO Day 5: Wait for the event that indicates the counter or timer reached its target.
    @(update_expected_output_o_e);

    // TODO Day 5: Align the expected output update with the DUT clock.
    @(posedge dig_vif.clk_i);

    if(!regblock.get_field_value("CNT_TIMER_MODE0", "out_fct")) begin
      // TODO Day 5: Generate a one-cycle pulse on the expected output.

    end else begin
      // TODO Day 5: Toggle the expected output and clear the expected counter value.

    end
  end
endtask





















