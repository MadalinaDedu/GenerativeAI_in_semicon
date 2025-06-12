//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei (FVA)
//  Date                  : 31/05/2024
//  File name             : fifo_env.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA)
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

import reset_pkg::*; // Import the reset package

// Define the class fifo_env extending from uvm_env
class fifo_env extends uvm_env;

    // Register the fifo_env class with the UVM factory
    `uvm_component_utils(fifo_env)

    // Sub-components of the environment
    fifo_agent      fifo_agent_inst; // Instance of FIFO agent
    reset_agent     reset_agent_inst; // Instance of reset agent
    fifo_scoreboard scoreboard; // Instance of scoreboard
    fifo_coverage   cov; // Instance of coverage
    virtual fifo_if vif; // Virtual interface for FIFO
    virtual reset_interface rvif; // Virtual interface for reset agent

    // Constructor for the fifo_env class
    function new(string name, uvm_component parent);
        super.new(name, parent); // Call the base class constructor
    endfunction

    // Build phase function for setting up the environment
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call the base class build_phase

        // Instantiate the sub-components
        fifo_agent_inst  = fifo_agent::type_id::create("fifo_agent_inst", this);
        reset_agent_inst = reset_agent::type_id::create("reset_agent_inst", this);
        scoreboard       = fifo_scoreboard::type_id::create("scoreboard", this);
        cov              = fifo_coverage::type_id::create("cov", this);
    endfunction

    // Connect phase function to connect the components
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); // Call the base class connect_phase

        // Connect agent's analysis ports to the scoreboard and coverage
        fifo_agent_inst.monitor.analysis_port.connect(scoreboard.fifo_imp);
        reset_agent_inst.mon.ap.connect(scoreboard.reset_imp);
        fifo_agent_inst.monitor.analysis_port.connect(cov.analysis_export);
    endfunction
endclass