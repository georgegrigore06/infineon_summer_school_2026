
typedef enum int {R, W, RW, RES} field_access_type_t;

class ifx_dig_field extends uvm_object;

  `uvm_object_utils(ifx_dig_field)

  protected int rst_value;
  protected int value;
  protected field_access_type_t acc_type;
  protected int bit_size;
  protected int offset;

  function new(string name="");
    super.new(name);
  endfunction

  function void configure(int bit_size, int offset, int rst_value, field_access_type_t acc_type);
    this.bit_size  = bit_size;
    this.offset    = offset;
    this.rst_value = rst_value;
    this.value     = rst_value; //register starts with reset value
    this.acc_type  = acc_type;
  endfunction

  function int get_lsb_possition();
    return offset;
  endfunction
  
  function int get_msb_possition();
    return offset+bit_size-1;
  endfunction
  
  function int get_size();
    return bit_size;
  endfunction

  function void reset();
    value = rst_value;
  endfunction

  function void predict_value(int value);
    if(!(acc_type inside {RES}))
      this.value = (2**bit_size -1) & value;
  endfunction
  
  function void write_value(int value);
    if(acc_type inside {W, RW})
      this.value = (2**bit_size -1) & value;
  endfunction

  function int get_value();
    if(acc_type == W)
      return 0;
    else
      return value;
  endfunction

endclass