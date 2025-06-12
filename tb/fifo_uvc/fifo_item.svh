
typedef enum {WRITE, READ} fifo_operation_type;

class fifo_item extends uvm_sequence_item;

  // Random variables
  rand bit wr_en;
  rand bit rd_en;
  rand bit [7:0] data;
       bit full;
       bit empty;
  rand fifo_operation_type operation;

  // UVM automation macros
  `uvm_object_utils_begin(fifo_item)
    `uvm_field_int(wr_en, UVM_DEFAULT)
    `uvm_field_enum(fifo_operation_type, operation, UVM_DEFAULT)
    `uvm_field_int(rd_en, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)
    `uvm_field_int(full, UVM_DEFAULT)
    `uvm_field_int(empty, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "fifo_item");
    super.new(name);
  endfunction

  // Convert to string for easy printing
  virtual function string convert2string();
    return $sformatf("operation=%s wr_en=%0b rd_en=%0b data=0x%0h full=%0b empty=%0b", operation,
                     wr_en, rd_en, data, full, empty);
  endfunction

endclass
