// File: reset_driver.svh

class reset_driver extends uvm_driver #(reset_item);
  `uvm_component_utils(reset_driver)
  virtual reset_if vif;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get virtual interface from config db
    if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_vif", vif))
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : build_phase

  // Run phase
  virtual task run_phase(uvm_phase phase);
  reset_item reset_tx;
    forever begin
      // Get the next transaction from the sequencer
      seq_item_port.get_next_item(reset_tx);
       vif.reset <= reset_tx.reset;
      seq_item_port.item_done();
    end
  endtask : run_phase
endclass : reset_driver
