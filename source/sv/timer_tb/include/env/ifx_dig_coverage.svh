/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

task collect_coverage();
  fork
    forever @(configured_mode, configured_duty_cycle, configured_pwm_frequency) begin
        if(configured_mode == PWM_MODE)
          dcov_00_pwm_configuration.sample();
      end
  join
endtask

// TODO DAY6: Add covergroup proving that each input slecetion was used in all available modes.

// TODO DAY6: Add more covergroups that you see fit.

covergroup dcov_00_pwm_configuration with function sample();
  option.name         = "dcov_00_pwm_configuration";
  option.per_instance = 1;

  PWM_FREQ_cp: coverpoint configured_pwm_frequency{
      bins FREQ_100_HZ = {100};
      bins FREQ_200_HZ = {200};
      bins FREQ_320_HZ = {320};
      bins FREQ_400_HZ = {400};
    }

    PWM_DUTY_cp: coverpoint regblock.get_field_value("PWM_MODE", "duty_cycle"){
      bins DUTY_0        = {0};
      bins DUTY_100      = {1023};
      bins DUTY_INTV[10] = {[1:1022]};
    }

    PWM_FREQ_x_DUTY_crs: cross PWM_FREQ_cp, PWM_DUTY_cp;
endgroup

