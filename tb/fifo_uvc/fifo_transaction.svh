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
//  Description         : Defines the data fields for generating stimulus. Sequence items are randomized in sequences to generate stimulus.
//  ======================================================================================================

`include "uvm_macros.svh"
import uvm_pkg::*;

// Enumeration for FIFO operations
typedef enum  { WRITE, READ } operation_type;

// FIFO transaction class
class fifo_transaction extends uvm_sequence_item;

  // Constructor for the FIFO transaction class
  function new(string name = "fifo_transaction");
    super.new(name);
  endfunction : new

  // Randomly generated data fields
  rand bit[7:0] data                        ;                 // Data value to be written/read
  rand bit wr_en                            ;                 // Write enable signal
  rand bit rd_en                            ;                 // Read enable signal
  bit full                                  ;                 // Full flag (not randomized)
  bit empty                                 ;                 // Empty flag (not randomized)
  rand operation_type operation             ;                 // Operation type: WRITE or READ
  rand bit unsigned [3:0]     delay_rd      ;                 // Delay 
  rand bit unsigned [3:0]     delay_wr      ;                 // Delay 

  `uvm_object_utils_begin(fifo_transaction)
    `uvm_field_int (data, UVM_DEFAULT)                        // Field for data
    `uvm_field_enum (operation_type, operation , UVM_DEFAULT) // Field for operation type
    `uvm_field_int(wr_en, UVM_DEFAULT)                        // Field for write enable
    `uvm_field_int(rd_en, UVM_DEFAULT)                        // Field for read enable
    `uvm_field_int(full, UVM_DEFAULT)                         // Field for full flag
    `uvm_field_int(empty, UVM_DEFAULT)                        // Field for empty flag
    `uvm_field_int (delay_rd,     UVM_DEFAULT)                // DELAY
    `uvm_field_int (delay_wr,     UVM_DEFAULT)                // DELAY
  `uvm_object_utils_end

endclass