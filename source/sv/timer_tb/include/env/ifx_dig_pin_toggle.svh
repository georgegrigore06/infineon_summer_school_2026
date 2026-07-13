class ifx_dig_pin_toggle extends uvm_sequence_item;

  rand int selected_pin;
  rand int num_of_toggles;
  rand int half_period_ns;

  function new(string name= get_type_name());
    super.new(name);
  endfunction


  `uvm_object_utils(ifx_dig_pin_toggle)
endclass