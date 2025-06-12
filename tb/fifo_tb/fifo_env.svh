//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_env.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :
//  ======================================================================================================

`include "uvm_macros.svh"
import uvm_pkg::*;
import reset_pkg::*;

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    // Sub-components of the environment
    fifo_agent      fifo_agent_inst ;
    reset_agent     reset_agent_inst;
    fifo_scoreboard scoreboard      ; // Changed to fifo_imp
    fifo_coverage   coverage_inst   ; // Coverage collector

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Instantiate sub-components
        fifo_agent_inst  = fifo_agent::type_id::create("fifo_agent_inst",   this);
        reset_agent_inst = reset_agent::type_id::create("reset_agent_inst", this);
        scoreboard       = fifo_scoreboard::type_id::create("scoreboard",   this); // Instantiate scoreboard
        coverage_inst    = fifo_coverage::type_id::create("coverage_inst",  this); // Instantiate coverage collector
    endfunction

    // Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect agent's analysis port to the scoreboard and coverage collector
        fifo_agent_inst.monitor.analysis_port.connect(scoreboard.fifo_imp); // Changed to fifo_imp
        fifo_agent_inst.monitor.analysis_port.connect(coverage_inst.analysis_export);
        reset_agent_inst.mon.ap.connect(scoreboard.reset_imp);

    endfunction
endclass

