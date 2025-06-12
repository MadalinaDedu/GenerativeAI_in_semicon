//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_item.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : It consist of data fields required for generating the stimulus.In order to generate the stimulus, the sequence items are randomized in sequences.
//  ======================================================================================================


class reset_item extends uvm_sequence_item;
    `uvm_object_utils(reset_item)


    function new(string name = "reset_item");
        super.new(name);
    endfunction

    rand bit reset_signal;
endclass