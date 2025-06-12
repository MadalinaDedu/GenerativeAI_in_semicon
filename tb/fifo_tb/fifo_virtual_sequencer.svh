class fifo_virtual_sequencer extends uvm_sequencer;

  // Factory registration
  `uvm_component_utils(fifo_virtual_sequencer)

  // Sequencer handles
  fifo_sequencer  fifo_sqr ;
  reset_sequencer reset_sqr;

  // Constructor
  function new(string name = "fifo_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    fifo_sqr  = fifo_sequencer::type_id::create("fifo_sqr", this)  ; // Create the FIFO sequencer
    reset_sqr = reset_sequencer::type_id::create("reset_sqr", this); // Create the reset sequencer

  endfunction: build_phase

endclass: fifo_virtual_sequencer
