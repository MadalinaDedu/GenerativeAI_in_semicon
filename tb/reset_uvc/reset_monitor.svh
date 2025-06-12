//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_monitor.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Monitors the reset signals from the design and sends them to the analysis port.
//  ======================================================================================================

class reset_monitor extends uvm_monitor;
    `uvm_component_utils(reset_monitor) // Macro to provide UVM component utilities for this class

    // Virtual interface to connect with the design
    virtual reset_interface vif;

    // Analysis port to send monitored items to other components (e.g., scoreboards)
    uvm_analysis_port #(reset_item) ap;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent); // Call base class constructor
        ap = new("ap", this);    // Create a new analysis port
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call base class build_phase

        // Get the virtual interface from the configuration database
        if (!uvm_config_db #(virtual reset_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted.") // Report error if interface is not defined
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        reset_item tr; // Declare transaction item

        forever begin
            tr = reset_item::type_id::create("tr"); // Create a new instance of reset_item
            tr.reset_signal = vif.reset; // Capture the current reset signal value from the interface
            ap.write(tr); // Send the captured transaction to the analysis port
            #1; // Wait for 1 time unit (to allow for simulation time)
        end
    endtask
endclass
