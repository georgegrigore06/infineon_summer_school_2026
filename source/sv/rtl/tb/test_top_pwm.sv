`timescale 1 ns / 1 ps

module test_top_pwm();

logic clk, rst, out, wr_en, acc;
logic [2:0] addr;
logic [14:0] wdata, rdata;


top dut(
    .clk_i(clk),
    .rstn_i(rst),
    .addr_i(addr),
    .wdata_i(wdata),
    .input_i(15'b0),
    .rdata_o(rdata),
    .acc_en_i(acc),
    .wr_en_i(wr_en),
    .out_o(out)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    rst = 0;
    wr_en = 1;
    acc = 1;
    #1 rst = 1;
    #1 addr = 0;
        wdata = {14'b0, 2'b01};
    #2 addr = 1;
        wdata = {6'b0, 10'd512};

    #2392289 wdata = {6'b0, 10'd768};


    #2000000 $stop;
end

endmodule