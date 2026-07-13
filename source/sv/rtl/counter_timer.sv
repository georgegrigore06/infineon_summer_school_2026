`timescale 1 ns / 1 ps

module counter_timer(
    input logic clk_i, rstn_i,

    input logic [1:0] mode,
    input logic clear_counter,
    input logic input_source,
    input logic out_function, 

    input logic [1:0] counter_timer_trigger_sel,
    input logic [1:0] capture_trigger_sel,

    input logic [9:0] target_value,
    
    output logic [9:0] counter_value,
    output logic [9:0] capture_value,
    output logic timer_running,
    output logic counter_timer_o
);

logic [9:0] w_cnt; // Principal Counter Register
logic out; // Delayed Input Source for edge detection
logic rise_event, fall_event, event_ok, event_capture_ok;

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i) out <= 0;
    else out <= input_source;
end

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i) w_cnt <= 0;
    else if(clear_counter) w_cnt <= 0;
    else begin 
        if(w_cnt == target_value) w_cnt <= 0;
        else begin
            case(mode)
                1: // counter
                    if(event_ok) begin
                        if(w_cnt < target_value) w_cnt <= w_cnt + 1;
                    end
                2: // timer
                    if(event_ok) w_cnt <= 1;
                    else if(w_cnt >= 1 && w_cnt < target_value) w_cnt <= w_cnt + 1;
                default begin
                    w_cnt <= 0;
                end
            endcase
        end
    end
end

always_comb
begin
    if(!out_function && counter_timer_o) counter_timer_o = 0;
    if(w_cnt == target_value) begin 
        counter_timer_o = (out_function)? ~counter_timer_o : 1;
    end
end

assign rise_event = ~out & input_source;
assign fall_event = out & ~input_source;
assign timer_running = (w_cnt != 0);
assign counter_value = w_cnt;


always_comb begin
    case(counter_timer_trigger_sel)
        0: event_ok = rise_event;
        1: event_ok = fall_event;
        2: event_ok = rise_event | fall_event;
        3: event_ok = 0;
    endcase

    case(capture_trigger_sel)
        0: event_capture_ok = rise_event;
        1: event_capture_ok = fall_event;
        2: event_capture_ok = rise_event | fall_event;
        3: event_capture_ok = 0;
    endcase

    if(event_capture_ok) capture_value = w_cnt;
end



endmodule