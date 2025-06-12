class reset_item extends uvm_sequence_item;

  // Random variables
  rand bit reset;

  // Utility and Field macros
  `uvm_object_utils_begin(reset_item)
    `uvm_field_int(reset, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "reset_item");
    super.new(name);
  endfunction

endclass : reset_item
