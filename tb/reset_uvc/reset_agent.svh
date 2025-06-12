//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_agent.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Defines the reset agent, which includes sequencer, driver, and monitor for reset operations.
//  ======================================================================================================

class reset_agent extends uvm_agent;
    `uvm_component_utils(reset_agent) // Macro to provide UVM component utilities for this class

    // Constructor
    function new(string name = "reset_agent", uvm_component parent);
        super.new(name, parent); // Call base class constructor
    endfunction

    // Sequencer for generating reset sequences
    reset_sequencer seqr;
    // Driver to apply reset sequences to the design
    reset_driver drv;
    // Monitor to observe and analyze reset operations
    reset_monitor mon;

    // Virtual interface for connecting to the design
    virtual reset_interface rvif;

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call base class build_phase

        // Create sequencer, driver, and monitor if the agent is active
        if (get_is_active()) begin
            seqr = reset_sequencer::type_id::create("seqr", this); // Create sequencer
            drv = reset_driver::type_id::create("drv", this);     // Create driver
        end

        // Create monitor
        mon = reset_monitor::type_id::create("mon", this); 
    endfunction

    // Connect phase
    function void connect_phase(uvm_phase phase);
        // Connect the driver to the sequencer if the agent is active
        if (get_is_active())
            drv.seq_item_port.connect(seqr.seq_item_export); // Connect driver’s seq_item_port to sequencer’s seq_item_export
    endfunction
endclass
