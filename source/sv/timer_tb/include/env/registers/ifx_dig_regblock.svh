class ifx_dig_regblock extends uvm_object;
  `uvm_object_utils(ifx_dig_regblock)

  ifx_dig_reg_CTRL0 CTRL0;
  ifx_dig_reg_PWM_MODE PWM_MODE;
  ifx_dig_reg_CNT_TIMER_MODE0 CNT_TIMER_MODE0;
  ifx_dig_reg_CNT_TIMER_MODE1 CNT_TIMER_MODE1;
  ifx_dig_reg_ACT_CNT_VALUE ACT_CNT_VALUE;
  ifx_dig_reg_COMMAND COMMAND;
  ifx_dig_reg_CAPTURE_STATUS CAPTURE_STATUS;


  function new(string name = "ifx_dig_regblock");
    super.new(name);
  endfunction


  function void build();
    CTRL0           = ifx_dig_reg_CTRL0::type_id::create("CTRL0");
    CTRL0.configure(.address(0));
    CTRL0.build();

    // TODO DAY2: Instantiate objects for each register
  endfunction

  function ifx_dig_reg get_reg_by_name(string reg_name);
    // TODO DAY2: Implement logic for returning the right register object corresponding to the input string
  endfunction

  function ifx_dig_reg get_reg_by_address(int address);
    case(address)
      0      : return CTRL0;
      1      : return PWM_MODE;
      2      : return CNT_TIMER_MODE0;
      3      : return CNT_TIMER_MODE1;
      4      : return ACT_CNT_VALUE;
      5      : return COMMAND;
      6      : return CAPTURE_STATUS;
      default: return null;
    endcase
  endfunction


  function string get_reg_name_by_address(int address);
    case(address)
      0      : return "CTRL0";
      1      : return "PWM_MODE";
      2      : return "CNT_TIMER_MODE0";
      3      : return "CNT_TIMER_MODE1";
      4      : return "ACT_CNT_VALUE";
      5      : return "COMMAND";
      6      : return "CAPTURE_STATUS";
      default: return "";
    endcase
  endfunction

  function void predict_field_value(string reg_name, string field_name, int value);
    ifx_dig_reg reg_obj = get_reg_by_name(reg_name);
    reg_obj.predict_field_value(field_name, value);
  endfunction

  function void write_field_value(string reg_name, string field_name, int value);
    ifx_dig_reg reg_obj = get_reg_by_name(reg_name);
    reg_obj.write_field_value(field_name, value);
  endfunction

  function int get_field_value(string reg_name, string field_name);
    ifx_dig_reg reg_obj = get_reg_by_name(reg_name);
    return reg_obj.get_field_value(field_name);
  endfunction

  function void predict_reg_value(string reg_name, int value);
    ifx_dig_reg reg_obj = get_reg_by_name(reg_name);
    reg_obj.predict_reg_value(value);
  endfunction

  function void write_reg_value(string reg_name, int value);
    ifx_dig_reg reg_obj = get_reg_by_name(reg_name);
    reg_obj.write_reg_value(value);
  endfunction

  function int get_reg_value(string reg_name);
    ifx_dig_reg reg_obj = get_reg_by_name(reg_name);
    return reg_obj.get_reg_value();
  endfunction

  function void reset();
    CTRL0.reset();
    PWM_MODE.reset();
    CNT_TIMER_MODE0.reset();
    CNT_TIMER_MODE1.reset();
    ACT_CNT_VALUE.reset();
    COMMAND.reset();
    CAPTURE_STATUS.reset();
  endfunction

endclass
