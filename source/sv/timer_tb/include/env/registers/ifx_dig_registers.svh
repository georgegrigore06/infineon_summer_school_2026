class ifx_dig_reg extends uvm_object;

  `uvm_object_utils(ifx_dig_reg)

  ifx_dig_field fields_list[];
  protected int address;

  function new(string name = "ifx_dig_reg");
    super.new(name);
  endfunction

  function void configure(int address);
    this.address = address;
  endfunction

  function void build();

  endfunction

  function void predict_field_value(string field_name, int value);
    bit found;

    foreach(fields_list[idx]) begin
      if(fields_list[idx].get_name() == field_name) begin
        fields_list[idx].predict_value(value);
        found = 1;
        break;
      end
    end
    if(!found)
      `uvm_fatal(get_type_name(), $sformatf("Invalid field name %s for register %p", field_name, this.get_name()))
  endfunction

  function void write_field_value(string field_name, int value);
    bit found;

    foreach(fields_list[idx]) begin
      if(fields_list[idx].get_name() == field_name) begin
        fields_list[idx].write_value(value);
        found = 1;
        break;
      end
    end
    if(!found)
      `uvm_fatal(get_type_name(), $sformatf("Invalid field name %s for register %p", field_name, this.get_name()))
  endfunction

  function int get_field_value(string field_name);
    foreach(fields_list[idx]) begin
      if(fields_list[idx].get_name() == field_name) begin
        return fields_list[idx].get_value();
      end
    end
    `uvm_fatal(get_type_name(), $sformatf("Invalid field name %s for register %p", field_name, this.get_name()))
  endfunction

  function void predict_reg_value(int value);
    foreach(fields_list[idx]) begin
      int mask = (2**fields_list[idx].get_size() -1) << fields_list[idx].get_lsb_possition();
      fields_list[idx].predict_value( (value & mask) >> fields_list[idx].get_lsb_possition());
    end
  endfunction

  function void write_reg_value(int value);
    foreach(fields_list[idx]) begin
      int mask = (2**fields_list[idx].get_size() -1) << fields_list[idx].get_lsb_possition();
      fields_list[idx].write_value( (value & mask) >> fields_list[idx].get_lsb_possition());
    end
  endfunction

  function int get_reg_value();
    int value;
    foreach(fields_list[idx]) begin
      value += (fields_list[idx].get_value() << fields_list[idx].get_lsb_possition());
    end
  endfunction

  function int get_address();
    return address;
  endfunction

  function void reset();
    foreach(fields_list[idx]) begin
      fields_list[idx].reset();
    end
  endfunction


  function ifx_dig_field get_field_by_name(string field_name);
    foreach(fields_list[idx]) begin
      if(fields_list[idx].get_name() == field_name) begin
        return fields_list[idx];
      end
    end
    `uvm_fatal(get_type_name(), $sformatf("Invalid field name %s for register %p", field_name, this.get_name()))
  endfunction

endclass



class ifx_dig_reg_CTRL0 extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_CTRL0)

  ifx_dig_field mode;
  ifx_dig_field res;

  function new(string name = "CTRL0");
    super.new(name);
  endfunction

  function void build();
    mode = ifx_dig_field::type_id::create("mode");
    mode.configure(.bit_size(2), .offset(0), .rst_value(0), .acc_type(RW));

    res = ifx_dig_field::type_id::create("res");
    res.configure(.bit_size(14), .offset(2), .rst_value(0), .acc_type(RES));

    fields_list = {mode, res};
  endfunction
endclass



// TODO DAY2: Create the register and its fields
class ifx_dig_reg_PWM_MODE extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_PWM_MODE)

  function new(string name = "PWM_MODE");
    super.new(name);
  endfunction

  function void build();
  endfunction
endclass



// TODO DAY2: Create the register and its fields
class ifx_dig_reg_CNT_TIMER_MODE0 extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_CNT_TIMER_MODE0)

  function new(string name = "CNT_TIMER_MODE0");
    super.new(name);
  endfunction

  function void build();
  endfunction
endclass


// TODO DAY2: Create the register and its fields
class ifx_dig_reg_CNT_TIMER_MODE1 extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_CNT_TIMER_MODE1)

  function new(string name = "CNT_TIMER_MODE1");
    super.new(name);
  endfunction

  function void build();
  endfunction
endclass


// TODO DAY2: Create the register and its fields
class ifx_dig_reg_ACT_CNT_VALUE extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_ACT_CNT_VALUE)

  function new(string name = "ACT_CNT_VALUE");
    super.new(name);
  endfunction

  function void build();
  endfunction
endclass


// TODO DAY2: Create the register and its fields
class ifx_dig_reg_COMMAND extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_COMMAND)

  function new(string name = "COMMAND");
    super.new(name);
  endfunction

  function void build();
  endfunction
endclass


// TODO DAY2: Create the register and its fields
class ifx_dig_reg_CAPTURE_STATUS extends ifx_dig_reg;

  `uvm_object_utils(ifx_dig_reg_CAPTURE_STATUS)

  function new(string name = "CAPTURE_STATUS");
    super.new(name);
  endfunction

  function void build();
  endfunction
endclass
