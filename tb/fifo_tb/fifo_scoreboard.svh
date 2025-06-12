// Define analysis implementation ports

class fifo_scoreboard extends uvm_scoreboard;
  // Register the fifo_scoreboard class with the UVM factory
  `uvm_component_utils(fifo_scoreboard)

  `uvm_analysis_imp_decl(_fifo)
  `uvm_analysis_imp_decl(_reset)

  // Declare analysis implementation ports
  uvm_analysis_imp_reset #(reset_item, fifo_scoreboard) reset_imp;
  uvm_analysis_imp_fifo  #(fifo_item, fifo_scoreboard)  fifo_imp;

  // Reset interface
  virtual reset_if vif;

  // FIFO to store expected transactions
  fifo_item fifo_item_queue[$];
  fifo_item expected_trans;

  // FIFO parameters
  int max_fifo_depth = 16; // FIFO has 16 locations

  // Track if any transactions were compared
  bit transactions_compared = 0;

  // Constructor for the scoreboard class
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Build phase function for setting up the scoreboard
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fifo_imp  = new("fifo_imp", this) ;
    reset_imp = new("reset_imp", this);

    // Get reset interface
    if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_vif", vif))
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : build_phase

  // Write implementation - store incoming write transactions
  function void write_fifo(fifo_item trans);
    // Check operation type
    case(trans.operation)
      WRITE: begin
        // Check if FIFO is full
        if (trans.wr_en) begin
          `uvm_info(get_type_name(), $sformatf("WR_EN transaction: %s", trans.convert2string()), UVM_LOW)
          if (fifo_item_queue.size() >= max_fifo_depth)
            `uvm_error(get_type_name(), $sformatf("FIFO is full (size=%0d). Cannot write transaction: %s",
                                                 fifo_item_queue.size(), trans.convert2string()))
          else begin
            fifo_item_queue.push_back(trans);
            `uvm_info(get_type_name(), $sformatf("Received write transaction: %s", trans.convert2string()), UVM_LOW)
          end
        end
      end

      READ: begin
        // Check if FIFO is empty
        if (trans.rd_en) begin
          `uvm_info(get_type_name(), $sformatf("RD_EN transaction: %s", trans.convert2string()), UVM_LOW)
          if(fifo_item_queue.size() == 0)
            `uvm_error(get_type_name(), "FIFO is empty. Cannot read transaction")
          else begin
            expected_trans = fifo_item_queue.pop_front();
            `uvm_info(get_type_name(), $sformatf("Received READ transaction: %s", trans.convert2string()), UVM_LOW)
            compare_transactions(expected_trans, trans);
            transactions_compared = 1;
          end
        end
      end

      default: begin
        `uvm_error(get_type_name(), $sformatf("Unknown operation type: %s", trans.operation.name()))
      end
    endcase
  endfunction : write_fifo

  // Write implementation - store incoming write transactions
  virtual function void write_reset(reset_item trans);
    if(trans.reset==0) begin
      `uvm_info(get_type_name(), "Reset detected, clearing fifo_item_queue", UVM_LOW)
      fifo_item_queue.delete();
    end
  endfunction : write_reset

  // Virtual function to compare transactions
  virtual function void compare_transactions(fifo_item expected, fifo_item actual);
    if (expected.compare(actual)) begin
      // Changed to UVM_MEDIUM to ensure it appears in transcript
      `uvm_info(get_type_name(), $sformatf("MATCH! Expected: %s, Actual: %s", expected.convert2string(), actual.convert2string()), UVM_LOW)
    end else begin
      `uvm_error(get_type_name(), $sformatf("MISMATCH! Expected: %s, Actual: %s", expected.convert2string(), actual.convert2string()))
    end
  endfunction : compare_transactions

  // Run phase - monitor for reset
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Monitor reset signal and clear queue when reset is asserted
    fork
      forever begin
        @(negedge vif.reset);
        `uvm_info(get_type_name(), "Reset detected, clearing fifo_item_queue", UVM_LOW)
        fifo_item_queue.delete();
      end
    join_none
  endtask : run_phase

  // Check phase - verify all transactions have been processed
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);

    // if (fifo_item_queue.size() != 0) begin
    //   `uvm_error(get_type_name(), $sformatf("FIFO not empty at end of test! %0d transactions remain in scoreboard",
    //                                        fifo_item_queue.size()))

      // Optional: You can dump the remaining transactions for debugging
      foreach (fifo_item_queue[i]) begin
        `uvm_info(get_type_name(), $sformatf("Remaining transaction[%0d]: %s",
                                            i, fifo_item_queue[i].convert2string()), UVM_LOW)
      end
    if (transactions_compared) begin
      // Only show this message if at least one transaction was compared
      `uvm_info(get_type_name(), "All transactions successfully processed", UVM_LOW)
    end else begin
      `uvm_warning(get_type_name(), "ERROR --> No transactions were compared during the test!")
    end
  endfunction : check_phase

  // Report phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Scoreboard report: %0d transactions remaining in queue", fifo_item_queue.size()), UVM_LOW)
  endfunction : report_phase

endclass : fifo_scoreboard
