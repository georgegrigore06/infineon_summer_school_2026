/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

interface ifx_dig_data_bus_uvc_interface
  (
    input bit clk_i,
    input bit rstn_i,
    
    input bit[`DWIDTH-1:0] rdata_i,
    
    output bit acc_en_o,
    output bit wr_en_o,
    output bit[`AWIDTH-1:0] addr_o,
    output bit[`DWIDTH-1:0] wdata_o
  );

endinterface
