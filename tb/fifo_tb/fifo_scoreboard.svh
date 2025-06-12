//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_scoreboard.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // Analysis implementation for getting transactions from the monitor
    `uvm_analysis_imp_decl(_reset) // Declare reset analysis imp
    `uvm_analysis_imp_decl(_fifo)  // Declare fifo analysis imp

    // Analysis ports
    uvm_analysis_imp_reset #(reset_item, fifo_scoreboard)      reset_imp;
    uvm_analysis_imp_fifo #(fifo_transaction, fifo_scoreboard) fifo_imp ;

    fifo_transaction fifo_tr ;
    reset_item       reset_tr;

    bit [8-1:0] fifo[16]         ;  // Array for storing written data
    int         index_read    = 0;  // Index for the current position in the array for read
    int         index_write   = 0;  // Index for the current position in the array for write
    int         element_count = 0;  // Counter for the number of elements in the FIFO

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_imp = new("fifo_imp", this  );
        reset_imp = new("reset_imp", this);

    endfunction

    virtual function void write_reset(reset_item rst);
        if (!rst.reset_signal) begin
            index_read    = 0;
            index_write   = 0;
            element_count = 0;

            for (int i = 0; i < 16; i++)
                fifo[i] = 0; // Reset each element in write memory to zero

            `uvm_info("SCOREBOARD", "FIFO memory has been reset", UVM_LOW)
        end
    endfunction


    // Write function
    virtual function void write_fifo(fifo_transaction tr);
        // Scoreboarding logic
        if (tr.operation == WRITE && element_count <= 16) begin

            fifo[index_write] = tr.data;  // Store the written data in the FIFO
            `uvm_info("SCOREBOARD WRITE", $sformatf("Data Match: tr.data = %h : fifo[%d] = %h", tr.data, index_write, fifo[index_write]), UVM_LOW)
            index_write   = (index_write + 1) % 16;
            element_count = element_count + 1     ;

        end else if (tr.operation == READ && element_count >= 0) begin
            // Check if the read data matches the expected data
            if (tr.data != fifo[index_read]) begin
                `uvm_error("SCOREBOARD:", $sformatf("Data mismatch! %t tr.data = %h : fifo[%d] = %h", $realtime, tr.data, index_read, fifo[index_read]));
            end else begin
                `uvm_info("SCOREBOARD READ", $sformatf("Data Match: tr.data = %h : fifo[%d] = %h fifo:write[%d] = %h", tr.data, index_read, fifo[index_read], index_write, fifo[index_write]), UVM_LOW)
            end
            index_read    = (index_read + 1) % 16;
            element_count = element_count - 1    ;
        end

        if (tr.wr_en && tr.full)
            `uvm_error("SCOREBOARD:", $sformatf("Full: Try to write when full at time: %t", $realtime));
        if (tr.rd_en && tr.empty)
            `uvm_error("SCOREBOARD:", $sformatf("Empty: Try to read when empty at time: %t", $realtime));
    endfunction

endclass


