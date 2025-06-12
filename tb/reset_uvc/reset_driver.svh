//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_driver.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Defines the driver that applies reset sequences to the design under test (DUT).
//  ======================================================================================================

class reset_driver extends uvm_driver #(reset_item);
    `uvm_component_utils(reset_driver) // Macro to provide UVM component utilities for this class

    // Virtual interface for connecting to the design
    virtual reset_interface vif;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent); // Call base class constructor
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call base class build_phase

        // Get the virtual interface from the configuration database
        if (!uvm_config_db #(virtual reset_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted.") // Report fatal error if interface is not found
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        reset_item tr; // Declare transaction item
        forever begin
            seq_item_port.get_next_item(tr); // Get the next item from the sequencer
            vif.reset <= tr.reset_signal;    // Apply the reset signal to the design
            seq_item_port.item_done();       // Indicate that the item is processed
        end
    endtask
endclass
