`timescale 1 ns / 1 ps

module sync(
    input logic clk_i, rstn_i,
    input logic in,
    output logic out
);

logic w_sync;

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i) w_sync <= 0;
    else w_sync <= in;
end

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i) out <= 0;
    else out <= w_sync;
end

endmodule