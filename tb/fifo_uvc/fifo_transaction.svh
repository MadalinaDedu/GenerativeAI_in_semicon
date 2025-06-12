//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_transaction.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : It consist of data fields required for generating the stimulus.In order to generate the stimulus, the sequence items are randomized in sequences.
//  ======================================================================================================


`include "uvm_macros.svh"
import uvm_pkg::*;
typedef enum  { WRITE, READ } operation_type;

class fifo_transaction extends uvm_sequence_item;

  function new(string name = "fifo_transaction");
    super.new(name);
  endfunction : new

  rand bit[7:0]       data;
  rand operation_type operation;
  rand bit            wr_en;
  rand bit            rd_en;
       bit            full;
       bit            empty;
  rand bit[3:0]       delay_rd; // 4-bit variable for read delay
  rand bit[3:0]       delay_wr; // 4-bit variable for write delay

  `uvm_object_utils_begin(fifo_transaction)
    `uvm_field_int (data      , UVM_DEFAULT)
    `uvm_field_enum (operation_type, operation , UVM_DEFAULT)
    `uvm_field_int (wr_en     , UVM_DEFAULT)
    `uvm_field_int (rd_en     , UVM_DEFAULT)
    `uvm_field_int (full      , UVM_DEFAULT)
    `uvm_field_int (empty     , UVM_DEFAULT)
    `uvm_field_int (delay_rd  , UVM_DEFAULT) // Registering delay_rd
    `uvm_field_int (delay_wr  , UVM_DEFAULT) // Registering delay_wr
  `uvm_object_utils_end

endclass