`timescale 1 ns / 1 ps

module counter_core(
    input logic clk_i, rstn_i, // Basic Utilities

    input logic input_source,

    input logic out_function,
    input logic [1:0] counter_mode,
    input logic clear_counter,
    output logic timer_running, // Counter Core Info

    input logic [1:0] pwm_freq_sel,
    input logic [9:0] pwm_duty_cycle, // PWM Mode

    input logic [1:0] counter_timer_trigger_sel,
    output logic [9:0] counter_value, 
    input logic [9:0] target_value, // Counter/Timer Mode

    input logic [1:0] capture_trigger_sel,
    output logic [9:0] capture_value, // Capture Feature

    output logic out_o
);

logic w_pwm; // PWM Output Wire
logic w_counter_timer; // Counter/Timer Output Wire
logic w_timer_running1, w_timer_running2; // Counter Core running check
logic [9:0] w_counter_value1, w_counter_value2;

logic [2:0] mode; // Each Bit represents a Counter Core Mode
always_comb
begin
    case(counter_mode)
        0: mode = 0; // Disabled
        1: mode = 1; // PWM
        2: mode = 2; // Counter
        3: mode = 4; // Timer
    endcase
end

pwm pwm(
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .en(mode[0]), // Works like an extra reset if it's not set

    .clear_counter(clear_counter),
    .timer_running(w_timer_running1),
    .counter_value(w_counter_value1),

    .freq_sel(pwm_freq_sel),
    .duty_cycle_limit(pwm_duty_cycle),

    .pwm_o(w_pwm)
);

counter_timer counter_timer(
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    .input_source(input_source),

    .mode({mode[2], mode[1]}),

    .out_function(out_function),
    .clear_counter(clear_counter),
    .timer_running(w_timer_running2),

    .counter_timer_trigger_sel(counter_timer_trigger_sel),
    .counter_value(w_counter_value2),
    .target_value(target_value),

    .capture_trigger_sel(capture_trigger_sel),
    .capture_value(capture_value),

    .counter_timer_o(w_counter_timer)
);

assign timer_running = w_timer_running1 | w_timer_running2;

always_comb
begin
    case(counter_mode)
        1: counter_value = w_counter_value1;
        2: counter_value = w_counter_value2;
        3: counter_value = w_counter_value2;
        default counter_value = 0;
    endcase
end


always_comb
begin
    if(!rstn_i) out_o = 0;
    else
        case(counter_mode)
            0: out_o = 0;
            1: out_o = w_pwm;
            2: out_o = w_counter_timer;
            3: out_o = w_counter_timer;
        endcase
end

endmodule