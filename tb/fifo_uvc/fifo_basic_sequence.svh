//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_basic_sequence.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Container for sequence items (uvm_sequence_items) that are sent to the driver via the sequencer.
//  ======================================================================================================

// Base sequence class that will be inherited by other sequences
class fifo_base_sequence extends uvm_sequence #(fifo_transaction, fifo_transaction);
    `uvm_object_utils(fifo_base_sequence)  // Register the sequence with UVM

    // Declare the transaction item
    fifo_transaction fifo_tr;

    // Constructor
    function new(string name = "fifo_base_sequence");
        super.new(name);
        // Create the transaction item
        fifo_tr = fifo_transaction::type_id::create("fifo_tr");
    endfunction
endclass : fifo_base_sequence

// Basic FIFO sequence that extends from the base sequence
class fifo_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_sequence)  // Register the sequence with UVM

    fifo_transaction tr; // Transaction item instance

    // Constructor
    function new(string name = "fifo_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr"); // Create the transaction item
    endfunction

    // Task to define the sequence body
    virtual task body();

        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting basic FIFO sequence", UVM_LOW)

        // Example write transactions
        for(int i = 0; i <= 17; i++) begin
            start_item(tr);  // Start the transaction
            tr.operation = WRITE; // Set operation to WRITE
            tr.data = i + 1;  // Set data value

            finish_item(tr); // Complete the transaction
        end

        // Example read transactions
        for(int i = 0; i <= 17; i++) begin
            start_item(tr);  // Start the transaction
            tr.operation = READ; // Set operation to READ
            finish_item(tr); // Complete the transaction
        end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished basic FIFO sequence", UVM_LOW)
    endtask
endclass

// Write-only FIFO sequence
class fifo_write_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_write_sequence)  // Register the sequence with UVM

    fifo_transaction tr; // Transaction item instance

    function new(string name = "fifo_write_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr"); // Create the transaction item
    endfunction

    virtual task body();
        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting write-only FIFO sequence", UVM_LOW)

        // Generate write transactions with incremental data
        for(int i = 1; i <= 16; i++) begin
            // start_item(tr);  // Start the transaction
            // tr.operation = WRITE; // Set operation to WRITE
            // tr.data = i * 2;  // Set data value
            // delay_rd = 1;
            // delay_wr = 2;

            // finish_item(tr); // Complete the transaction

            start_item(fifo_tr);
            if (!(fifo_tr.randomize() with {
                    operation inside {WRITE};
                    data == i * 2;
                    delay_rd == 1;
                    delay_wr == 2;
                })) begin
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            end
            finish_item(fifo_tr);
        end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished write-only FIFO sequence", UVM_LOW)
    endtask
endclass

// Read-only FIFO sequence
class fifo_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_read_sequence)  // Register the sequence with UVM

    fifo_transaction tr; // Transaction item instance

    function new(string name = "fifo_read_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr"); // Create the transaction item
    endfunction

    virtual task body();
        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting read-only FIFO sequence", UVM_LOW)

        // Generate read transactions
        for(int i = 1; i <= 16; i++) begin
            start_item(fifo_tr);
            if (!(fifo_tr.randomize() with {
                    operation inside {READ};
                    data == i * 2;
                    delay_rd == 1;
                    delay_wr == 2;
                })) begin
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            end
            finish_item(fifo_tr);
        end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished read-only FIFO sequence", UVM_LOW)
    endtask
endclass

// Single write FIFO sequence
class fifo_single_write_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_single_write_sequence)  // Register the sequence with UVM


    function new(string name = "fifo_single_write_sequence");
        super.new(name);
    endfunction

    virtual task body();

        fifo_transaction tr; // Transaction item instance
        tr = fifo_transaction::type_id::create("tr"); // Create the transaction item

        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting single write FIFO sequence", UVM_LOW)

        start_item(tr);  // Start the transaction
        if (!(tr.randomize() with {
                operation == WRITE; // Ensure the operation is WRITE
                data inside {[0:255]}; // Randomize data within range
                delay_rd == 0;
                delay_wr == 0;
            })) begin
            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
        end
        finish_item(tr); // Complete the transaction

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished single write FIFO sequence", UVM_LOW)
    endtask
endclass

// Single read FIFO sequence
class fifo_single_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_single_read_sequence)  // Register the sequence with UVM


    function new(string name = "fifo_single_read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        // Log the start of the sequence
        fifo_transaction tr; // Transaction item instance
        tr = fifo_transaction::type_id::create("tr"); // Create the transaction item

        `uvm_info(get_type_name(), "Starting single read FIFO sequence", UVM_LOW)

        start_item(tr);  // Start the transaction
        tr.operation = READ; // Set operation to READ
        finish_item(tr); // Complete the transaction

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished single read FIFO sequence", UVM_LOW)
    endtask
endclass

// Random write sequence
class random_write_sequence extends fifo_base_sequence;
    `uvm_object_utils(random_write_sequence)  // Register the sequence with UVM

    function new(string name = "random_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        // Write random data to FIFO
        repeat (2) begin
        start_item(fifo_tr);
            if (!(fifo_tr.randomize() with {
                    operation inside {WRITE};
                    data inside {[0:255]};
                    delay_rd == 1;
                    delay_wr == 15;
                })) begin
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            end
            finish_item(fifo_tr);
        end
    endtask : body

endclass : random_write_sequence

// Random operation sequence (WRITE or READ)
class random_operation_sequence extends fifo_base_sequence;
    `uvm_object_utils(random_operation_sequence)  // Register the sequence with UVM
    function new(string name = "random_operation_sequence");
        super.new(name);
    endfunction
    virtual task body();
        repeat (10) begin
            // Interval 1: [0:63]
            start_item(fifo_tr); // Start the transaction
            if (!(fifo_tr.randomize() with {  
                operation inside {READ, WRITE}; // Randomize operation (READ or WRITE)
                data inside {[0:63]}; // Randomize data within range [0:63]
                delay_rd == 0;
                delay_wr == 0;
            }))
                `uvm_error(get_type_name(), "Randomization failed")
            finish_item(fifo_tr); // Complete the transaction
            // Interval 2: [64:127]
            start_item(fifo_tr); // Start the transaction
            if (!(fifo_tr.randomize() with {  
                operation inside {READ, WRITE}; // Randomize operation (READ or WRITE)
                data inside {[64:127]}; // Randomize data within range [64:127]
                delay_rd == 0;
                delay_wr == 0;
            }))
                `uvm_error(get_type_name(), "Randomization failed")
            finish_item(fifo_tr); // Complete the transaction
            // Interval 3: [128:191]
            start_item(fifo_tr); // Start the transaction
            if (!(fifo_tr.randomize() with {  
                operation inside {READ, WRITE}; // Randomize operation (READ or WRITE)
                data inside {[128:191]}; // Randomize data within range [128:191]
                delay_rd == 0;
                delay_wr == 0;
            }))
                `uvm_error(get_type_name(), "Randomization failed")
            finish_item(fifo_tr); // Complete the transaction
            // Interval 4: [192:255]
            start_item(fifo_tr); // Start the transaction
            if (!(fifo_tr.randomize() with {  
                operation inside {READ, WRITE}; // Randomize operation (READ or WRITE)
                data inside {[192:255]}; // Randomize data within range [192:255]
                delay_rd == 0;
                delay_wr == 0;
            }))
                `uvm_error(get_type_name(), "Randomization failed")
            finish_item(fifo_tr); // Complete the transaction
        end
    endtask : body
endclass : random_operation_sequence

// Write data in specified ranges, then read to verify
class writes_and_read_in_ranges_sequence extends fifo_base_sequence;
    `uvm_object_utils(writes_and_read_in_ranges_sequence)  // Register the sequence with UVM

    function new(string name = "writes_and_read_in_ranges_sequence");
        super.new(name);
    endfunction

    int idx = 0; // Index for data array
    bit [7:0] data_array [16]; // Array to store written data

    virtual task body();
        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting writes in ranges sequence", UVM_LOW)

        // Write data in specified ranges
        for (int i = 0; i < 4; i++) begin
            int start_range = i * 64;
            for (int j = 0; j < 4; j++) begin
                start_item(fifo_tr); // Start the transaction
                if (!(fifo_tr.randomize() with {
                    operation == WRITE; // Ensure the operation is WRITE
                    delay_rd == 0;
                    delay_wr == 0;
                    data inside { [start_range : start_range + 63] }; // Randomize data within range
                }))
                    `uvm_error(get_type_name(), "Randomization failed")
                data_array[idx++] = fifo_tr.data; // Store data in array
                finish_item(fifo_tr); // Complete the transaction
            end
        end

        // Read data to verify
        for (int i = 0; i < 16; i++) begin
            start_item(fifo_tr); // Start the transaction
            if (!(fifo_tr.randomize() with { operation == READ; })) // Ensure the operation is READ
                `uvm_error(get_type_name(), "Randomization failed")
            finish_item(fifo_tr); // Complete the transaction
        end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished writes in ranges sequence", UVM_LOW)
    endtask : body
endclass : writes_and_read_in_ranges_sequence

// 100 write-only transactions
class write_100_sequence extends fifo_base_sequence;
    `uvm_object_utils(write_100_sequence)  // Register the sequence with UVM

    function new(string name = "write_100_sequence");
        super.new(name);
    endfunction

    virtual task body();
        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting 100 write-only FIFO sequence", UVM_LOW)

        // Generate 100 write transactions
        for(int i = 0; i < 100; i++) begin
            start_item(fifo_tr); // Start the transaction
            fifo_tr.operation = WRITE; // Set operation to WRITE
            fifo_tr.data = $random % 256; // Randomize data within 0-255
            finish_item(fifo_tr); // Complete the transaction
        end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished 100 write-only FIFO sequence", UVM_LOW)
    endtask
endclass : write_100_sequence

// Repeated write and read operations
class repeated_write_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(repeated_write_read_sequence)  // Register the sequence with UVM

    function new(string name = "repeated_write_read_sequence");
        super.new(name);
    endfunction

    fifo_transaction fifo_tr; // Transaction item instance

    virtual task body();
        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting repeated write and read FIFO sequence", UVM_LOW)

        fifo_tr = fifo_transaction::type_id::create("fifo_tr"); // Create a new transaction item
        // repeat(40) begin
            // Perform 16 writes
            for(int i = 0; i < 16; i++) begin
                start_item(fifo_tr); // Start the transaction
                if (!(fifo_tr.randomize() with { operation == WRITE; data inside {[0:255]}; })) begin
                    `uvm_error(get_type_name(), "Randomization failed for write operation")
                end
                finish_item(fifo_tr); // Complete the transaction
            end

            // Perform read operations
            for(int i = 0; i < 16; i++) begin
                start_item(fifo_tr); // Start the transaction
                if (!(fifo_tr.randomize() with { operation == READ; data inside {[0:255]}; })) begin
                    `uvm_error(get_type_name(), "Randomization failed for read operation")
                end
                finish_item(fifo_tr); // Complete the transaction
            end

            // Perform another 16 writes
            for(int i = 0; i < 16; i++) begin
                start_item(fifo_tr); // Start the transaction
                if (!(fifo_tr.randomize() with { operation == WRITE; data inside {[0:255]}; })) begin
                    `uvm_error(get_type_name(), "Randomization failed for write operation")
                end
                finish_item(fifo_tr); // Complete the transaction
            end

            // Final 16 reads operation
             for(int i = 0; i < 16; i++) begin
            start_item(fifo_tr); // Start the transaction
            if (!(fifo_tr.randomize() with { operation == READ; data inside {[0:255]}; })) begin
                `uvm_error(get_type_name(), "Randomization failed for read operation")
            end
            finish_item(fifo_tr); // Complete the transaction
            end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished repeated write and read FIFO sequence", UVM_LOW)
    endtask
endclass : repeated_write_read_sequence


class write_all_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(write_all_sequence) // Macro for UVM object utilities
 
    // Constructor
    function new(string name = "write_all_sequence");
        super.new(name); // Call the parent constructor
    endfunction : new
 
    // Task to define the sequence body
    virtual task body();
        fifo_transaction tr; // Transaction handle
 
        // Create a new transaction
        tr = fifo_transaction::type_id::create("tr");
 
        // Start the transaction and configure it for a write operation
        for (int i = 0; i < 16; i++) begin
            this.start_item(tr);
            tr.operation = WRITE;
            tr.data = i + 1; // You can modify this line to write the data you want
            this.finish_item(tr);
        end
    endtask : body
endclass
 
 class read_all_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(read_all_sequence) // Macro for UVM object utilities
 
    // Constructor
    function new(string name = "read_all_sequence");
        super.new(name); // Call the parent constructor
    endfunction : new
 
    // Task to define the sequence body
    virtual task body();
        fifo_transaction tr; // Transaction handle
 
        // Create a new transaction
        tr = fifo_transaction::type_id::create("tr");
 
        // Start the transaction and configure it for a read operation
        for (int i = 0; i < 16; i++) begin
            this.start_item(tr);
            tr.operation = READ;
            this.finish_item(tr);
        end
    endtask : body
endclass

class fifo_write_without_delay_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_write_without_delay_sequence)  // Register the sequence with UVM

    fifo_transaction tr; // Transaction item instance

    function new(string name = "fifo_write_without_delay_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr"); // Create the transaction item
    endfunction

    virtual task body();
        // Log the start of the sequence
        `uvm_info(get_type_name(), "Starting write-only FIFO sequence", UVM_LOW)

        // Generate write transactions with incremental data
        for(int i = 1; i <= 16; i++) begin
            start_item(fifo_tr);
            if (!(fifo_tr.randomize() with {
                    operation inside {WRITE};
                    data inside {[0:255]};
                    delay_rd == 0;
                    delay_wr == 0;
                })) begin
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            end
            finish_item(fifo_tr);
        end

        // Log the end of the sequence
        `uvm_info(get_type_name(), "Finished write-only FIFO sequence", UVM_LOW)
    endtask
endclass: fifo_write_without_delay_sequence

class complex_operation_sequence extends fifo_base_sequence;
    `uvm_object_utils(complex_operation_sequence)
     fifo_transaction tr; // Transaction item instance
    // Constructor
    function new(string name = "complex_operation_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr");
    endfunction
 
    // Task to define the sequence body
    virtual task body();
        // Perform the operations in the specified order
        // 1. First 5 write operations with random data
        repeat (5) begin
            start_item(fifo_tr);
            if (!(fifo_tr.randomize() with {
                operation == WRITE;
                delay_rd == 0;
                delay_wr == 0;
                data inside {[0:255]};
            })) begin
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            end
            finish_item(fifo_tr);
        end
 
        // 2. Second 5 write operations with random data
        repeat (5) begin
            start_item(fifo_tr);
            if (!(fifo_tr.randomize() with {
                operation == WRITE;
                delay_rd == 0;
                delay_wr == 0;
                data inside {[0:255]};
            })) begin
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            end
            finish_item(fifo_tr);
        end
 
        // 3. Perform a read operation
        repeat (5) begin
        start_item(fifo_tr);
        if (!(fifo_tr.randomize() with {
            operation == READ;
        })) begin
            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
        end
        finish_item(fifo_tr);
        end

        `uvm_info(get_type_name(), "Completed complex operations in the specified order", UVM_LOW)
    endtask : body
endclass : complex_operation_sequence