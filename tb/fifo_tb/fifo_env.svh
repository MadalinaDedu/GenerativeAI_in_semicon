
// `include "uvm_macros.svh"
// import uvm_pkg::*;
// import reset_pkg::*;

class fifo_env extends uvm_env;

  // Factory registration
  `uvm_component_utils(fifo_env)

  // Components of the environment
  fifo_agent      m_fifo_agent ;
  reset_agent     m_reset_agent;
  fifo_scoreboard m_scoreboard ;
  fifo_coverage m_coverage;


  // Constructor
  function new(string name = "fifo_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create components
    m_fifo_agent  = fifo_agent::type_id::create("m_fifo_agent", this)     ;
    m_reset_agent = reset_agent::type_id::create("m_reset_agent", this)   ;
    m_scoreboard  = fifo_scoreboard::type_id::create("m_scoreboard", this);
    m_coverage    = fifo_coverage::type_id::create("m_coverage", this)    ;

  endfunction : build_phase

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);


    m_fifo_agent.monitor.item_collected_port.connect(m_coverage.analysis_export); // Connect the FIFO agent's monitor to the coverage
    m_fifo_agent.monitor.item_collected_port.connect(m_scoreboard.fifo_imp)            ; // Connect the FIFO agent's monitor to the scoreboard
    m_reset_agent.monitor.analysis_port.connect(m_scoreboard.reset_imp)                ; // Connect the reset agent's monitor to the scoreboard

  endfunction : connect_phase
endclass : fifo_env
