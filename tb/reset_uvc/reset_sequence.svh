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
//  Description         : container that holds data items (uvm_sequence_items) which are sent to the driver via the sequencer
//  ======================================================================================================

class reset_sequence extends uvm_sequence #(reset_item);
    `uvm_object_utils(reset_sequence)

    reset_item tr;
    function new(string name = "reset_sequence");
        super.new(name);
    endfunction

    virtual task body();
        tr = reset_item::type_id::create("tr");

        start_item(tr);
          tr.reset_signal = 0;
        finish_item(tr);

        #100;
        start_item(tr);
          tr.reset_signal = 1;
        finish_item(tr);

    endtask
endclass