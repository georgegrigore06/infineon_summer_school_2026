/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */
typedef ifx_dig_env;

class ifx_dig_config extends uvm_object;

  `uvm_object_utils(ifx_dig_config)

  ifx_dig_data_bus_uvc_config data_bus_uvc_cfg;

  ifx_dig_env   p_env;

  virtual interface   ifx_dig_interface   dig_vif;

  function new( string name = "ifx_dig_config" );
    super.new(name);

    data_bus_uvc_cfg        = ifx_dig_data_bus_uvc_config::type_id::create("data_bus_uvc_cfg");

    initialize_configs();
  endfunction : new

  function void initialize_configs();
    data_bus_uvc_cfg.invalid_address = {3'b111};

  endfunction

endclass : ifx_dig_config
