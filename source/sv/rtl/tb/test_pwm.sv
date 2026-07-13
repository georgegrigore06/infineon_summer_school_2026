`timescale 1 ns / 1 ps

module test_pwm();

logic clk, rst;
logic [1:0] freq_sel;
logic [9:0] duty_cycle;

counter_core dut(
    .clk_i(clk),
    .rstn_i(rst),
    .pwm_freq_sel(freq_sel),
    .pwm_duty_cycle(duty_cycle)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    rst = 0;
    #1 rst = 1;
    #1 freq_sel = 3;
        duty_cycle = 512;
    #200000 duty_cycle = 768;


    #200000 $stop;
end

endmodule