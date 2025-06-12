//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_coverage.svh
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Defines a coverage collector for FIFO transactions. It monitors various aspects of
//                        FIFO transactions such as data coverage, write/read enable coverage, FIFO full/empty coverage,
//                        and cross-coverage between read and write enables.
//  ======================================================================================================

class fifo_coverage extends uvm_subscriber #(fifo_transaction);

  `uvm_component_utils(fifo_coverage) // Macro to register this component with UVM

  fifo_transaction cov_itm; // Transaction item used to store the current transaction for coverage

  // Covergroup to measure coverage of data values
  covergroup data_cg;
    data_cov: coverpoint cov_itm.data {
      // Define bins for different ranges of data values
      bins bin0 [10] = {[0   : 31]};  // 0 - 31
      bins bin1 [10] = {[32  : 63]};  // 32 - 63
      bins bin2 [10] = {[64  : 95]};  // 64 - 95
      bins bin3 [10] = {[96  : 127]}; // 96 - 127
      bins bin4 [10] = {[128 : 159]}; // 128 - 159
      bins bin5 [10] = {[160 : 191]}; // 160 - 191
      bins bin6 [10] = {[192 : 223]}; // 192 - 223
      bins bin7 [10] = {[224 : 255]}; // 224 - 255
    }
  endgroup

  // Covergroup to measure coverage of write enable signal
  covergroup cg_wr_en;
    wr_en_cov: coverpoint cov_itm.wr_en {
      bins wr_en_0 = {0}; // Bin for write enable = 0
      bins wr_en_1 = {1}; // Bin for write enable = 1
    }
  endgroup

  // Covergroup to measure coverage of read enable signal
  covergroup cg_rd_en;
    rd_en_cov: coverpoint cov_itm.rd_en {
      bins rd_en_0 = {0}; // Bin for read enable = 0
      bins rd_en_1 = {1}; // Bin for read enable = 1
    }
  endgroup

  // Covergroup to measure coverage of FIFO full status
  covergroup cg_full;
    full_cov: coverpoint cov_itm.full {
      bins full_0 = {0}; // Bin for FIFO full = 0
      bins full_1 = {1}; // Bin for FIFO full = 1
    }
  endgroup

  // Covergroup to measure coverage of FIFO empty status
  covergroup cg_empty;
    empty_cov: coverpoint cov_itm.empty {
      bins empty_0 = {0}; // Bin for FIFO empty = 0
      bins empty_1 = {1}; // Bin for FIFO empty = 1
    }
  endgroup

  // Covergroup to measure cross-coverage between read enable and write enable signals
  covergroup cg_rd_wr_cross;
    cross_cov: cross cov_itm.rd_en, cov_itm.wr_en; // Cross coverage between read and write enables
  endgroup

  // Constructor
  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent); // Call base class constructor
    // Instantiate covergroups
    data_cg        = new;
    cg_wr_en       = new;
    cg_rd_en       = new;
    cg_full        = new;
    cg_empty       = new;
    cg_rd_wr_cross = new;
  endfunction

  // Write function to sample coverage data
  virtual function void write(fifo_transaction t);
    cov_itm = t; // Assign the current transaction to cov_itm
    data_cg.sample();        // Sample data coverage
    cg_wr_en.sample();       // Sample write enable coverage
    cg_rd_en.sample();       // Sample read enable coverage
    cg_full.sample();        // Sample FIFO full coverage
    cg_empty.sample();       // Sample FIFO empty coverage
    cg_rd_wr_cross.sample(); // Sample read/write cross coverage
  endfunction

  // Report phase function to log coverage results
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase); // Call base class report_phase
    // Report coverage statistics
    uvm_report_info("REPORT_PHASE", $sformatf("Data coverage: %0.2f%%", data_cg.get_coverage()), UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("WR_EN coverage: %0.2f%%", cg_wr_en.get_coverage()), UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("RD_EN coverage: %0.2f%%", cg_rd_en.get_coverage()), UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("Full coverage: %0.2f%%", cg_full.get_coverage()), UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("Empty coverage: %0.2f%%", cg_empty.get_coverage()), UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("RD_WR Cross coverage: %0.2f%%", cg_rd_wr_cross.get_coverage()), UVM_LOW);
  endfunction
endclass
