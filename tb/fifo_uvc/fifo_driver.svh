//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_driver.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : UVM driver is an active entity that has knowledge on how to drive signals to a particular interface of the design.
//  ======================================================================================================


`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_driver)

    virtual fifo_if vif;
    fifo_transaction tr;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Connect the virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted!")
        end
    endfunction

    // Driver task

    virtual task run_phase(uvm_phase phase);
        // super.run_phase(phase);
        reset_signals();
        @(posedge vif.rst);

        @( vif.cb_wr);
        forever begin
              // Get the next transaction from the sequencer
              seq_item_port.get_next_item(tr);
              if (tr.operation == WRITE)
                  repeat (tr.delay_wr) @( vif.cb_wr);
              else if (tr.operation == READ)
                  repeat (tr.delay_rd) @( vif.cb_rd);

              drive_transaction(tr);
              seq_item_port.item_done();

        end
    endtask

    virtual task drive_transaction(fifo_transaction tr);
        case (tr.operation)
            WRITE: begin
                @(vif.cb_wr);
                if (vif.rst && !vif.full) begin
                    vif.cb_wr.wr_en   <= 1;
                    vif.cb_wr.data_in <= tr.data;
                    @(vif.cb_wr);
                    vif.cb_wr.wr_en   <= 0;
                end
            end
            READ: begin
                @(vif.cb_rd);
                if (vif.rst && !vif.empty) begin
                vif.cb_rd.rd_en <= 1;
                $display("read here %d %t", vif.rd_en, $realtime); // Display read enable status
                @(vif.cb_rd); // Wait for next read clock event
                vif.cb_rd.rd_en <= 0; // Disable read
                $display("read here %d %t", vif.rd_en, $realtime); // Display read enable status
                end
            end
            default: `uvm_error(get_type_name(), "Invalid transaction type")
        endcase
    endtask

        // Task to assign 0 to all signals
    virtual task reset_signals();
        vif.cb_wr.wr_en   <= 0;
        vif.cb_wr.data_in <= 0;
        vif.cb_rd.rd_en   <= 0;
        $display("All signals initialized to 0 at time %t", $realtime);
    endtask
endclass

