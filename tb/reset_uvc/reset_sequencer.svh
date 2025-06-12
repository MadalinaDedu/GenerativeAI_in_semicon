//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_sequencer.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description           : reset_sequencer
//  ======================================================================================================
class reset_sequencer extends uvm_sequencer #(reset_item);
    `uvm_component_utils(reset_sequencer)

    function new(string name = "reset_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass