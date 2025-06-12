//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_test.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : It is a pattern to check and verify specific features and functionalities of a design.
//                        A verification plan lists all the features and other functional items that needs to be verified, and the tests neeeded to cover each of them.
//  ======================================================================================================

import fifo_pkg::*; // ADDED - import file

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    fifo_env m_env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = fifo_env::type_id::create("m_env", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction
endclass : base_test

class write_read_test extends base_test;
    `uvm_component_utils(write_read_test)

    function new(string name = "write_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        write_all_sequence write_seq = write_all_sequence::type_id::create("write_seq");
        read_all_sequence  read_seq  = read_all_sequence::type_id::create("read_seq");
        reset_sequence     rst       = reset_sequence::type_id::create("rst");

        phase.raise_objection(this);

        rst.start(m_env.reset_agent_inst.seqr);
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        #40ns;

        `uvm_info(get_type_name(), "Write and read sequences started", UVM_NONE)
        phase.drop_objection(this);
    endtask
endclass : write_read_test

class first_success_test extends base_test;
    `uvm_component_utils(first_success_test)

    function new(string name = "first_success_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
        reset_sequence reset_seq;
        write_sequence write_seq;
        reset_seq = reset_sequence::type_id::create("reset_seq");
        write_seq = write_sequence::type_id::create("write_seq");

        phase.raise_objection(this);

        // Start the reset sequence
        reset_seq.start(m_env.reset_agent_inst.seqr);
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        #40ns;

        phase.drop_objection(this);
    endtask : run_phase
endclass

class fifo_random_operation_test extends base_test;
    `uvm_component_utils(fifo_random_operation_test)

    function new(string name = "fifo_random_operation_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual task  run_phase(uvm_phase phase);

        reset_sequence reset_seq           = reset_sequence::type_id::create("reset_seq");
        fifo_random_operation_sequence seq = fifo_random_operation_sequence::type_id::create("seq");

        phase.raise_objection(this);

        reset_seq.start(m_env.reset_agent_inst.seqr);
        seq.start(m_env.fifo_agent_inst.fifo_seq);

        phase.drop_objection(this);
    endtask : run_phase
endclass

class fifo_100_writes_and_reads_test extends base_test;
    `uvm_component_utils(fifo_100_writes_and_reads_test)

    function new(string name = "fifo_100_writes_and_reads_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
        fifo_100_writes_and_reads_sequence seq;
        reset_sequence reset_seq;
        read_all_sequence read_all_seq;

        reset_seq    = reset_sequence::type_id::create("reset_seq");
        seq          = fifo_100_writes_and_reads_sequence::type_id::create("seq");
        read_all_seq = read_all_sequence::type_id::create("read_all_seq");

        phase.raise_objection(this);

        // Start the reset sequence
        reset_seq.start(m_env.reset_agent_inst.seqr);
        // Start the 100 writes and some reads sequence
        seq.start(m_env.fifo_agent_inst.fifo_seq);
        // Start the read all sequence
        read_all_seq.start(m_env.fifo_agent_inst.fifo_seq);
        #100ns;

        phase.drop_objection(this);
    endtask : run_phase
endclass

class fifo_4_writes_in_each_range_and_read_all_test extends base_test;
    `uvm_component_utils(fifo_4_writes_in_each_range_and_read_all_test)

    function new(string name = "fifo_4_writes_in_each_range_and_read_all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
        fifo_4_writes_in_each_range_and_read_all_sequence seq;
        reset_sequence reset_seq;
        read_all_sequence read_all_seq;
        seq          = fifo_4_writes_in_each_range_and_read_all_sequence::type_id::create("seq");
        reset_seq    = reset_sequence::type_id::create("reset_seq");
        read_all_seq = read_all_sequence::type_id::create("read_all_seq");

        phase.raise_objection(this);

        // Start the reset sequence
        reset_seq.start(m_env.reset_agent_inst.seqr);
        seq.start(m_env.fifo_agent_inst.fifo_seq);
        #100ns;
        read_all_seq.start(m_env.fifo_agent_inst.fifo_seq);
        #40ns;

        phase.drop_objection(this);
    endtask : run_phase
endclass

class write_read_x8 extends base_test;

    `uvm_component_utils(write_read_x8)

    function new(string name = "write_read_x8", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
        write_all_sequence  write_seq = write_all_sequence::type_id::create("write_seq");
        read_all_sequence   read_seq  = read_all_sequence::type_id::create("read_seq");
        reset_sequence      reset_seq = reset_sequence::type_id::create("reset_seq");

        // Raise objection to keep the phase alive
        phase.raise_objection(this);

        // Perform reset sequence
        reset_seq.start(m_env.reset_agent_inst.seqr);

        // Perform 8 write and read operations consecutively
        for (int i = 0; i < 8; i++) begin
            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        end

        // Drop objection to end the phase
        phase.drop_objection(this);

    endtask : run_phase

endclass : write_read_x8

class fifo_16_writes_read_all_repeat_4_times_test extends base_test;
    `uvm_component_utils(fifo_16_writes_read_all_repeat_4_times_test)

    function new(string name = "fifo_16_writes_read_all_repeat_4_times_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);

        fifo_16_writes_read_all_repeat_4_times_sequence seq         ;
        reset_sequence                                  reset_seq   ;

        reset_seq = reset_sequence::type_id::create("reset_seq");
        seq       = fifo_16_writes_read_all_repeat_4_times_sequence::type_id::create("seq");

        phase.raise_objection(this);

        // Start the reset sequence
        reset_seq.start(m_env.reset_agent_inst.seqr);

        // Start the 16 writes, read all, repeat 4 times sequence
        seq.start(m_env.fifo_agent_inst.fifo_seq);

        phase.drop_objection(this);
    endtask : run_phase
endclass : fifo_16_writes_read_all_repeat_4_times_test

class simultaneous_read_write_test extends base_test;

    `uvm_component_utils(simultaneous_read_write_test)

    function new(string name = "simultaneous_read_write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);

        write_all_sequence    write_seq = write_all_sequence::type_id::create("write_seq");
        read_all_sequence read_seq   = read_all_sequence::type_id::create("read_seq");
        reset_sequence    reset_seq = reset_sequence::type_id::create("reset_seq");

        phase.raise_objection(this);

        reset_seq.start(m_env.reset_agent_inst.seqr);
        fork

            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);


        join_any

        phase.drop_objection(this);

    endtask
endclass

class write_two_reads_test extends base_test;
    `uvm_component_utils(write_two_reads_test)

    function new(string name = "write_two_reads_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        write_all_sequence write_seq = write_all_sequence::type_id::create("write_seq");
        read_all_sequence  read_seq1 = read_all_sequence::type_id::create("read_seq1");
        read_all_sequence  read_seq2 = read_all_sequence::type_id::create("read_seq2");
        reset_sequence     reset_seq = reset_sequence::type_id::create("reset_seq");

        phase.raise_objection(this);

        reset_seq.start(m_env.reset_agent_inst.seqr);

        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq1.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq2.start(m_env.fifo_agent_inst.fifo_seq);

        phase.drop_objection(this);
    endtask
endclass : write_two_reads_test

class fifo_simultaneous_write_read_reset_write_read extends base_test;
    `uvm_component_utils(fifo_simultaneous_write_read_reset_write_read)

    function new(string name = "fifo_simultaneous_write_read_reset_write_read", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        write_all_sequence write_seq = write_all_sequence::type_id::create("write_seq");
        write_sequence     write     = write_sequence::type_id::create("write");
        read_all_sequence  read_seq1 = read_all_sequence::type_id::create("read_seq1");
        read_all_sequence  read_seq2 = read_all_sequence::type_id::create("read_seq2");
        reset_sequence     reset_seq = reset_sequence::type_id::create("reset_seq");

        phase.raise_objection(this);
        reset_seq.start(m_env.reset_agent_inst.seqr);
        // Start simultaneous write-read sequence
        write.start(m_env.fifo_agent_inst.fifo_seq);
        fork
            read_seq1.start(m_env.fifo_agent_inst.fifo_seq);
            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        join_any

        // Wait for some time (e.g., 100 ns) before reset
        #50ns;

        // Reset
        reset_seq.start(m_env.reset_agent_inst.seqr);

        // Start non-simultaneous write-read sequence
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq2.start(m_env.fifo_agent_inst.fifo_seq);

        phase.drop_objection(this);
    endtask
endclass


class two_repeated_write_read_two_reset_test extends base_test;
    `uvm_component_utils(two_repeated_write_read_two_reset_test)

    function new(string name = "two_repeated_write_read_two_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        repeated_write_read_sequence repeated_seq = repeated_write_read_sequence::type_id::create("repeated_seq");
        reset_sequence reset_seq                  = reset_sequence::type_id::create("reset_seq");

        phase.raise_objection(this);
        reset_seq.start(m_env.reset_agent_inst.seqr);
        fork
            // Start complex operation sequence
            repeated_seq.start(m_env.fifo_agent_inst.fifo_seq);

            begin
                #1220; // Wait for 1000 time units or any appropriate time
                reset_seq.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Reset sequence started after delay", UVM_NONE)
            end

            begin
                #2320; // Wait for 1000 time units or any appropriate time
                reset_seq.start(m_env.reset_agent_inst.seqr);
                `uvm_info(get_type_name(), "Reset sequence started after delay", UVM_NONE)
            end
        join

        phase.drop_objection(this);
    endtask : run_phase
endclass : two_repeated_write_read_two_reset_test

// Test class for 5 writes, 2 consecutive resets, followed by 5 writes and 5 reads
class write_reset_write_read_test extends base_test;
    `uvm_component_utils(write_reset_write_read_test)

    // Constructor
    function new(string name = "write_reset_write_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    write_all_sequence write_seq;
    read_all_sequence read_seq;
    reset_sequence reset_seq;

    // Run phase
    virtual task run_phase(uvm_phase phase);
            write_seq = write_all_sequence::type_id::create("write_seq");
            reset_seq = reset_sequence::type_id::create("reset_seq");
            read_seq  = read_all_sequence::type_id::create("read_seq");

        phase.raise_objection(this);

        reset_seq.start(m_env.reset_agent_inst.seqr);
        // 5 writes
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        // 2 consecutive resets
        reset_seq.start(m_env.reset_agent_inst.seqr);
        reset_seq.start(m_env.reset_agent_inst.seqr);
        // Another 5 writes
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        // 5 reads
        for (int i = 0; i < 5; i++) begin
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        end

        phase.drop_objection(this);
    endtask
endclass : write_reset_write_read_test


class complex_operation_test extends base_test;
    `uvm_component_utils(complex_operation_test)

    function new(string name = "complex_operation_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        complex_operation_sequence seq  = complex_operation_sequence::type_id::create("seq");
        complex_operation_sequence seq1 = complex_operation_sequence::type_id::create("seq1");
        reset_sequence reset_seq        = reset_sequence::type_id::create("reset_seq");
        reset_sequence reset_seq1       = reset_sequence::type_id::create("reset_seq1");

        phase.raise_objection(this);
        reset_seq.start(m_env.reset_agent_inst.seqr);
        fork
            // Start simultaneous write-read sequence
            seq.start(m_env.fifo_agent_inst.fifo_seq);

            // Perform 2 resets
            begin
            #100ns;
            reset_seq.start(m_env.reset_agent_inst.seqr);
            end

            begin
            #150ns;
            reset_seq1.start(m_env.reset_agent_inst.seqr);
            end
            // Start simultaneous write-read sequence again
            seq1.start(m_env.fifo_agent_inst.fifo_seq);
        join

        phase.drop_objection(this);
    endtask : run_phase
endclass : complex_operation_test


class fifo_stress_test extends base_test;
    `uvm_component_utils(fifo_stress_test)

    function new(string name = "fifo_stress_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        reset_sequence rst                                                      = reset_sequence::type_id::create("rst");
        fifo_sequence seq1                                                      = fifo_sequence::type_id::create("seq1");
        write_sequence write_seq                                                = write_sequence::type_id::create("write_seq");
        read_sequence read_seq                                                  = read_sequence::type_id::create("read_seq");
        fifo_random_operation_sequence random_op_seq                            = fifo_random_operation_sequence::type_id::create("random_op_seq");
        fifo_4_writes_in_each_range_and_read_all_sequence writes_in_range_seq   = fifo_4_writes_in_each_range_and_read_all_sequence::type_id::create("writes_in_range_seq");
        fifo_100_writes_and_reads_sequence writes_reads_seq                     = fifo_100_writes_and_reads_sequence::type_id::create("writes_reads_seq");
        fifo_16_writes_read_all_repeat_4_times_sequence writes_reads_repeat_seq = fifo_16_writes_read_all_repeat_4_times_sequence::type_id::create("writes_reads_repeat_seq");
        write_all_sequence write_all_seq                                        = write_all_sequence::type_id::create("write_all_seq");
        read_all_sequence read_all_seq                                          = read_all_sequence::type_id::create("read_all_seq");
        repeated_write_read_sequence repeated_write_read_seq                    = repeated_write_read_sequence::type_id::create("repeated_write_read_seq");
        complex_operation_sequence complex_op_seq                               = complex_operation_sequence::type_id::create("complex_op_seq");
        fifo_coverage_sequence cov_seq                                          = fifo_coverage_sequence::type_id::create("cov_seq");

        phase.raise_objection(this);
        rst.start(m_env.reset_agent_inst.seqr);
        fork

            seq1.start(m_env.fifo_agent_inst.fifo_seq);
            write_seq.start(m_env.fifo_agent_inst.fifo_seq);
            read_seq.start(m_env.fifo_agent_inst.fifo_seq);
            random_op_seq.start(m_env.fifo_agent_inst.fifo_seq);
            writes_in_range_seq.start(m_env.fifo_agent_inst.fifo_seq);
            writes_reads_seq.start(m_env.fifo_agent_inst.fifo_seq);
            writes_reads_repeat_seq.start(m_env.fifo_agent_inst.fifo_seq);
            write_all_seq.start(m_env.fifo_agent_inst.fifo_seq);
            read_all_seq.start(m_env.fifo_agent_inst.fifo_seq);
            repeated_write_read_seq.start(m_env.fifo_agent_inst.fifo_seq);
            complex_op_seq.start(m_env.fifo_agent_inst.fifo_seq);

        join

        seq1.start(m_env.fifo_agent_inst.fifo_seq);
        write_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        random_op_seq.start(m_env.fifo_agent_inst.fifo_seq);
        writes_in_range_seq.start(m_env.fifo_agent_inst.fifo_seq);
        cov_seq.start(m_env.fifo_agent_inst.fifo_seq);
        writes_reads_seq.start(m_env.fifo_agent_inst.fifo_seq);
        writes_reads_repeat_seq.start(m_env.fifo_agent_inst.fifo_seq);
        write_all_seq.start(m_env.fifo_agent_inst.fifo_seq);
        read_all_seq.start(m_env.fifo_agent_inst.fifo_seq);
        repeated_write_read_seq.start(m_env.fifo_agent_inst.fifo_seq);
        complex_op_seq.start(m_env.fifo_agent_inst.fifo_seq);
        #20ns;
        rst.start(m_env.reset_agent_inst.seqr);
        cov_seq.start(m_env.fifo_agent_inst.fifo_seq);

        phase.drop_objection(this);
    endtask : run_phase
endclass









