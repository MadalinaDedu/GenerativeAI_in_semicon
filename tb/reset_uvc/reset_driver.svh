//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : reset_driver.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : UVM driver is an active entity that has knowledge on how to drive signals to a particular interface of the design.
//  ======================================================================================================


class reset_driver extends uvm_driver #(reset_item);
    `uvm_component_utils(reset_driver)

    virtual reset_interface vif;
    reset_item tr; // Transaction handle

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual reset_interface)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Failed to get vif from uvm_config_db");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
            vif.reset = tr.reset_signal;
            seq_item_port.item_done();
        end
    endtask
endclass