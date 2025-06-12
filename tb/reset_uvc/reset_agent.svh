//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_agent.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : An agent who encapsulates a Sequencer, Driver and Monitor into a single entity by instantiating and connecting the components together via interfaces.
//  ======================================================================================================

class reset_agent extends uvm_agent;

    `uvm_component_utils(reset_agent)

    reset_driver drv;
    reset_monitor mon;
    reset_sequencer seqr; // Use the reset_sequencer
    virtual reset_interface rvif;
    uvm_active_passive_enum is_active = UVM_ACTIVE;


    function new(string name = "reset_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            drv  = reset_driver::type_id::create("drv", this);
            seqr = reset_sequencer::type_id::create("seqr", this);
        end
        mon = reset_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass












