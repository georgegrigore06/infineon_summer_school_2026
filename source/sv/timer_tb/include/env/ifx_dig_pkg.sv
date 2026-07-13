/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

package ifx_dig_pkg;

  import uvm_pkg::*;
  `include  "uvm_macros.svh"

  `include "ifx_dig_defines.svh"

  import ifx_dig_data_bus_uvc_pkg::*;
  import ifx_dig_regblock_pkg::*;

  `include "ifx_dig_types.svh"
  `include "ifx_dig_config.svh"

  `include "ifx_dig_pin_toggle.svh"
  `include "ifx_dig_sequences.svh"

  // TODO DAY4: Modify the typedef below to match the correct kind of sequence item that needs to be driven
  typedef uvm_sequencer#(uvm_sequence_item) ifx_dig_pin_sequencer;

  `include "ifx_dig_scoreboard.svh"
  `include "ifx_dig_env.svh"
  `include "ifx_dig_testbase.svh"
endpackage
