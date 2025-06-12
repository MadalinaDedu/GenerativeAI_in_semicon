
class reset_monitor extends uvm_monitor;
  // UVM automation macros
  `uvm_component_utils(reset_monitor)

  // Virtual interface reference
  virtual reset_if vif;
  reset_item tr;

  // Analysis port to send out transactions
  uvm_analysis_port #(reset_item) analysis_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction : new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get interface directly from database
    if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_vif", vif))
      `uvm_fatal("RESET_MONITOR", "Failed to get virtual interface")

  endfunction : build_phase

  // Run phase
  task run_phase(uvm_phase phase);
    tr = reset_item::type_id::create("tr");

    forever begin

      // Capture the current state of the reset signal
      tr.reset = vif.reset;
      analysis_port.write(tr);
      #1;

      // `uvm_info("RESET_MONITOR", $sformatf("Reset change detected: value = %0b", tr.reset), UVM_LOW)
    end
  endtask : run_phase

endclass : reset_monitor
