`timescale 1 ns / 1 ps

module mux15(
    input logic [3:0] sel,
    input logic [14:0] input_i,
    output logic out
);

always_comb
begin
    case(sel)
        0: out = 0;
        1: out = input_i[0];
        2: out = input_i[1];
        3: out = input_i[2];
        4: out = input_i[3];
        5: out = input_i[4];
        6: out = input_i[5];
        7: out = input_i[6];
        8: out = input_i[7];
        9: out = input_i[8];
        10: out = input_i[9];
        11: out = input_i[10];
        12: out = input_i[11];
        13: out = input_i[12];
        14: out = input_i[13];
        15: out = input_i[14];
    endcase
end
endmodule