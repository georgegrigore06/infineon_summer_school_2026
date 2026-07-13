/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

class ifx_dig_data_bus_uvc_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_object_utils(ifx_dig_data_bus_uvc_sequence)

  ifx_dig_data_bus_uvc_seq_item seq_item;

  bit[`DWIDTH-1:0] data;
  bit[`AWIDTH-1:0] address;
  access_type_t access_type;
  bit is_random_b;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body ();

    `uvm_create(seq_item)
    if (is_random_b) begin
      void'(seq_item.randomize());
    end
    else begin
      seq_item.address     = address;
      seq_item.data        = data;
      seq_item.access_type = access_type;
    end

    `uvm_info(get_type_name(), $sformatf("Executing sequence with parameters access_type=%p address=%d data=%0d", seq_item.access_type, seq_item.address, seq_item.data), UVM_MEDIUM)

    `uvm_send(seq_item)

    `uvm_info(get_type_name()," Item finished ", UVM_MEDIUM)
  endtask

endclass



class ifx_dig_data_bus_uvc_read_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_object_utils(ifx_dig_data_bus_uvc_read_sequence)

  ifx_dig_data_bus_uvc_seq_item seq_item;

  bit[`AWIDTH-1:0] address;
  bit is_random_b;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body ();

    `uvm_create(seq_item)
    if (is_random_b) begin
      void'(seq_item.randomize() with {
          seq_item.access_type == READ;
        });
    end
    else begin
      seq_item.access_type = READ;
      seq_item.address     = address;
    end

    `uvm_info(get_type_name(), $sformatf("Executing read sequence with parameters access_type=%p address=%d data=%0d", seq_item.access_type, seq_item.address, seq_item.data), UVM_MEDIUM)

    `uvm_send(seq_item)

    `uvm_info(get_type_name()," Item finished ", UVM_MEDIUM)
  endtask

endclass



class ifx_dig_data_bus_uvc_write_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);

  `uvm_object_utils(ifx_dig_data_bus_uvc_write_sequence)

  ifx_dig_data_bus_uvc_seq_item seq_item;

  bit[`AWIDTH-1:0] address;
  bit[`DWIDTH-1:0] data;
  bit is_random_b;

  function new(string name="");
    super.new(name);
  endfunction

  virtual task body ();

    `uvm_create(seq_item)
    if (is_random_b) begin
      void'(seq_item.randomize() with {
          seq_item.access_type == WRITE;
        });
    end
    else begin
      seq_item.access_type = WRITE;
      seq_item.address     = address;
      seq_item.data        = data;
    end

    `uvm_info(get_type_name(), $sformatf("Executing write sequence with parameters access_type=%p address=%d data=%0d", seq_item.access_type, seq_item.address, seq_item.data), UVM_MEDIUM)

    `uvm_send(seq_item)

    `uvm_info(get_type_name()," Item finished ", UVM_MEDIUM)
  endtask

endclass

// TODO DAY3: Implement the body of this sequence by composing the existing write and read sequences
class ifx_dig_data_bus_uvc_write_read_sequence extends uvm_sequence #(ifx_dig_data_bus_uvc_seq_item);
  `uvm_object_utils(ifx_dig_data_bus_uvc_write_read_sequence)

  function new(string name = "ifx_dig_data_bus_uvc_write_read_sequence");
    super.new(name);
  endfunction


  virtual task body();
  endtask : body

endclass
