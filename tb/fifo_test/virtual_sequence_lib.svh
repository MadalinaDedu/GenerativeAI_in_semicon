//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei (FVA)
//  Date                  : 31/05/2024
//  File name             : virtual_sequence.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA)
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

// Define the base class for virtual sequences extending from uvm_sequence
class base_virtual_sequence extends uvm_sequence#(uvm_sequence_item);

    // Register the base_virtual_sequence class with the UVM factory
    `uvm_object_utils(base_virtual_sequence)
    
    // Declare the sequencer handle for the virtual sequencer
    `uvm_declare_p_sequencer(virtual_sequencer)

    // Constructor for the base_virtual_sequence class
    function new(string name = "base_virtual_sequence");
        super.new(name); // Call the base class constructor
    endfunction : new
endclass : base_virtual_sequence

// Define the fifo_rw_sequence class extending from base_virtual_sequence
class fifo_rw_sequence extends base_virtual_sequence;

    // Register the fifo_rw_sequence class with the UVM factory
    `uvm_object_utils(fifo_rw_sequence)

    // Typedef for easier reference to the FIFO sequence class
    typedef fifo_sequence fifo_obj_sequence;

    // Constructor for the fifo_rw_sequence class
    function new(string name = "fifo_rw_sequence");
      super.new(name); // Call the base class constructor
    endfunction : new

    // Body task for the FIFO read/write sequence
    task body();
      fifo_obj_sequence fifo_sequence; // Declare a variable for FIFO sequence
      fifo_sequence = fifo_obj_sequence::type_id::create("fifo_sequence"); // Create an instance of the FIFO sequence
      fifo_sequence.start(p_sequencer.fifo_seqr); // Start the FIFO sequence on the FIFO sequencer
    endtask : body

endclass : fifo_rw_sequence
