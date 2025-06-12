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
//  Description         : Implements a UVM driver for driving transactions to the FIFO module. It includes
//                        handling of transactions and interfacing with the FIFO's signals.
//  ======================================================================================================

`include "uvm_macros.svh" // Include UVM macros
import uvm_pkg::*; // Import UVM package

// Define the fifo_driver class, which extends uvm_driver parameterized with fifo_transaction
class fifo_driver extends uvm_driver#(fifo_transaction);
    `uvm_component_utils(fifo_driver) // Macro to register the component with the factory
    // Constructor
    function new(string name="fifo_driver", uvm_component parent);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Declare a virtual interface to interact with the FIFO module
    virtual fifo_if vif;
    // Declare a transaction object
    fifo_transaction tr;
    // Task to initialize all interface signals to zero

    virtual task init_signals();
        vif.cb_wr.wr_en   <= 0;
        vif.cb_wr.data_in <= 0;
        vif.cb_rd.rd_en   <= 0;
        $display("All signals initialized to 0 at time %t", $realtime);
    endtask
 
    // Override the build_phase to connect the virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call the base class build_phase
        // Retrieve the virtual interface from the configuration database
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted!")
        end
    endfunction

    // Override the run_phase to implement the driving functionality
    virtual task run_phase(uvm_phase phase);
        // Call the task to initialize all signals
        // Main driving loop
        init_signals();
        forever begin
            // Wait for reset to become inactive (high)
            @(posedge vif.rst);
            // Proceed with normal operation
            forever begin
                // Get the next transaction from the sequencer
                seq_item_port.get_next_item(tr);
                repeat(tr.delay_rd) @(vif.cb_rd) ;      // Repeat used for delay
                repeat(tr.delay_wr) @(vif.cb_wr) ;      // Repeat used for delay
                // Drive the transaction to the DUT
                drive_transaction(tr);
                // Indicate that the item is done
                seq_item_port.item_done();
            end
        end
    endtask
    // Task to apply the transaction to the DUT
    virtual task drive_transaction(fifo_transaction tr);
        $display("Operation driver %s %t", tr.operation, $realtime); // Display the operation
        case (tr.operation)
            // Handle WRITE operation
            WRITE: begin
                @(vif.cb_wr); // Wait for write clock event
                if (vif.rst && ~vif.full) begin // Check if reset is active and FIFO is not full
                    vif.cb_wr.wr_en   <= 1; // Enable write
                    vif.cb_wr.data_in <= tr.data; // Provide data to be written
                    $display("write here %d %t", vif.wr_en, $realtime); // Display write enable status
                    @(vif.cb_wr); // Wait for next write clock event
                    vif.cb_wr.wr_en <= 0; // Disable write
                    $display("write here %d %t", vif.wr_en, $realtime); // Display write enable status
                end
            end
            // Handle READ operation
            READ: begin
                @(vif.cb_rd); // Wait for read clock event
                if (vif.rst && ~vif.empty) begin // Check if reset is active and FIFO is not empty
                    vif.cb_rd.rd_en <= 1; // Enable read
                    $display("read here %d %t", vif.rd_en, $realtime); // Display read enable status
                    @(vif.cb_rd); // Wait for next read clock event
                    vif.cb_rd.rd_en <= 0; // Disable read
                    $display("read here %d %t", vif.rd_en, $realtime); // Display read enable status
                end
            end
            // Handle invalid transaction types
            default: `uvm_error(get_type_name(), "Invalid transaction type")
        endcase
    endtask
endclass

 