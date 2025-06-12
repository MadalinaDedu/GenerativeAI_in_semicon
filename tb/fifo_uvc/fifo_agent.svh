//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_agent.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Defines an agent that encapsulates a sequencer, driver, and monitor into a single entity. 
//                        The components are instantiated and connected together via interfaces.
//  ======================================================================================================

class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    // Constructor for the FIFO agent class
    function new(string name= "fifo_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Sub-components of the FIFO agent
    fifo_driver driver;             // Driver component
    fifo_monitor monitor;           // Monitor component
    fifo_sequencer fifo_seq;        // Sequencer component

    // Build phase for the FIFO agent
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Instantiate components if the agent is active
        if(get_is_active()) begin
              fifo_seq = fifo_sequencer::type_id::create("fifo_seq", this); // Create the sequencer
              driver  = fifo_driver::type_id::create("driver", this);       // Create the driver
        end

        // Always instantiate the monitor
        monitor = fifo_monitor::type_id::create("monitor", this); // Create the monitor
    endfunction

    // Connect phase for the FIFO agent
    virtual function void connect_phase(uvm_phase phase);

    if(get_is_active())
        driver.seq_item_port.connect(fifo_seq.seq_item_export); // Connect the driver and sequencer
    endfunction
endclass : fifo_agent