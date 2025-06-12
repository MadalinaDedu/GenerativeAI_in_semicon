//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei (FVA)
//  Date                  : 31/05/2024
//  File name             : fifo_test.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA)
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : It is a pattern to check and verify specific features and functionalities of a design.
//                        A verification plan lists all the features and other functional items that need to be verified, and the tests needed to cover each of them.
//  ======================================================================================================

import fifo_pkg::*;

//-------------------------------Fifo Base Test ------------------------------------------------
// Define the base class for FIFO tests
class fifo_base_test extends uvm_test;

    // Register the fifo_base_test class with the UVM factory
    `uvm_component_utils(fifo_base_test)

    // Constructor for the fifo_base_test class
    function new(string name = "fifo_base_test", uvm_component parent = null);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Declare the environment variable
    fifo_env m_env; // Changed data type to fifo_env

    // Build phase to create the environment
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = fifo_env::type_id::create("m_env", this); // Create the environment
    endfunction

    // Connect phase for connecting components
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Code for connecting analysis ports can be added here
    endfunction : connect_phase

    // End of elaboration phase to print the UVM topology
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction
endclass : fifo_base_test;

//-------------------------------Incremental Write Test-----------------------------------------
// Define the class for write/read test
class write_read_test extends fifo_base_test;
    // Register the write_read_test class with the UVM factory
    `uvm_component_utils(write_read_test)

    // Constructor for the write_read_test class
    function new(string name = "write_read_test", uvm_component parent = null);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Task to run the test
    virtual task run_phase(uvm_phase phase);
        // Declare the sequence variables
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        fifo_write_sequence    write_seq = fifo_write_sequence::type_id::create("write_seq");
        fifo_read_sequence     read_seq = fifo_read_sequence::type_id::create("read_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        phase.raise_objection(this); // Raise objection to keep the simulation running

        // Start the reset sequence
        rst.start(m_env.reset_agent_inst.seqr);
        // Start the write and read sequences concurrently
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);

        // Print an info message
        `uvm_info(get_type_name(), "Write and read sequences started", UVM_NONE)
        phase.drop_objection(this); // Drop objection to end the simulation
    endtask
endclass : write_read_test

//-------------------------------Read Test-----------------------------------------------------
// Define the class for single read test
class single_read_test extends fifo_base_test;
    // Register the single_read_test class with the UVM factory
    `uvm_component_utils(single_read_test)

    // Constructor for the single_read_test class
    function new(string name = "single_read_test", uvm_component parent = null);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Task to run the test
    virtual task run_phase(uvm_phase phase);
        // Declare the sequence variables
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        fifo_read_sequence read_seq = fifo_read_sequence::type_id::create("read_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        phase.raise_objection(this); // Raise objection to keep the simulation running

        // Start the reset sequence
        rst.start(m_env.reset_agent_inst.seqr);
        // Start the read sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);

        // Print an info message
        `uvm_info(get_type_name(), "Single read sequence started", UVM_NONE)
        phase.drop_objection(this); // Drop objection to end the simulation
    endtask
endclass : single_read_test

//-------------------------------Random Operation Test------------------------------------------
// Define the class for random operation test
class random_data_test extends fifo_base_test;
    // Register the random_data_test class with the UVM factory
    `uvm_component_utils(random_data_test)

    // Constructor for the random_data_test class
    function new(string name = "random_data_test", uvm_component parent = null);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Task to run the test
    virtual task run_phase(uvm_phase phase);
        // Declare the sequence variables
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        random_write_sequence write_seq = random_write_sequence::type_id::create("write_seq");
        fifo_read_sequence read_seq = fifo_read_sequence::type_id::create("read_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        phase.raise_objection(this); // Raise objection to keep the simulation running

        // Start the reset sequence
        rst.start(m_env.reset_agent_inst.seqr);
        repeat(5) begin
            // Start random write sequence
            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
          
            // Start read sequence
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        end

        phase.drop_objection(this); // Drop objection to end the simulation
    endtask
endclass : random_data_test

//-------------------------------Overflow Test--------------------------------------------------
// Define the class for overflow test
class overflow_test extends fifo_base_test;
    // Register the overflow_test class with the UVM factory
    `uvm_component_utils(overflow_test)

    // Constructor for the overflow_test class
    function new(string name = "overflow_test", uvm_component parent = null);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Task to run the test
    virtual task run_phase(uvm_phase phase);
        // Declare the sequence variables
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        fifo_write_sequence write_seq = fifo_write_sequence::type_id::create("write_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        phase.raise_objection(this); // Raise objection to keep the simulation running

        // Start the reset sequence
        rst.start(m_env.reset_agent_inst.seqr);
        // Start the write sequence to fill and overflow the FIFO
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);

        // Additional checks for FIFO full status can be added here

        phase.drop_objection(this); // Drop objection to end the simulation
    endtask
endclass : overflow_test

//-------------------------------Simultaneous Read Write Test-----------------------------------
// Define the class for simultaneous read/write test
class simultaneous_read_write_test extends fifo_base_test;
    // Register the simultaneous_read_write_test class with the UVM factory
    `uvm_component_utils(simultaneous_read_write_test)

    // Constructor for the simultaneous_read_write_test class
    function new(string name = "simultaneous_read_write_test", uvm_component parent = null);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Task to run the test
    virtual task run_phase(uvm_phase phase);
        // Declare the sequence variables
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        fifo_write_sequence write_seq = fifo_write_sequence::type_id::create("write_seq");
        fifo_read_sequence read_seq = fifo_read_sequence::type_id::create("read_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        phase.raise_objection(this); // Raise objection to keep the simulation running

        // Start the reset sequence
        rst.start(m_env.reset_agent_inst.seqr);
        fork
            // Start the write sequence
            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
            // Start the read sequence
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        join_any
        #300
        phase.drop_objection(this); // Drop objection to end the simulation
    endtask
endclass : simultaneous_read_write_test


// Test for simultaneous read, write, then write again, and read
class simultaneous_read_write_write_again_read_test extends fifo_base_test;
    `uvm_component_utils(simultaneous_read_write_write_again_read_test)

    function new(string name = "simultaneous_read_write_write_again_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        fifo_write_sequence write_seq;
        fifo_read_sequence read_seq;
        fifo_write_sequence second_write_seq;
        fifo_read_sequence second_read_seq;

        // Create instances of the sequences to be used
        reset_sequence rst = reset_sequence::type_id::create("rst");
        write_seq = fifo_write_sequence::type_id::create("write_seq");
        read_seq = fifo_read_sequence::type_id::create("read_seq");
        second_write_seq = fifo_write_sequence::type_id::create("second_write_seq");
        second_read_seq = fifo_read_sequence::type_id::create("second_read_seq");

        phase.raise_objection(this); // Raise phase objection

        // Start the reset sequence
        rst.start(m_env.reset_agent_inst.seqr);

        fork
            // Start simultaneous write sequence
            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
            // Start simultaneous read sequence
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        join

        // Perform a second write operation
        second_write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        // Perform a second read operation
        second_read_seq.start(m_env.fifo_agent_inst.fifo_seq);

        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : simultaneous_read_write_write_again_read_test

// Test for simultaneous read, write, reset, then read and write again
class simultaneous_read_write_reset_simultaneous_write_again_write_read_test extends fifo_base_test;
    `uvm_component_utils(simultaneous_read_write_reset_simultaneous_write_again_write_read_test)

    function new(string name = "simultaneous_read_write_reset_simultaneous_write_again_write_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_write_sequence write_seq;
        fifo_read_sequence read_seq;
        fifo_write_sequence second_write_seq;
        fifo_read_sequence second_read_seq;
        reset_sequence rst = reset_sequence::type_id::create("rst");

        // Create instances of the sequences to be used
        write_seq = fifo_write_sequence::type_id::create("write_seq");
        read_seq = fifo_read_sequence::type_id::create("read_seq");
        second_write_seq = fifo_write_sequence::type_id::create("second_write_seq");
        second_read_seq = fifo_read_sequence::type_id::create("second_read_seq");

        phase.raise_objection(this); // Raise phase objection

        // Start the initial reset sequence
        rst.start(m_env.reset_agent_inst.seqr);
        `uvm_info(get_type_name(), "Initial reset sequence started", UVM_NONE)

        fork
            // Start simultaneous write sequence
            begin
                write_seq.start(m_env.fifo_agent_inst.fifo_seq);
                `uvm_info(get_type_name(), "Write sequence started", UVM_NONE)
            end
            // Start simultaneous read sequence
            begin
                read_seq.start(m_env.fifo_agent_inst.fifo_seq);
                `uvm_info(get_type_name(), "Read sequence started", UVM_NONE)
            end
            // Wait for some time and then apply the reset
            begin
                #920; // Wait for 920 time units
                rst.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Second reset sequence started after delay", UVM_NONE)
            end
        join

        // Perform a second write operation
        second_write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        `uvm_info(get_type_name(), "Second write sequence started", UVM_NONE)
        // Perform a second read operation
        second_read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        `uvm_info(get_type_name(), "Second read sequence started", UVM_NONE)

        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : simultaneous_read_write_reset_simultaneous_write_again_write_read_test

// Test for random operations and property testing
class random_operation_property_test extends fifo_base_test;
    `uvm_component_utils(random_operation_property_test)

    function new(string name = "random_operation_property_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        random_operation_sequence  rand_op_seq = random_operation_sequence::type_id::create("rand_op_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");

        phase.raise_objection(this); // Raise phase objection

        // Start the reset and random operation sequences
        rst.start(m_env.reset_agent_inst.seqr);
        rand_op_seq.start(m_env.fifo_agent_inst.fifo_seq);

        `uvm_info(get_type_name(), "Random operation sequence and property test started", UVM_NONE)
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : random_operation_property_test

// Test for 100 write operations followed by reads
class write_16_random_data_read_test extends fifo_base_test;
    `uvm_component_utils(write_16_random_data_read_test)

    function new(string name = "write_16_random_data_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        write_100_sequence    write_seq = write_100_sequence::type_id::create("write_seq");
        fifo_read_sequence    read_seq = fifo_read_sequence::type_id::create("read_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");

        phase.raise_objection(this); // Raise phase objection

        // Start the reset, 100 write, and read sequences
        rst.start(m_env.reset_agent_inst.seqr);
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);

        `uvm_info(get_type_name(), "16 writes followed by reads sequence started", UVM_NONE)
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : write_16_random_data_read_test

// Test for writing in ranges
class test_writes_in_ranges extends fifo_base_test;
    `uvm_component_utils(test_writes_in_ranges)

    function new(string name = "test_writes_in_ranges", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        writes_and_read_in_ranges_sequence seq = writes_and_read_in_ranges_sequence::type_id::create("seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");

        phase.raise_objection(this); // Raise phase objection

        // Start the reset and write in ranges sequences
        rst.start(m_env.reset_agent_inst.seqr);
        seq.start(m_env.fifo_agent_inst.fifo_seq);
        #1000ns;

        `uvm_info(get_type_name(), "Writes in ranges sequence started", UVM_NONE)
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : test_writes_in_ranges

// Test for repeated write and read operations with a reset in between
class repeated_write_read_reset_test extends fifo_base_test;
    `uvm_component_utils(repeated_write_read_reset_test)

    function new(string name = "repeated_write_read_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");
        repeated_write_read_sequence rep_wr_rd_seq = repeated_write_read_sequence::type_id::create("rep_wr_rd_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");

        phase.raise_objection(this); // Raise phase objection

        // Start the reset sequence and the repeated write-read sequence
        rst.start(m_env.reset_agent_inst.seqr);

        fork
            begin
                rep_wr_rd_seq.start(m_env.fifo_agent_inst.fifo_seq);
            end
            // Wait for some time and then apply the reset
            begin
                #600; // Wait for 600 time units
                rst.start(m_env.reset_agent_inst.seqr);
            end
        join
        #1000ns;

        // Ensure phase objection is dropped after both threads complete
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : repeated_write_read_reset_test

// Test for repeated write and read operations with two resets
class two_repeated_write_read_two_reset_test extends fifo_base_test;
    `uvm_component_utils(two_repeated_write_read_two_reset_test)

    function new(string name = "two_repeated_write_read_two_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        repeated_write_read_sequence rep_wr_rd_seq = repeated_write_read_sequence::type_id::create("rep_wr_rd_seq");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");


        phase.raise_objection(this); // Raise phase objection

        // Start the reset sequence and the repeated write-read sequence
        rst.start(m_env.reset_agent_inst.seqr);
        fork
            begin
                rep_wr_rd_seq.start(m_env.fifo_agent_inst.fifo_seq);
                `uvm_info(get_type_name(), "Repeated write and read sequence started", UVM_NONE)
            end
            // Wait for some time and then apply the reset
            begin
                #1000; // Wait for 1000 time units or any appropriate time
                rst.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Reset sequence started after delay", UVM_NONE)
            end
 
            begin
                #8000; // Wait for 1000 time units or any appropriate time
                rst.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Reset sequence started after delay", UVM_NONE)
            end
 
        join

        // Ensure phase objection is dropped after both threads complete
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : two_repeated_write_read_two_reset_test

// Test for writing, reading, and reading 17 values
class write_read_read_17values_test extends fifo_base_test;
    `uvm_component_utils(write_read_read_17values_test)

    function new(string name = "write_read_read_17values_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_read_sequence     read_seq = fifo_read_sequence::type_id::create("read_seq");
        fifo_write_sequence    write_seq = fifo_write_sequence::type_id::create("write_seq");
        fifo_read_sequence     read_seq_again = fifo_read_sequence::type_id::create("read_seq_again");
        reset_sequence rst = reset_sequence::type_id::create("rst");

        phase.raise_objection(this); // Raise phase objection

        // Start the reset sequence, write sequence, and read sequences
        rst.start(m_env.reset_agent_inst.seqr);
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        #500ns; // Adjust delay as needed between sequences
        read_seq_again.start(m_env.fifo_agent_inst.fifo_seq);

        `uvm_info(get_type_name(), "Write, Read, Read sequences started", UVM_NONE)
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : write_read_read_17values_test

// Test for writing, reading, and reading again in multiple iterations
class write_read_read_test extends fifo_base_test;
    `uvm_component_utils(write_read_read_test)

    function new(string name = "write_read_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    // Define the run phase task for the test
    virtual task run_phase(uvm_phase phase);
        fifo_single_read_sequence     read_seq;
        fifo_single_write_sequence    write_seq;
        fifo_single_read_sequence     read_seq_again;
        reset_sequence                rst;
        
    
        rst = reset_sequence::type_id::create("rst");
        write_seq = fifo_single_write_sequence::type_id::create($sformatf("write_seq"));
        read_seq = fifo_single_read_sequence::type_id::create($sformatf("read_seq_"));
        read_seq_again = fifo_single_read_sequence::type_id::create($sformatf("read_seq_again"));
        phase.raise_objection(this); // Raise phase objection

        // Start the reset sequence and perform write, read, read operations in a loop
        rst.start(m_env.reset_agent_inst.seqr);

        for (int i = 0; i < 20; i++) begin

            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
            #50ns;
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
            #50ns; // Adjust delay as needed between sequences
            read_seq_again.start(m_env.fifo_agent_inst.fifo_seq);
            #50ns; // Adjust delay as needed between sequences

            `uvm_info(get_type_name(), $sformatf("Write, Read, Read sequences iteration %0d started", i+1), UVM_NONE)
        end

        // phase.phase_done.set_drain_time(this, 5000); // Ensure proper draining time
        phase.drop_objection(this); // Drop phase objection
    endtask
endclass : write_read_read_test


class write_read_x8 extends fifo_base_test;
    `uvm_component_utils(write_read_x8) // Macro for UVM component utilities
 
    // Constructor
    function new(string name = "write_read_x8", uvm_component parent = null);
        super.new(name, parent); // Call the parent constructor
    endfunction
 
    // Run phase
    virtual task run_phase(uvm_phase phase);
        fifo_sequence fifo = fifo_sequence::type_id::create("item"); // Create FIFO sequence
        fifo_write_without_delay_sequence write_seq = fifo_write_without_delay_sequence::type_id::create("write_seq"); // Create write sequence
        read_all_sequence read_seq = read_all_sequence::type_id::create("read_seq"); // Create read sequence
        reset_sequence rst = reset_sequence::type_id::create("rst"); // Create reset sequence
        phase.raise_objection(this); // Raise objection to keep the phase alive
 
        rst.start(m_env.reset_agent_inst.seqr); // Start the reset sequence
 
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the write sequence
        read_seq.start(m_env.fifo_agent_inst.fifo_seq); // Start the read sequence
        
        `uvm_info(get_type_name(), "Write and read sequences started", UVM_NONE) // Log information
        // phase.phase_done.set_drain_time(this, 1000000);
        phase.drop_objection(this); // Drop objection to end the phase
    endtask
endclass : write_read_x8

class complex_operation_test extends fifo_base_test;
    `uvm_component_utils(complex_operation_test)
 
    function new(string name = "complex_operation_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
 
    virtual task run_phase(uvm_phase phase);
        complex_operation_sequence complex_operation_seq = complex_operation_sequence::type_id::create("complex_operation_seq");
        complex_operation_sequence complex_operation_seq2 = complex_operation_sequence::type_id::create("complex_operation_seq2");
        reset_sequence rst = reset_sequence::type_id::create("rst");
        reset_sequence rst2 = reset_sequence::type_id::create("rst");
        fifo_sequence  fifo = fifo_sequence::type_id::create("item");


        phase.raise_objection(this); // Raise phase objection

        // Start the reset sequence and the repeated write-read sequence
        rst.start(m_env.reset_agent_inst.seqr);
        fork
            begin
                complex_operation_seq.start(m_env.fifo_agent_inst.fifo_seq);
                `uvm_info(get_type_name(), "Repeated write and read sequence started", UVM_NONE)
            end
            // Wait for some time and then apply the reset
            begin
                #100ns;
                rst.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Reset sequence started after delay", UVM_NONE)
            end
 
            begin
                #120ns;
                rst2.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Reset sequence started after delay", UVM_NONE)
            end

            begin
                complex_operation_seq2.start(m_env.fifo_agent_inst.fifo_seq);
                `uvm_info(get_type_name(), "Repeated write and read sequence started", UVM_NONE)
            end
        join
        phase.drop_objection(this); // Drop objection to end the phase

    endtask
endclass : complex_operation_test


class fifo_stress_test extends fifo_base_test;
    `uvm_component_utils(fifo_stress_test)
 
    // Declare the sequence variables
    fifo_sequence seq_basic;
    fifo_write_sequence seq_write;
    fifo_read_sequence seq_read;
    fifo_single_write_sequence seq_single_write;
    fifo_single_read_sequence seq_single_read;
    random_write_sequence seq_random_write;
    random_operation_sequence seq_random_operation;
    writes_and_read_in_ranges_sequence seq_writes_and_reads;
    write_100_sequence seq_write_100;
    repeated_write_read_sequence seq_repeated_wr_rd;
    write_all_sequence seq_write_all;
    read_all_sequence seq_read_all;
    fifo_write_without_delay_sequence seq_write_no_delay;
    complex_operation_sequence seq_complex_op;
    reset_sequence rst;
    // Constructor
    function new(string name = "fifo_stress_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
 
    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
 
        // Instantiate all sequences
        rst = reset_sequence::type_id::create("rst"); // Create reset sequence
        seq_basic = fifo_sequence::type_id::create("seq_basic");
        seq_write = fifo_write_sequence::type_id::create("seq_write");
        seq_read = fifo_read_sequence::type_id::create("seq_read");
        seq_single_write = fifo_single_write_sequence::type_id::create("seq_single_write");
        seq_single_read = fifo_single_read_sequence::type_id::create("seq_single_read");
        seq_random_write = random_write_sequence::type_id::create("seq_random_write");
        seq_random_operation = random_operation_sequence::type_id::create("seq_random_operation");
        seq_writes_and_reads = writes_and_read_in_ranges_sequence::type_id::create("seq_writes_and_reads");
        seq_write_100 = write_100_sequence::type_id::create("seq_write_100");
        seq_repeated_wr_rd = repeated_write_read_sequence::type_id::create("seq_repeated_wr_rd");
        seq_write_all = write_all_sequence::type_id::create("seq_write_all");
        seq_read_all = read_all_sequence::type_id::create("seq_read_all");
        seq_write_no_delay = fifo_write_without_delay_sequence::type_id::create("seq_write_no_delay");
        seq_complex_op = complex_operation_sequence::type_id::create("seq_complex_op");
    endfunction
 
    // Run phase
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
 
        // Start all sequences
        `uvm_info(get_type_name(), "Starting all sequences for stress test", UVM_LOW)
        
        rst.start(m_env.reset_agent_inst.seqr);

        fork
        seq_basic.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write.start(m_env.fifo_agent_inst.fifo_seq);
        seq_read.start(m_env.fifo_agent_inst.fifo_seq);
        seq_single_write.start(m_env.fifo_agent_inst.fifo_seq);
        seq_single_read.start(m_env.fifo_agent_inst.fifo_seq);
        seq_random_write.start(m_env.fifo_agent_inst.fifo_seq);
        seq_random_operation.start(m_env.fifo_agent_inst.fifo_seq);
        seq_writes_and_reads.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write_100.start(m_env.fifo_agent_inst.fifo_seq);
        seq_repeated_wr_rd.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write_all.start(m_env.fifo_agent_inst.fifo_seq);
        seq_read_all.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write_no_delay.start(m_env.fifo_agent_inst.fifo_seq);
        seq_complex_op.start(m_env.fifo_agent_inst.fifo_seq);
        join

        seq_basic.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write.start(m_env.fifo_agent_inst.fifo_seq);
        seq_read.start(m_env.fifo_agent_inst.fifo_seq);
        seq_single_write.start(m_env.fifo_agent_inst.fifo_seq);
        seq_single_read.start(m_env.fifo_agent_inst.fifo_seq);
        seq_random_write.start(m_env.fifo_agent_inst.fifo_seq);
        seq_random_operation.start(m_env.fifo_agent_inst.fifo_seq);
        seq_writes_and_reads.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write_100.start(m_env.fifo_agent_inst.fifo_seq);
        seq_repeated_wr_rd.start(m_env.fifo_agent_inst.fifo_seq);
        seq_write_all.start(m_env.fifo_agent_inst.fifo_seq);
        seq_read_all.start(m_env.fifo_agent_inst.fifo_seq);
        #20ns;
        rst.start(m_env.reset_agent_inst.seqr);
        // #10ns;
        seq_write_no_delay.start(m_env.fifo_agent_inst.fifo_seq);
        seq_complex_op.start(m_env.fifo_agent_inst.fifo_seq);

        `uvm_info(get_type_name(), "Finished all sequences for stress test", UVM_LOW)
 
        phase.drop_objection(this);
    endtask
endclass