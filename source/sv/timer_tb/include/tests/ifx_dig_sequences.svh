class ifx_pin_toggle_sequence extends uvm_sequence#(ifx_dig_pin_toggle);

  // TODO DAY4: Implement required variables so that the sequence can be configured to toggle a user selectable pin.
  int selected_pin;
  int num_of_toggles;
  int half_period_ns;

  // TODO DAY4: Add constraint to ensure that the selected pin is within the valid range of counting inputs.
  
  constraint pin_range{ 
    selected_pin < 16;
    selected_pin >= 0;
  }
  
  // TODO DAY4: Add constraint to ensure that the number of toggles is a positive number.
  constraint pos_nr_toggles{ 
    num_of_toggles > 0;
  }
  // TODO DAY4: Add constraint to ensure that the half period is a reasonable value.

  constraint half_period_value { 
    half_period_ns > 0;
    half_period_ns < 1000000;
  }

  function new(string name= get_type_name());
    super.new(name);
  endfunction


  virtual task body();
    ifx_dig_pin_toggle item =  ifx_dig_pin_toggle::type_id::create("item");
    // TODO DAY4: Implement the body of the sequence to drive the required number of toggles to the selected pin with the specified half period.
    item.half_period_ns = half_period_ns;
    item.num_of_toggles = num_of_toggles;
    item.selected_pin = selected_pin;

    `uvm_send(item)
  
  endtask

  
  `uvm_object_utils(ifx_pin_toggle_sequence)
endclass