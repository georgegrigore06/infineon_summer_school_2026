/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

`include "ifx_dig_defines.svh"
`include"uvm_macros.svh"

module ifx_dig_top;
  import uvm_pkg::*;

  import ifx_dig_data_bus_uvc_pkg::*;
  import ifx_dig_pkg::*;
  import ifx_dig_test_pkg::*;

  initial begin
    $timeformat(-9, 3, " ns", 15);
    $display("running test");
    run_test();
  end

  wire               clk_i_w;
  wire               rstn_i_w;

  wire acc_en_i_w;
  wire wr_en_i_w;
  wire [`AWIDTH-1:0] addr_i_w;
  wire [`DWIDTH-1:0] wdata_i_w;
  wire [`DWIDTH-1:0] rdata_o_w;

  wire [`EXT_INPUTS_NB-1:0] inputs_i_w;
  
  wire output_o_w;

  reg clk;

  // TODO DAY1: Create DUT instance and connect to the wires here.


  // TODO DAY1: Create interface instances and connect to DUT here.


  ifx_dig_data_bus_uvc_interface data_uvc_if(
    .clk_i(clk_i_w),
    .rstn_i(rstn_i_w),
    
    .acc_en_o(acc_en_i_w),
    .wr_en_o(wr_en_i_w),
    .addr_o(addr_i_w),
    .wdata_o(wdata_i_w),
    .rdata_i(rdata_o_w)

  );

  // TODO DAY1: Complete generate_clock task and use it to generate the system clock with a frequency of 40 MHz
  initial begin
    generate_clock("ns", 1000); 
  end



  task generate_clock(string time_unit, int period);
   
  endtask


  assign clk_i_w = clk;

  initial begin
    uvm_config_db #(virtual ifx_dig_interface)::set(uvm_top, "*", "dig_if", dig_if);

    uvm_config_db #(virtual ifx_dig_data_bus_uvc_interface)::set(uvm_top, "data_bus_uvc_agt", "vif", data_uvc_if);

  end
endmodule
