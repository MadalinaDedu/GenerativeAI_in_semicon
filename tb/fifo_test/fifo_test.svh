import fifo_pkg::*;

// Base test class
class fifo_dual_clock_base_test extends uvm_test;
  `uvm_component_utils(fifo_dual_clock_base_test)

  function new(string name = "fifo_dual_clock_base_test", uvm_component parent = null);
        super.new(name, parent);
  endfunction : new

  fifo_env env;

  virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase", UVM_LOW)
    env = fifo_env::type_id::create("env", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase", UVM_LOW)
  endfunction : connect_phase

endclass : fifo_dual_clock_base_test

// Example of a specific test case extending the base test
class fifo_dual_clock_simple_test extends fifo_dual_clock_base_test;
  `uvm_component_utils(fifo_dual_clock_simple_test)

  function new(string name = "fifo_dual_clock_simple_test", uvm_component parent = null);
        super.new(name, parent);
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    // super.run_phase(phase);

    reset_sequence      rst_seq   = reset_sequence::type_id::create("rst_seq")       ;
    fifo_write_sequence write_seq = fifo_write_sequence::type_id::create("write_seq");
    fifo_read_sequence  read_seq  = fifo_read_sequence::type_id::create("read_seq")  ;

    phase.raise_objection(this);
      `uvm_info(get_type_name(), "Running simple FIFO test", UVM_LOW)

      rst_seq.start(env.m_reset_agent.sequencer)    ; // Start the reset sequence
      repeat(20) begin
        write_seq.start(env.m_fifo_agent.sequencer) ; // Start the write sequence
        #30ns                                       ; // Wait for 200 time units
        read_seq.start(env.m_fifo_agent.sequencer)  ; // Start the read sequence
      end
      phase.phase_done.set_drain_time(this, 500ns); // Set the drain time for the phase
      `uvm_info(get_type_name(), "Sequences started", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase
endclass : fifo_dual_clock_simple_test

class fifo_write_all_read_all_test extends fifo_dual_clock_base_test;
  `uvm_component_utils(fifo_write_all_read_all_test)

  function new(string name = "fifo_write_all_read_all_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);

    fifo_write_16_sequence   write_16_seq  ;
    fifo_read_16_sequence    read_16_seq   ;
    reset_sequence           rst_seq       ;

    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting FIFO test sequences", UVM_LOW)

    rst_seq        = reset_sequence::type_id::create("rst_seq")                 ;
    write_16_seq   = fifo_write_16_sequence::type_id::create("write_16_seq")    ;
    read_16_seq    = fifo_read_16_sequence::type_id::create("read_16_seq")      ;

    rst_seq.start(env.m_reset_agent.sequencer)    ; // Start the reset sequence
    write_16_seq.start(env.m_fifo_agent.sequencer); // Run 16 write operations
    read_16_seq.start(env.m_fifo_agent.sequencer) ; // Run 16 read operations

    phase.phase_done.set_drain_time(this, 100ns);

    `uvm_info(get_type_name(), "FIFO test sequences completed", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass

class fifo_write_100_test extends fifo_dual_clock_base_test;
  `uvm_component_utils(fifo_write_100_test)

  function new(string name = "fifo_write_100_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);

    fifo_write_100_sequence  write_100_seq ;
    reset_sequence           rst_seq       ;

    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting FIFO test sequences", UVM_LOW)

    rst_seq        = reset_sequence::type_id::create("rst_seq")                 ;
    write_100_seq  = fifo_write_100_sequence::type_id::create("write_100_seq")  ;

    rst_seq.start(env.m_reset_agent.sequencer)    ; // Start the reset sequence
    write_100_seq.start(env.m_fifo_agent.sequencer); // Run 16 write operations

    phase.phase_done.set_drain_time(this, 100ns);

    `uvm_info(get_type_name(), "FIFO test sequences completed", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass

class write_read_read_test extends fifo_dual_clock_base_test;
  `uvm_component_utils(write_read_read_test)

  function new(string name = "write_read_read_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);

    reset_sequence      reset_seq;
    fifo_write_sequence write_seq;
    fifo_read_sequence  read_seq1;
    fifo_read_sequence  read_seq2;

    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting write_read_read test", UVM_LOW)
    reset_seq = reset_sequence::type_id::create("reset_seq")     ;
    write_seq = fifo_write_sequence::type_id::create("write_seq");
    read_seq1 = fifo_read_sequence::type_id::create("read_seq1") ;
    read_seq2 = fifo_read_sequence::type_id::create("read_seq2") ;

    // Start reset sequence
    `uvm_info(get_type_name(), "Starting reset sequence", UVM_LOW)
    reset_seq.start(env.m_reset_agent.sequencer);

    // Start write sequence
    `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)
    write_seq.start(env.m_fifo_agent.sequencer);

    // Start first read sequence
    `uvm_info(get_type_name(), "Starting first read sequence", UVM_LOW)
    read_seq1.start(env.m_fifo_agent.sequencer);

    // Start second read sequence
    `uvm_info(get_type_name(), "Starting second read sequence", UVM_LOW)
    read_seq2.start(env.m_fifo_agent.sequencer);

    `uvm_info(get_type_name(), "write_read_read test completed", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass

class fifo_simultaneous_wr_rd_test extends fifo_dual_clock_base_test;
  `uvm_component_utils(fifo_simultaneous_wr_rd_test)

  function new(string name = "fifo_simultaneous_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    reset_sequence         reset_seq;
    fifo_write_16_sequence write_seq;
    fifo_read_16_sequence  read_seq ;

    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting simultaneous write and read test", UVM_LOW)

    // Start reset sequence first
    `uvm_info(get_type_name(), "Starting reset sequence", UVM_LOW)
    reset_seq = reset_sequence::type_id::create("reset_seq");
    write_seq = fifo_write_16_sequence::type_id::create("write_seq");
    read_seq  = fifo_read_16_sequence::type_id::create("read_seq")  ;

    reset_seq.start(env.m_reset_agent.sequencer);

    // Start both sequences in parallel using fork-join after reset is complete
    fork
      begin
        `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)
        write_seq.start(env.m_fifo_agent.sequencer);
      end
      begin
        `uvm_info(get_type_name(), "Starting read sequence", UVM_LOW)
        read_seq.start(env.m_fifo_agent.sequencer);
      end
    join

    `uvm_info(get_type_name(), "Simultaneous write and read test completed", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass

class fifo_simultaneous_wr_wr_rd_reset_test extends fifo_dual_clock_base_test;
  `uvm_component_utils(fifo_simultaneous_wr_wr_rd_reset_test)

  function new(string name = "fifo_simultaneous_wr_wr_rd_reset_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    reset_sequence         reset_seq;
    fifo_write_16_sequence write_seq;
    fifo_write_16_sequence write_seq_2;
    fifo_read_16_sequence  read_seq ;

    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Starting simultaneous write and read test", UVM_LOW)

    // Start reset sequence first
    `uvm_info(get_type_name(), "Starting reset sequence", UVM_LOW)
    reset_seq   = reset_sequence::type_id::create("reset_seq")        ;
    write_seq   = fifo_write_16_sequence::type_id::create("write_seq");
    write_seq_2 = fifo_write_16_sequence::type_id::create("write_seq");
    read_seq    = fifo_read_16_sequence::type_id::create("read_seq")  ;

    reset_seq.start(env.m_reset_agent.sequencer);

    // Start both sequences in parallel using fork-join after reset is complete
    fork


      begin
        `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)
        write_seq.start(env.m_fifo_agent.sequencer);
      end


           begin
        `uvm_info(get_type_name(), "Starting read sequence", UVM_LOW)
        read_seq.start(env.m_fifo_agent.sequencer);
      end
    begin
        // Wait for some time before applying reset
        #320ns;

        `uvm_info(get_type_name(), "Applying reset after delay", UVM_LOW)
        reset_seq = reset_sequence::type_id::create("mid_reset_seq");
        reset_seq.start(env.m_reset_agent.sequencer);
      end

      begin
        `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)
        write_seq_2.start(env.m_fifo_agent.sequencer);
      end

    join
    // fork
    //   begin
    //     `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)
    //     write_seq.start(env.m_fifo_agent.sequencer);
    //   end
    //   begin
    //     `uvm_info(get_type_name(), "Starting read sequence", UVM_LOW)
    //     read_seq.start(env.m_fifo_agent.sequencer);
    //   end
    // join


    `uvm_info(get_type_name(), "Simultaneous write and read test completed", UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass