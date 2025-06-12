
class fifo_coverage extends uvm_subscriber #(fifo_item);

  // Registration with factory
  `uvm_component_utils(fifo_coverage)

  // Reference to the transaction item
  fifo_item item;

  // Covergroups
  covergroup fifo_cg;
    // Write enable coverage
    cp_wr_en: coverpoint item.wr_en {
      bins wr_en_0 = {0};
      bins wr_en_1 = {1};
    }

    // Read enable coverage
    cp_rd_en: coverpoint item.rd_en {
      bins rd_en_0 = {0};
      bins rd_en_1 = {1};
    }

    // Full signal coverage
    cp_full: coverpoint item.full {
      bins full_0 = {0};
      bins full_1 = {1};
    }

    // Empty signal coverage
    cp_empty: coverpoint item.empty {
      bins empty_0 = {0};
      bins empty_1 = {1};
    }

    // Data coverage - assuming data is 8 bits wide, adjust as needed
    cp_data: coverpoint item.data {
      bins bin0 [7] = {[0   : 31]};  // 0 - 31
      bins bin1 [7] = {[32  : 63]};  // 32 - 63
      bins bin2 [7] = {[64  : 95]};  // 64 - 95
      bins bin3 [7] = {[96  : 127]}; // 96 - 127
      bins bin4 [7] = {[128 : 159]}; // 128 - 159
      bins bin5 [7] = {[160 : 191]}; // 160 - 191
      bins bin6 [7] = {[192 : 223]}; // 192 - 223
      bins bin7 [7] = {[224 : 255]}; // 224 - 255
    }

    // Cross coverage between read and write enables
    // cross_cov: cross cp_rd_en, cp_wr_en {
    //   // Specific bins for important combinations
    //   bins rd_0_wr_1 = binsof(cp_rd_en.rd_en_0) && binsof(cp_wr_en.wr_en_1);
    //   bins rd_1_wr_0 = binsof(cp_rd_en.rd_en_1) && binsof(cp_wr_en.wr_en_0);

    //   // Ignore the rd_1 and wr_1 combination
    //   ignore_bins rd_1_wr_1 = binsof(cp_rd_en.rd_en_1) && binsof(cp_wr_en.wr_en_1);

    //   // You can also ignore the rd_0 and wr_0 combination if needed
    //   ignore_bins rd_0_wr_0 = binsof(cp_rd_en.rd_en_0) && binsof(cp_wr_en.wr_en_0);
    // }

          // Cross coverage between read and write enables
    cross_cov: cross cp_rd_en, cp_wr_en {
      // Specific bins for important combinations
      bins rd_0_wr_1 = binsof(cp_rd_en.rd_en_0) && binsof(cp_wr_en.wr_en_1);
      bins rd_1_wr_0 = binsof(cp_rd_en.rd_en_1) && binsof(cp_wr_en.wr_en_0);
      bins rd_1_wr_1 = binsof(cp_rd_en.rd_en_1) && binsof(cp_wr_en.wr_en_1);
    }

  endgroup

  // Constructor
  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    item = new();
    fifo_cg = new();
  endfunction

  // Write function - samples coverage when a new transaction arrives
  virtual function void write(fifo_item t);
    item = t;
    fifo_cg.sample();

    // Optional: Log coverage information
    `uvm_info(get_type_name(), $sformatf("Coverage sampled for transaction: wr_en=%0d, rd_en=%0d, full=%0d, empty=%0d, data=0x%0h",
              t.wr_en, t.rd_en, t.full, t.empty, t.data), UVM_LOW)

    // Check for protocol violations
    if (t.rd_en && t.empty)
      `uvm_warning(get_type_name(), "Protocol violation: Attempting to read when FIFO is empty")

    if (t.wr_en && t.full)
      `uvm_warning(get_type_name(), "Protocol violation: Attempting to write when FIFO is full")
  endfunction

  // Report phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("FIFO Coverage Report: Coverage = %.2f%%", fifo_cg.get_coverage()), UVM_LOW)

    // You can add more detailed coverage reporting here
    `uvm_info(get_type_name(), $sformatf("Write enable coverage = %.2f%%", fifo_cg.cp_wr_en.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Read enable coverage = %.2f%%", fifo_cg.cp_rd_en.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Full signal coverage = %.2f%%", fifo_cg.cp_full.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Empty signal coverage = %.2f%%", fifo_cg.cp_empty.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Data coverage = %.2f%%", fifo_cg.cp_data.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Cross coverage = %.2f%%", fifo_cg.cross_cov.get_coverage()), UVM_LOW)
  endfunction

endclass