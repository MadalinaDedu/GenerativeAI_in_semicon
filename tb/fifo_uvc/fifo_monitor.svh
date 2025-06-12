//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_monitor.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Responsible for capturing signal activity from the design interface and translating
//                        it into transaction-level data objects that can be sent to other components (e.g., scoreboard).
//  ======================================================================================================

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor) // Register the component with UVM

    // Virtual interface to the FIFO module
    virtual fifo_if vif; // Interface for connecting to the FIFO design under test (DUT)
    fifo_transaction tr; // Transaction object to capture and store transaction-level data
    bit [3:0] delay_counter_rd;                            // Delay counter to count the delay read
    bit [3:0] delay_counter_wr;                            // Delay counter to count the delay write

    // Analysis port to send transactions to other components such as the scoreboard
    uvm_analysis_port#(fifo_transaction) analysis_port;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent); // Call base class constructor
    endfunction

    // Connect the virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Call base class build_phase

        // Create the analysis port to send transactions
        analysis_port = new("analysis_port", this);

        // Get the virtual interface from the UVM configuration database
        if (!uvm_config_db#(virtual fifo_if)::get(this, "*.fifo_agent_inst.*", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not defined! Simulation aborted!") // Report error and abort if interface not found
        end

        // Create a new instance of the fifo_transaction object
        tr = fifo_transaction::type_id::create("tr");
    endfunction

    // Main monitoring task
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase); // Call base class run_phase
        fork            // we use fork to run this task before the following forever begins
            delay_task(); // call the delay task
        join_none

        fork
            monitor_read(); // Fork a parallel task to monitor read operations
            monitor_write(); // Fork a parallel task to monitor write operations
        join
    endtask

    // Monitor read operations
    virtual task monitor_read();
        forever begin
            @(posedge vif.clk_rd); // Wait for a rising edge on the read clock
            if (vif.rd_en) begin // Check if read enable signal is high
                tr.rd_en = vif.rd_en; // Capture read enable status
                @(posedge vif.clk_rd); // Wait for another rising edge on the read clock
                tr.delay_rd = delay_counter_rd;
                delay_counter_rd = 0;
                // Capture read data and status signals
                tr.data = vif.data_out; // Read data output from FIFO
                tr.operation = READ; // Set operation type to READ
                tr.wr_en = vif.wr_en; // Capture write enable status
                tr.full = vif.full; // Capture FIFO full status
                tr.empty = vif.empty; // Capture FIFO empty status
                // Send captured transaction to analysis port
                analysis_port.write(tr);
            end
        end
    endtask

    // Monitor write operations
virtual task monitor_write();
        forever begin
            @(posedge vif.clk_wr);
            if (vif.wr_en) begin
                tr.data = vif.data_in;
                tr.operation = "WRITE";
                tr.rd_en = vif.rd_en;
                tr.wr_en = vif.wr_en;
                tr.full = vif.full;
                tr.empty = vif.empty;
                tr.delay_wr = delay_counter_wr; // Send the delay counter to the transaction
                delay_counter_wr = 0; // Reset the delay counter
                `uvm_info(get_type_name(), $sformatf("Write data: %0h, rd_en: %0b, wr_en: %0b, full: %0b, empty: %0b, delay_wr: %0d, operation monitor %s", tr.data, tr.rd_en, tr.wr_en, tr.full, tr.empty, tr.delay_wr, tr.operation), UVM_LOW)
                analysis_port.write(tr);
            end
        end
    endtask

// -------------------------- Delay task ( to count the delays ) --------------
    task delay_task();
      forever begin
        @ (vif.cb_mon) if (vif.cb_mon.rd_en == 0)
        delay_counter_rd = delay_counter_rd + 1;
        @ (vif.cb_mon) if (vif.cb_mon.wr_en == 0)
        delay_counter_wr = delay_counter_wr + 1;
      end
    endtask :delay_task

endclass
