`timescale 1 ns / 1 ps

module prescaler(
    input logic clk_i, rstn_i,
    input logic [8:0] lim,
    output logic prescaler
);

logic [8:0] w_cnt;

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i) begin 
        w_cnt <= 0; 
        prescaler <= 0; 
    end
    else
        if(w_cnt <= lim) begin
            w_cnt <= w_cnt + 1;
            prescaler <= 0;
        end
        else begin
            w_cnt <= 0; 
            prescaler <= 1;
        end
end

endmodule