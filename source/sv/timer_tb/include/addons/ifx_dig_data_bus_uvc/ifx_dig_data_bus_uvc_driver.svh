/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_data_bus_uvc_driver extends uvm_driver #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_component_utils(ifx_dig_data_bus_uvc_driver)

  virtual interface ifx_dig_data_bus_uvc_interface vif;

  ifx_dig_data_bus_uvc_config cfg;

  string agent_name;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual task run_phase (uvm_phase phase);

    vif.addr_o   = 0;
    vif.wr_en_o  = 0;
    vif.acc_en_o = 0;
    vif.wdata_o  = 0;

    forever begin
      seq_item_port.get_next_item(req);

      case(req.access_type)
        READ : begin
          @(posedge vif.clk_i);
          vif.addr_o   = req.address;
          vif.wr_en_o  = 0;
          vif.acc_en_o = 1;
          @(posedge vif.clk_i);
          vif.acc_en_o = 0;
        end

        WRITE: begin
          @(posedge vif.clk_i);
          vif.addr_o   = req.address;
          vif.wdata_o  = req.data;
          vif.wr_en_o  = 1;
          vif.acc_en_o = 1;
          @(posedge vif.clk_i);
          vif.acc_en_o = 0;
        end
        
        INVALID_READ : begin
          @(posedge vif.clk_i);
          vif.addr_o   = req.address;
          vif.wr_en_o  = 0;
          vif.acc_en_o = 0;
        end

        INVALID_WRITE: begin
          @(posedge vif.clk_i);
          vif.addr_o   = req.address;
          vif.wdata_o  = req.data;
          vif.wr_en_o  = 1;
          vif.acc_en_o = 0;
        end
      endcase

      seq_item_port.item_done();
    end
  endtask

endclass
