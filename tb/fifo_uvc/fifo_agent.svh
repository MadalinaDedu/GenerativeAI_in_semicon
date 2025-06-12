//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_agent.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : An agent who encapsulates a Sequencer, Driver and Monitor into a single entity by instantiating and connecting the components together via interfaces.
//  ======================================================================================================

// include "uvm_macros.svh"
import uvm_pkg::*;
class fifo_agent extends uvm_agent;

  `uvm_component_utils(fifo_agent)

  fifo_driver driver;
  fifo_monitor monitor;
  fifo_sequencer fifo_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (get_is_active() == UVM_ACTIVE) begin
      fifo_seq = fifo_sequencer::type_id::create("fifo_seq", this);
      driver   = fifo_driver::type_id::create("driver", this);
    end

    monitor = fifo_monitor::type_id::create("monitor", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(fifo_seq.seq_item_export);
    end
  endfunction
endclass


