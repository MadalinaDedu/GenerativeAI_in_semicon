class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)

  fifo_sequencer sequencer;
  fifo_driver    driver   ;
  fifo_monitor   monitor  ;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);


    if (get_is_active() == UVM_ACTIVE) begin
      sequencer = fifo_sequencer::type_id::create("sequencer", this);
      driver    = fifo_driver::type_id::create("driver", this)      ;
    end
    monitor = fifo_monitor::type_id::create("monitor", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass
