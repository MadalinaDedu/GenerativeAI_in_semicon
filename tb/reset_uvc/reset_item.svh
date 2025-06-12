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
//  Description         :
//  ======================================================================================================

class reset_item extends uvm_sequence_item;

    rand bit unsigned  reset_signal;

    `uvm_object_utils_begin (reset_item)
    `uvm_field_int (reset_signal,     UVM_DEFAULT)
    `uvm_object_utils_end

    // Constructor
    function new(string name = "reset_item");
        super.new(name);
    endfunction

endclass
