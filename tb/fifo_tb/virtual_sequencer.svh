//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei (FVA)
//  Date                  : 31/05/2024
//  File name             : virtual_sequencer.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA)
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

// Define the class virtual_sequencer extending from uvm_sequencer
class virtual_sequencer extends uvm_sequencer;

    // Register the virtual_sequencer class with the UVM factory
    `uvm_component_utils(virtual_sequencer)

    // Declare the sequencer handles
    fifo_sequencer fifo_seqr; // Instance of FIFO sequencer
    reset_sequencer reset_seqr; // Instance of reset sequencer

    // Constructor for the virtual_sequencer class
    function new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Build phase function for setting up the sequencer
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call the base class build_phase

        // Instantiate the sequencers
        fifo_seqr = fifo_sequencer::type_id::create("fifo_seqr", this);
        reset_seqr = reset_sequencer::type_id::create("reset_seqr", this);
    endfunction
endclass







