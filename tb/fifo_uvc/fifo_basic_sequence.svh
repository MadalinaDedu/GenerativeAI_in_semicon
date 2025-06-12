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
//  Description         : container that holds data items (uvm_sequence_items) which are sent to the driver via the sequencer
//  ======================================================================================================

class fifo_base_sequence extends uvm_sequence #(fifo_transaction, fifo_transaction);
    `uvm_object_utils(fifo_base_sequence)

      fifo_transaction fifo_tr;

    // Constructor
    function new(string name = "fifo_base_sequence");
        super.new(name);
        fifo_tr = fifo_transaction::type_id::create("fifo_tr");
    endfunction : new

endclass : fifo_base_sequence

class fifo_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_sequence)

    fifo_transaction tr; //move the instantiation here from body
    // Constructor
    function new(string name = "fifo_sequence");
        super.new(name);
          tr = fifo_transaction::type_id::create("tr"); //move the create instantiation here from body
    endfunction

    // Task to define the sequence body
    virtual task body();

        `uvm_info(get_type_name(), "Starting basic FIFO sequence", UVM_LOW)

        for(int i=0;i<=17;i++) begin
            start_item(tr);
               tr.operation = WRITE; // move the item randmoization here -> it was above start item
               tr.data      = i+1  ;
            finish_item(tr);
        end

        for(int i=0;i<=17;i++) begin
          start_item(tr);
            tr.operation = READ; // move the item randmoization here -> was above start item
          finish_item(tr);
        end

        `uvm_info(get_type_name(), "Finished basic FIFO sequence", UVM_LOW)
    endtask
endclass

class write_sequence extends fifo_base_sequence;
    `uvm_object_utils(write_sequence)

    function new(string name = "write_sequence");
        super.new(name);
    endfunction : new

    virtual task body();

        // Start the transaction
        this.start_item(fifo_tr);

        // Configure the transaction for a write operation
        fifo_tr.operation = WRITE  ;
        fifo_tr.data      = $random;  // Or set to a specific value

        // Finish the transaction
        this.finish_item(fifo_tr);

    endtask : body
endclass

class read_sequence extends fifo_base_sequence;

    `uvm_object_utils(read_sequence)

    fifo_transaction tr;  // Create a new transaction

    function new(string name = "read_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr");
    endfunction : new

    virtual task body();

        this.start_item(tr);    // Start the transaction
          tr.operation = READ;  // Configure the transaction for a read operation
        this.finish_item(tr);   // Finish the transaction

    endtask : body
endclass

class fifo_random_operation_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_random_operation_sequence)

    fifo_transaction fifo_tr;

    function new(string name = "fifo_random_operation_sequence");
        super.new(name);
        fifo_tr = fifo_transaction::type_id::create("fifo_tr");
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Starting random operation FIFO sequence", UVM_LOW)

        for(int i=0;i<30;i++) begin
            start_item(fifo_tr);
            if (!(fifo_tr.randomize() with { operation inside {WRITE, READ};
                                                       data inside {[0:255]};}))

            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(fifo_tr);
        end

        `uvm_info(get_type_name(), "Finished random operation FIFO sequence", UVM_LOW)
    endtask
endclass

class fifo_4_writes_in_each_range_and_read_all_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_4_writes_in_each_range_and_read_all_sequence)

    fifo_transaction fifo_tr;

    function new(string name = "fifo_4_writes_in_each_range_and_read_all_sequence");
        super.new(name);
        fifo_tr = fifo_transaction::type_id::create("fifo_tr");
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Starting 4 writes in each range and read all FIFO sequence", UVM_LOW)
        for (int i = 0; i < 4; i++) begin
            start_item(fifo_tr);
              if (!(fifo_tr.randomize() with { operation inside {WRITE} ;
                                               data      inside {[0:63]};
                                               delay_rd  == 1           ;
                                               delay_wr  == 2           ;}))
            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(fifo_tr);

            start_item(fifo_tr);
              if (!(fifo_tr.randomize() with { operation inside {WRITE}   ;
                                               data      inside {[64:126]};
                                               delay_rd  == 1             ;
                                               delay_wr  == 2             ;}))
            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(fifo_tr);

            start_item(fifo_tr);
              if (!(fifo_tr.randomize() with { operation inside {WRITE}    ;
                                               data      inside {[127:189]};
                                               delay_rd  == 1              ;
                                               delay_wr  == 2              ;}))
            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(fifo_tr);

            start_item(fifo_tr);
              if (!(fifo_tr.randomize() with { operation inside {WRITE}    ;
                                               data      inside {[190:255]};
                                               delay_rd  == 1              ;
                                               delay_wr  == 2              ;}))
              `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(fifo_tr);
        end
        // Add your read operations here
        `uvm_info(get_type_name(), "Finished 4 writes in each range and read all FIFO sequence", UVM_LOW)
    endtask
endclass

class fifo_100_writes_and_reads_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_100_writes_and_reads_sequence)

    fifo_transaction tr;

    function new(string name = "fifo_100_writes_and_reads_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr");
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Starting 100 writes and some reads FIFO sequence", UVM_LOW)
        for (int i = 0; i < 16; i++) begin
            start_item(tr);
                  if (!(tr.randomize() with { operation inside {WRITE}  ;
                                              data      inside {[0:255]};}))
                  `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);

        end
    endtask
endclass

class fifo_16_writes_read_all_repeat_4_times_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_16_writes_read_all_repeat_4_times_sequence)

    fifo_transaction tr;

    function new(string name = "fifo_16_writes_read_all_repeat_4_times_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr");
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Starting 16 writes, read all, repeat 4 times FIFO sequence", UVM_LOW)
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 16; j++) begin
                start_item(tr);
                  if (!(tr.randomize() with { operation inside {WRITE}  ;
                                              data      inside {[0:255]};}))
                  `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
                finish_item(tr);
            end

            for (int j = 0; j < 16; j++) begin
                start_item(tr);
                if (!(tr.randomize() with { operation inside {READ};}))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
                finish_item(tr);
            end
        end
        `uvm_info(get_type_name(), "Finished 16 writes, read all, repeat 4 times FIFO sequence", UVM_LOW)
    endtask
endclass

class fifo_coverage_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_coverage_sequence)

    fifo_transaction tr;

    function new(string name = "fifo_coverage_sequence");
        super.new(name);
        tr = fifo_transaction::type_id::create("tr");
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Starting 16 writes, read all, repeat 4 times FIFO sequence", UVM_LOW)
        for (int i = 0; i < 40; i++) begin
            for (int j = 0; j < 16; j++) begin
                start_item(tr);
                  if (!(tr.randomize() with { operation inside {WRITE}  ;
                                              data      inside {[0:255]};}))
                  `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
                finish_item(tr);
            end

            for (int j = 0; j < 16; j++) begin
                start_item(tr);
                if (!(tr.randomize() with { operation inside {READ};}))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
                finish_item(tr);
            end
        end
        `uvm_info(get_type_name(), "Finished 16 writes, read all, repeat 4 times FIFO sequence", UVM_LOW)
    endtask
endclass : fifo_coverage_sequence

class write_all_sequence extends fifo_base_sequence;
    `uvm_object_utils(write_all_sequence)

    fifo_transaction tr;

    function new(string name = "write_all_sequence");
        super.new(name);
        // Create a new transaction
        tr = fifo_transaction::type_id::create("tr");
    endfunction : new

    virtual task body();
        // Start the transaction and configure it for a write operation
        for (int i = 1; i <= 16; i++) begin
            start_item(tr);
              if (!(tr.randomize() with { operation inside {WRITE};
                                          data      == i * 2      ;
                                          delay_rd  == 1          ;
                                          delay_wr  == 2          ;}))
              `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end
    endtask : body
endclass

class read_all_sequence extends fifo_base_sequence;
    `uvm_object_utils(read_all_sequence)

    fifo_transaction tr;
    function new(string name = "read_all_sequence");
        super.new(name);
        // Create a new transaction
        tr = fifo_transaction::type_id::create("tr");
    endfunction : new

    virtual task body();
        // Start the transaction and configure it for a read operation
        for (int i = 0; i < 16; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {READ};
                                        delay_rd  == 1         ;
                                        delay_wr  == 2         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end
    endtask : body
endclass

class repeated_write_read_sequence extends fifo_base_sequence;
    `uvm_object_utils(repeated_write_read_sequence)
    fifo_transaction tr;

    function new(string name = "repeated_write_read_sequence");
        super.new(name);
        // Create a new transaction
        tr = fifo_transaction::type_id::create("tr");
    endfunction : new

    virtual task body();
        // Write all 16 data items to the FIFO
        for (int i = 0; i < 16; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {WRITE};
                                        delay_rd  == 2         ;
                                        delay_wr  == 1         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end

        // Read all 16 data items from the FIFO
        for (int i = 0; i < 16; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {READ};
                                        delay_rd  == 1         ;
                                        delay_wr  == 2         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end

        // Write all 16 data items to the FIFO again
        for (int i = 0; i < 16; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {WRITE};
                                        delay_rd  == 2         ;
                                        delay_wr  == 1         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end

        // Read all 16 data items from the FIFO again
        for (int i = 0; i < 16; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {READ};
                                        delay_rd  == 1         ;
                                        delay_wr  == 2         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end
    endtask : body

endclass

class complex_operation_sequence extends fifo_base_sequence;
    `uvm_object_utils(complex_operation_sequence)
    fifo_transaction tr;

    function new(string name = "complex_operation_sequence");
        super.new(name);
        // Create a new transaction
        tr = fifo_transaction::type_id::create("tr");
    endfunction : new

    virtual task body();
        // First 5 write operations with random data between 0 and 255
        for (int i = 0; i < 5; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {WRITE};
                                        data inside {[0:255]};
                                        delay_rd  == 2         ;
                                        delay_wr  == 1         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end

        // Second 5 write operations with random data between 0 and 255
        for (int i = 0; i < 5; i++) begin
            start_item(tr);
            if (!(tr.randomize() with { operation inside {WRITE};
                                        data inside {[0:255]};
                                        delay_rd  == 2         ;
                                        delay_wr  == 1         ;
                }))
                `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
            finish_item(tr);
        end

        // One read operation
        start_item(tr);
        if (!(tr.randomize() with { operation inside {READ};
                                    delay_rd  == 1         ;
                                    delay_wr  == 2         ;
            }))
            `uvm_error(get_type_name(), "Randomization failed for fifo_transaction")
        finish_item(tr);
    endtask : body
endclass








