class ifx_pin_toggle_sequence extends uvm_sequence#(ifx_dig_pin_toggle);

  // TODO DAY4: Implement required variables so that the sequence can be configured to toggle a user selectable pin.
  // TODO DAY4: Add constraint to ensure that the selected pin is within the valid range of counting inputs.
  // TODO DAY4: Add constraint to ensure that the number of toggles is a positive number.
  // TODO DAY4: Add constraint to ensure that the half period is a reasonable value.

  function new(string name= get_type_name());
    super.new(name);
  endfunction


  virtual task body();
    ifx_dig_pin_toggle item =  ifx_dig_pin_toggle::type_id::create("item");
    // TODO DAY4: Implement the body of the sequence to drive the required number of toggles to the selected pin with the specified half period.
  endtask

  
  `uvm_object_utils(ifx_pin_toggle_sequence)
endclass