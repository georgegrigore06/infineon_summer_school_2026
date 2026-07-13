`timescale 1 ns / 1 ps

module top(
    input logic clk_i, acc_en_i, wr_en_i, // sync
    input logic rstn_i, // async
    input logic [2:0] addr_i,
    input logic [14:0] input_i,
    input logic [15:0] wdata_i,
    output logic out_o,
    output logic [15:0] rdata_o
);

logic [1:0] w_counter_mode; 
logic w_out_function;
logic w_timer_running; // Counter Core General Utilities Wires

logic [1:0] w_prescale_sel;
logic [9:0] w_duty_lim; // Counter Core PWM Mode Wires

logic [1:0] w_counter_timer_sel, w_capture_sel;
logic [9:0] w_target_value, w_counter_value, w_capture_value; // Counter Core Counter/Timer Wires

logic [3:0] w_sel; 
logic w_sw_trigger; // Register Block General Utilities Wires

logic w_mux1, w_mux2, w_sync; // Input Source synchroniser 

register_block register_block(
    .clk_i(clk_i),
    .rstn_i(rstn_i), // Basic Utilities

    .acc_en_i(acc_en_i),
    .wr_en_i(wr_en_i),
    .addr_i(addr_i),
    .rdata_o(rdata_o),
    .wdata_i(wdata_i),
    .input_selection(w_sel),
    .sw_trigger(w_sw_trigger), // Register Block Utilities

    .counter_mode(w_counter_mode),
    .clear_counter(w_clear_counter),
    .counter_value(w_counter_value),
    .timer_running(w_timer_running), // Counter Core utilities (input + output)

    .freq_sel(w_prescale_sel),
    .duty_cycle(w_duty_lim), // Counter Core in PWM mode utilities (output)

    .trigger_sel(w_counter_timer_sel),
    .target_value(w_target_value),
    .out_function(w_out_function), // Counter Core in Counter/Timer mode utilities (input + output)

    .capture_sel(w_capture_sel),
    .capture_value(w_capture_value) // Capture Feature

);

counter_core counter_core(
    .clk_i(clk_i),
    .rstn_i(rstn_i), // Basic Utilities

    .input_source(w_mux2), // Synchronised Global Input

    .out_function(w_out_function),
    .counter_mode(w_counter_mode),
    .clear_counter(w_clear_counter), // Counter Core info received from Register Block (input)

    .counter_value(w_counter_value),
    .capture_value(w_capture_value),
    .timer_running(w_timer_running), // Counter Core info sent to Register Block (output)

    .pwm_duty_cycle(w_duty_lim),
    .pwm_freq_sel(w_prescale_sel), // Counter Core PWM mode utilities received from Register Block

    .counter_timer_trigger_sel(w_counter_timer_sel),
    .capture_trigger_sel(w_capture_sel),
    .target_value(w_target_value), // Counter Core Counter/Timer mode info sent to Registor Block (output)
    
    .out_o(out_o) // General Output
);

assign w_cmp = (w_sel == 0)? 1:0;

mux15 mux15(
    .input_i(input_i),
    .out(w_mux1),
    .sel(w_sel)
);

sync sync(
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .in(w_mux1),
    .out(w_sync)
);

always_comb
begin
    case(w_cmp)
        0: w_mux2 = w_sync;
        1: w_mux2 = w_sw_trigger;
    endcase
end



endmodule
