/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */
 
`timescale 1ns/100ps

package ifx_dig_test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"


  import ifx_dig_data_bus_uvc_pkg::*;
  import ifx_dig_pkg::*;

  // TODO DAY1: Add include for simple hello world test 

  `include "ifx_dig_counter_mode_test.svh"
	`include "ifx_dig_hello_world.svh"
endpackage
