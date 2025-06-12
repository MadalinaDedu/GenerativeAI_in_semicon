//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_monitor.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Is responsible for capturing signal activity from the design interface and translate it into transaction level data objects that can be sent to other components.
//  ======================================================================================================

class reset_monitor extends uvm_monitor;
    `uvm_component_utils(reset_monitor)

    virtual reset_interface vif;
    reset_item tr;

    uvm_analysis_port #(reset_item) ap;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual reset_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted.")
    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
        forever begin
            tr = reset_item::type_id::create("tr");
            tr.reset_signal = vif.reset;
            ap.write(tr);
            #1;
        end
    endtask
endclass

