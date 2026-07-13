/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

`include "ifx_dig_defines.svh"

interface ifx_dig_interface (

    input bit               clk_i,
    output bit               rstn_i,

    input bit acc_en_i,
    input bit wr_en_i,
    input bit [`AWIDTH-1:0] addr_i,
    input bit [`DWIDTH-1:0] wdata_i,
    input bit [`DWIDTH-1:0] rdata_o,

    output bit [`EXT_INPUTS_NB-1:0] inputs_i,
    input bit output_o
  );

  // TODO DAY6: Add SVA assertions to check the reset values of the outputs
  
  initial begin
    inputs_i = 0;
    #2ms;
    #500ns;
    repeat(15)begin
      inputs_i[0] = 1;
      #1ms;
      inputs_i[0] = 0;
      #1ms;
    end
  end
  

endinterface
