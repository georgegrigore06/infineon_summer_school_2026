`timescale 1 ns / 1 ps

module register10(
    input logic clk_i, rstn_i, en, clear,
    output logic [9:0] out
);

localparam LIMIT = 1000;

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i || clear) out <= 0;
    else if(en) out <= (out == LIMIT)? 0 : out+1;
end

endmodule