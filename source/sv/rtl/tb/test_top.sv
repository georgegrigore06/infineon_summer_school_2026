`timescale 1 ns / 1 ps

module test_top();

logic clk, rst, out_global, wr_en, acc;
logic [2:0] addr;
logic [14:0] in;
logic [15:0] wdata, rdata;

top dut(
    .clk_i(clk),
    .rstn_i(rst),

    .acc_en_i(acc),
    .wr_en_i(wr_en),

    .addr_i(addr),
    .wdata_i(wdata),
    .rdata_o(rdata),

    .input_i(in),
    .out_o(out_global)
);

initial begin
    clk = 0;
    forever #2 clk = ~clk;
end

initial begin
    rst = 0;
    wr_en = 1;
    acc = 1;
    in = 0;

    @(negedge clk);
    rst = 1;
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b1, 2'b00, 2'b00, 4'b0001};

    @(negedge clk); 
    addr = 3; // CNT_MODE1
    wdata = {6'b0, 10'd5}; 

    @(negedge clk); 
    addr = 0; // CTRL0
    wdata = {14'b0, 2'b10};

    @(negedge clk);
    addr = 5; // COMMAND
    wdata = 16'b0;

    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    // Rising Edge Counter with Toggle Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b0, 2'b00, 2'b00, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    // Rising Edge Counter with Pulse Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b1, 2'b00, 2'b01, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    // Falling Edge Counter with Toggle Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b0, 2'b00, 2'b01, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    // Falling Edge Counter with Pulse Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b1, 2'b00, 2'b10, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    // Both Edge Counter with Toggle Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b0, 2'b00, 2'b10, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    // Both Edge Counter with Pulse Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk); 
    addr = 0; // CTRL0
    wdata = 0; 
    // Disabling the counter

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b0, 2'b00, 2'b00, 4'b0001};
    @(negedge clk); 
    addr = 0; // CTRL0
    wdata = {14'b0, 2'b11};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    // Rising Edge Timer Start with Pulse Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b1, 2'b00, 2'b00, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    // Rising Edge Timer Start with Toggle Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b0, 2'b00, 2'b01, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    // Falling Edge Timer Start with Pulse Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {7'b0, 1'b1, 2'b00, 2'b01, 4'b0001};
    @(negedge clk);
    in = 1;
    @(negedge clk);
    in = 0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    // Falling Edge Timer Start with Toggle Output with Target Value 5

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 2; // CNT_MODE0
    wdata = {2'b0, 2'b01, 3'b0, 1'b0, 2'b0, 2'b00, 4'b0};
    @(negedge clk);
    addr = 0; // CTRL0
    wdata = {14'b0, 2'b10};
    @(negedge clk);
    addr = 5; // COMMAND
    wdata = {11'b0, 1'b0, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b1, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b0, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b1, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b0, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b1, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b0, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b1, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b0, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b1, 3'b0, 1'b0};
    @(negedge clk);
    wdata = {11'b0, 1'b0, 3'b0, 1'b0};
    // Software Trigger with Capture Value on Timer Rising Edge

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    @(negedge clk);
    addr = 0; // CTRL0
    wdata = 0; // Disabling the counter

    @(negedge clk);
    addr = 1; // PWM_MODE
    wdata = {2'b0, 2'b11, 2'b0, 10'd500};
     @(negedge clk);
    addr = 0; // CTRL0
    wdata = {14'b0, 2'b01};
    // PWM Mode with 50% Duty Cycle at 400 Hz

    @(negedge out_global);
    @(posedge out_global);

    @(negedge clk);
    addr = 1; // PWM_MODE
    wdata = {2'b0, 2'b11, 2'b0, 10'd750};
    // PWM Mode with 75% Duty Cycle at 400 Hz

    @(negedge out_global);
    @(posedge out_global);
    #50 $stop;


end

endmodule