/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_data_bus_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(ifx_dig_data_bus_uvc_monitor)

  string agent_name;
  virtual interface ifx_dig_data_bus_uvc_interface vif;
  ifx_dig_data_bus_uvc_config cfg;

  ifx_dig_data_bus_uvc_seq_item mon_item;

  uvm_analysis_port #(ifx_dig_data_bus_uvc_seq_item) mon_port;

  function new(string name,uvm_component parent);
    super.new(name,parent);
    mon_port=new("mon_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    mon_item = ifx_dig_data_bus_uvc_seq_item::type_id::create("mon_item", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Starting the run() phase", UVM_MEDIUM)

    forever begin
      @(posedge vif.clk_i iff (vif.acc_en_o && vif.rstn_i)) begin
        `uvm_info(get_type_name(), "Data access detected", UVM_MEDIUM)
        mon_item.access_type = vif.wr_en_o ? WRITE       : READ; // identify the access type
        mon_item.data        = vif.wr_en_o ? vif.wdata_o : vif.rdata_i; // get the data depending on the access type
        mon_item.address     = vif.addr_o;
        mon_item.addr_validity = vif.addr_o inside {cfg.invalid_address} ? ADDR_INVALID : ADDR_VALID; // validate if it's valid or not
        mon_port.write(mon_item);// sent collected item outside the monitor
      end
    end

  endtask
endclass
