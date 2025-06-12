//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_sequence.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Defines a sequence for generating reset signals during simulation.
//  ======================================================================================================

class reset_sequence extends uvm_sequence #(reset_item);
    `uvm_object_utils(reset_sequence) // Macro to provide UVM object utilities for this class

    // Constructor
    function new(string name = "reset_sequence");
        super.new(name); // Call base class constructor
    endfunction

    reset_item tr; // Transaction item for carrying reset signal

    // Sequence body
    virtual task body();
        `uvm_info(get_type_name(), "Starting reset sequence", UVM_LOW) // Log message indicating start of sequence

        tr = reset_item::type_id::create("tr"); // Create a new instance of reset_item

        // Drive reset signal
        start_item(tr); // Start the sequence item
        tr.reset_signal = 1'b0; // Assert reset (set reset signal to low)
        finish_item(tr); // Finish the sequence item

        #100; // Hold reset for 100 time units

        start_item(tr); // Start the sequence item again
        tr.reset_signal = 1'b1; // Deassert reset (set reset signal to high)
        finish_item(tr); // Finish the sequence item

        `uvm_info(get_type_name(), "Finished reset sequence", UVM_LOW) // Log message indicating end of sequence
    endtask
endclass
