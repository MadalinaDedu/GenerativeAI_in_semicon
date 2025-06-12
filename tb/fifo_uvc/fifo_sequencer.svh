//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_sequencer.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

class fifo_sequencer extends uvm_sequencer #(fifo_transaction, fifo_transaction);

       `uvm_component_utils (fifo_sequencer)
        function new (string name="fifo_sequencer", uvm_component parent);
            super.new(name, parent);
        endfunction
endclass : fifo_sequencer


