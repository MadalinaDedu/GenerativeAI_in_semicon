//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_monitor.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Is responsible for capturing signal activity from the design interface and translate it into transaction level data objects that can be sent to other components.
//  ======================================================================================================

`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_monitor extends uvm_monitor;

  `uvm_component_utils(fifo_monitor)

  // Interface to the FIFO module
  virtual fifo_if vif;
  fifo_transaction tr;

  // Analysis port to send transactions to the scoreboard
  uvm_analysis_port#(fifo_transaction) analysis_port;

  // Delay counters
  bit [3:0] delay_counter_rd;
  bit [3:0] delay_counter_wr;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Connect the virtual interface
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_port = new ("analysis_port", this);

    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted!")
    end
    tr = fifo_transaction::type_id::create("tr");
  endfunction

  // Monitoring task
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    fork
      increment_delay_counters();
    join_none

    fork
      monitor_read();
      monitor_write();
    join
  endtask

  // Task to increment delay counters
  virtual task increment_delay_counters();
    forever begin
      @(posedge vif.clk_rd or posedge vif.clk_wr);
      if (!vif.rd_en) delay_counter_rd++;
      if (!vif.wr_en) delay_counter_wr++;
    end
  endtask

  // Monitor read operations
  virtual task monitor_read();
    forever begin
      @(posedge vif.clk_rd);
      if (vif.rd_en) begin
        tr.rd_en         = vif.rd_en       ;
        @(posedge vif.clk_rd);
        tr.operation     = READ            ;
        tr.wr_en         = vif.wr_en       ;
        tr.full          = vif.full        ;
        tr.empty         = vif.empty       ;
        tr.delay_rd      = delay_counter_rd; // Send delay counter value
        delay_counter_rd = 0               ; // Reset delay counter
        tr.data          = vif.data_out    ;
        `uvm_info(get_type_name(), $sformatf("Read data: %0h, rd_en: %0b, wr_en: %0b, full: %0b, empty: %0b, delay_rd: %0d", tr.data, tr.rd_en, tr.wr_en, tr.full, tr.empty, tr.delay_rd), UVM_LOW)
        analysis_port.write(tr);

      end
    end
  endtask

  // Monitor write operations
  virtual task monitor_write();
    forever begin
      @(posedge vif.clk_wr);
      if (vif.wr_en ) begin
        tr.operation     = WRITE;
        tr.wr_en         = vif.wr_en       ;
        tr.rd_en         = vif.rd_en       ;
        tr.full          = vif.full        ;
        tr.empty         = vif.empty       ;
        tr.delay_wr      = delay_counter_wr; // Send delay counter value
        delay_counter_wr = 0               ; // Reset delay counter
        tr.data          = vif.data_in     ;
        `uvm_info(get_type_name(), $sformatf("Write data: %0h, rd_en: %0b, wr_en: %0b, full: %0b, empty: %0b, delay_wr: %0d", tr.data, tr.rd_en, tr.wr_en, tr.full, tr.empty, tr.delay_wr), UVM_LOW)
        analysis_port.write(tr);

      end
    end
  endtask
endclass