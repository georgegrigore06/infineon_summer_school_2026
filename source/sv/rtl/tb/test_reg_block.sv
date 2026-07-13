`timescale 1 ns / 1 ps

module test_reg_block();

logic clk, rstn, acc, wr_en;
logic [3:0] addr;
logic [15:0] wdata, rdata;

register_block dut(
    .clk_i(clk),
    .rstn_i(rstn),
    .addr_i(addr),
    .wdata_i(wdata),
    .rdata_o(rdata),
    .acc_en_i(acc),
    .wr_en_i(wr_en)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    rstn = 0;
    #1 rstn = 1;
    #1  addr = 2;
        acc = 1;
        wr_en = 1;
        wdata = 15;
    #2 addr = 5;
        wdata = 16;
    #2  wr_en = 0;

    #20 $stop;
end

endmodule