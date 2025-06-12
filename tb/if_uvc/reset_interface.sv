//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_if.sv
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : It is a way to encapsulate signals into a block. All related signals are grouped together to form an interface block so that the same interface.
//  ======================================================================================================

interface reset_interface(
    
    input logic clk);
          bit reset;

endinterface
