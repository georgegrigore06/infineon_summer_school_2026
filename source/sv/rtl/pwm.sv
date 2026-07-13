`timescale 1 ns / 1 ps

module pwm(
    input logic rstn_i, clk_i, en,
    input logic [1:0] freq_sel,
    input logic [9:0] duty_cycle_limit,
    output logic pwm_o,

    input logic clear_counter,
    output logic timer_running,
    output logic [9:0] counter_value
);

logic [8:0] w_lim;
logic [9:0] w_cnt;

localparam LIMIT0 = 392;
localparam LIMIT1 = 196;
localparam LIMIT2 = 122;
localparam LIMIT3 = 98;

always_comb
begin
    case(freq_sel)
        0: w_lim = LIMIT0;
        1: w_lim = LIMIT1;
        2: w_lim = LIMIT2;
        3: w_lim = LIMIT3;
    endcase

end

prescaler prescaler(
    .clk_i(clk_i),
    .rstn_i(rstn_i & en),
    .lim(w_lim),
    .prescaler(w_prescaler)
);

register10 register10(
    .clk_i(clk_i),
    .rstn_i(rstn_i & en),
    .en(w_prescaler),
    .out(w_cnt),
    .clear(clear_counter)
);

assign pwm_o = (w_cnt < duty_cycle_limit);
assign timer_running = (w_cnt != 0);
assign counter_value = w_cnt;
endmodule