package fifo_pkg;

  // Import any necessary SystemVerilog packages
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include all FIFO UVC files
  `include "fifo_item.svh"
  `include "fifo_sequencer.svh"
  `include "fifo_driver.svh"
  `include "fifo_monitor.svh"
  `include "fifo_agent.svh"
  `include "fifo_sequence.svh"
   `include "fifo_coverage.svh"

endpackage : fifo_pkg
