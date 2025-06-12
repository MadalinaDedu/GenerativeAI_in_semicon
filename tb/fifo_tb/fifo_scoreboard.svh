//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei (FVA)
//  Date                  : 31/05/2024
//  File name             : fifo_scoreboard.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA)
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

// Define the class fifo_scoreboard extending from uvm_scoreboard
class fifo_scoreboard extends uvm_scoreboard;

    // Register the fifo_scoreboard class with the UVM factory
    `uvm_component_utils(fifo_scoreboard)
    
    // Declare reset analysis implementation
    `uvm_analysis_imp_decl(_reset)
    
    // Declare fifo analysis implementation
    `uvm_analysis_imp_decl(_fifo)
    
    // Define analysis ports for reset and FIFO transactions
    uvm_analysis_imp_reset #(reset_item, fifo_scoreboard) reset_imp;
    uvm_analysis_imp_fifo #(fifo_transaction, fifo_scoreboard) fifo_imp;
    
    // Parameter to define the FIFO depth
    parameter int FIFO_DEPTH = 16;
    
    // Indices for tracking write and read operations
    int index_write;
    int index_read;
    
    // Virtual memories to store data for write and read operations
    bit[7:0] write_mem[FIFO_DEPTH];
    bit[7:0] read_mem[FIFO_DEPTH];
    
    // Virtual interface for reset
    virtual fifo_if vif;
    
    // Constructor for the fifo_scoreboard class
    function new(string name, uvm_component parent); 
        super.new(name, parent); // Call the base class constructor
        reset_imp = new("reset_imp", this); // Instantiate the reset analysis imp
        fifo_imp = new("fifo_imp", this); // Instantiate the FIFO analysis imp
    endfunction
    
    // Build phase function for setting up the scoreboard
    virtual function void build_phase(uvm_phase phase); 
        super.build_phase(phase); // Call the base class build_phase
    endfunction
    
    // Function to reset the FIFO memories
    virtual function void write_reset(reset_item rst); 
        if (rst.reset_signal == 0) begin // Check if reset signal is active low
            index_write = 0; // Reset the write index
            index_read = 0; // Reset the read index
            for (int i = 0; i < FIFO_DEPTH; i++) begin 
                write_mem[i] = '0; // Reset each element in write memory to zero 
                read_mem[i] = '0; // Reset each element in read memory to zero
            end 
            `uvm_info("SCOREBOARD", "FIFO memories have been reset", UVM_LOW) // Log reset action
        end 
    endfunction
    
    // Function to handle FIFO transactions
    virtual function void write_fifo(fifo_transaction tr); 
        `uvm_info("SCOREBOARD", $sformatf("operation = %s", tr.operation), UVM_LOW) // Log operation type
        for (int i = 0; i < index_write; i++) begin 
            `uvm_info("SCOREBOARD", $sformatf("write_mem[%d] = %d, index_write = %d", i, write_mem[i], index_write), UVM_LOW) // Log current write memory status
        end
        if (tr.operation == WRITE) begin // Check if operation is WRITE
            `uvm_info("SCOREBOARD", $sformatf("operation = %s", tr.operation), UVM_LOW) // Log write operation
            if (index_write < FIFO_DEPTH) begin 
                write_mem[index_write] = tr.data; // Store data in write memory 
                `uvm_info("SCOREBOARD", $sformatf("Write Operation: Index = %0d, Data = %0h", index_write, tr.data), UVM_LOW) // Log write action
                index_write++; // Increment write index
            end else begin 
                `uvm_info("SCOREBOARD", "Attempt to write to full FIFO", UVM_LOW) // Log attempt to write to full FIFO
            end 
            check_full_empty(tr); // Check FIFO status
        end else if (tr.operation == READ) begin // Check if operation is READ
            if (index_read < index_write) begin 
                read_mem[index_read] = tr.data; // Store data from the transaction to read_mem
                `uvm_info("SCOREBOARD", $sformatf("Read Operation: Index = %0d, Data = %0h", index_read, read_mem[index_read]), UVM_LOW) // Log read action
                index_read++; // Increment the read index
            end else begin 
                `uvm_info("SCOREBOARD", "Attempt to read from empty FIFO", UVM_LOW) // Log attempt to read from empty FIFO
            end 
            check_full_empty(tr); // Check FIFO status
        end else begin 
             `uvm_info("SCOREBOARD", $sformatf("Unknown operation type at time %t", $realtime), UVM_LOW) // Log unknown operation type
        end 
    endfunction

virtual function void check_full_empty(fifo_transaction tr);
    if (tr.wr_en && tr.full) begin
        `uvm_error("SCOREBOARD", "FIFO Write Operation") // Log Write Operation
    end
    if (tr.rd_en && tr.empty) begin
        `uvm_error("SCOREBOARD", "FIFO Read Operation") // Log Read Operation
    end
endfunction

    // Check phase to compare written and read data
    virtual function void check_phase(uvm_phase phase); 
        for (int i = 0; i < index_read; i++) begin
            if (write_mem[i] != read_mem[i]) begin
                `uvm_error("SCOREBOARD", $sformatf("Data mismatch at index %0d! Written: %0h, Read: %0h", i, write_mem[i], read_mem[i])) // Log data mismatch error
                //  `uvm_info("SCOREBOARD", $sformatf("Data mismatch at index %0d! Written: %0h, Read: %0h", i, write_mem[i], read_mem[i] ), UVM_LOW) // Log unknown operation type
            end else if (write_mem[i] != '0) begin
                `uvm_info("SCOREBOARD", $sformatf("Data match at index %0d! Data: %0h", i, write_mem[i]), UVM_LOW) // Log data match
            end
        end 
    endfunction
endclass
