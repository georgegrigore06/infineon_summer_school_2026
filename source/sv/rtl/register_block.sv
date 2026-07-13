`timescale 1 ns / 1 ps

module register_block(
    input logic clk_i, acc_en_i, wr_en_i, out_o, // sync
    input logic rstn_i, // async
    input logic timer_running,
    input logic [2:0] addr_i,
    input logic [9:0] counter_value, capture_value,
    input logic [15:0] wdata_i,
    output logic [3:0] input_selection, 
    output logic out_function,
    output logic sw_trigger, clear_counter,
    output logic [1:0] counter_mode, freq_sel, trigger_sel, capture_sel,
    output logic [9:0] target_value, duty_cycle,
    output logic [15:0] rdata_o
);

logic [15:0] CTRL0; 
logic [15:0] PWM_MODE;
logic [15:0] CNT_MODE0;
logic [15:0] CNT_MODE1;
logic [15:0] COUNTER_VALUE;
logic [15:0] COMMAND;
logic [15:0] CAPTURE_VALUE;

always_ff @(posedge clk_i or negedge rstn_i)
begin
    if(!rstn_i) begin
        CTRL0  <= 0;
        PWM_MODE <= 0;
        CNT_MODE0 <= 0;
        CNT_MODE1 <= 0;
        COMMAND <= 0;
    end
    else if(acc_en_i)
        if(wr_en_i) 
            case(addr_i)
                0: CTRL0 <= {14'b0, wdata_i[1:0]};
                1: PWM_MODE <= {2'b0, wdata_i[13:12], 2'b0, wdata_i[9:0]};
                2: CNT_MODE0 <= {2'b0, wdata_i[13:12], 3'b0, wdata_i[8], 2'b0, wdata_i[5:4], wdata_i[3:0]};
                3: CNT_MODE1 <= {6'b0, wdata_i[9:0]};
                5: COMMAND <= {11'b0, wdata_i[4], 3'b0, wdata_i[0]};
            endcase
end

always_comb begin
    if(acc_en_i && !wr_en_i)
        case(addr_i)
            0: rdata_o = CTRL0;
            1: rdata_o = PWM_MODE;
            2: rdata_o = CNT_MODE0;
            3: rdata_o = CNT_MODE1;
            4: rdata_o = COUNTER_VALUE;
            6: rdata_o = CAPTURE_VALUE;
        endcase
end

assign input_selection = CNT_MODE0[3:0];
assign sw_trigger = COMMAND[4];
assign clear_counter = COMMAND[0];
assign counter_mode = CTRL0[1:0];
assign duty_cycle = PWM_MODE[9:0];
assign freq_sel = PWM_MODE[13:12];
assign trigger_sel = CNT_MODE0[5:4];
assign capture_sel = CNT_MODE0[13:12];
assign target_value = CNT_MODE1[9:0];
assign out_function = CNT_MODE0[8];
assign COUNTER_VALUE = {6'b0, counter_value};
assign CAPTURE_VALUE = {3'b0, timer_running, 2'b0, capture_value};

endmodule