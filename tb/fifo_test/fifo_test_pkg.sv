package fifo_test_pkg;

  // Import all necessary packages
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import fifo_pkg::*;
  import reset_pkg::*;
  import fifo_tb_pkg::*;

  `include "fifo_virtual_seq_lib.svh" // Include the virtual sequence library
  `include "fifo_test.svh"            // Include the FIFO test

endpackage : fifo_test_pkg
