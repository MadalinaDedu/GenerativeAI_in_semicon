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
//  Description         :
//  ======================================================================================================

class fifo_coverage extends uvm_subscriber #(fifo_transaction);
  `uvm_component_utils(fifo_coverage)

  // Declare the virtual interface and transaction variables
  fifo_transaction tr;

  // Coverage variables
  covergroup cg_operation ;
    cp_wr_en: coverpoint tr.wr_en;
    cp_rd_en: coverpoint tr.rd_en;
  endgroup

    covergroup cg_wr_en;
    wr_en_cov: coverpoint tr.wr_en {
      bins wr_en_0 = {0}; // Bin for write enable = 0
      bins wr_en_1 = {1}; // Bin for write enable = 1
    }
  endgroup

  // Covergroup to measure coverage of read enable signal
  covergroup cg_rd_en;
    rd_en_cov: coverpoint tr.rd_en {
      bins rd_en_0 = {0}; // Bin for read enable = 0
      bins rd_en_1 = {1}; // Bin for read enable = 1
    }
  endgroup

  covergroup cg_full ;
    cp_full: coverpoint tr.full;
  endgroup

  covergroup cg_empty;
    cp_empty: coverpoint tr.empty;
  endgroup

  covergroup cg_data ;
    cp_data: coverpoint tr.data {
      bins data[] = {[0:$]}; // Cover all possible data values
    }
  endgroup

  // Covergroup to measure cross-coverage between read enable and write enable signals
  covergroup cg_rd_wr_cross;
    cross_cov: cross tr.rd_en, tr.wr_en; // Cross coverage between read and write enables
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_operation   = new();
    cg_wr_en       = new();
    cg_rd_en       = new();
    cg_full        = new();
    cg_empty       = new();
    cg_data        = new();
    cg_rd_wr_cross = new();
  endfunction

  // Write function to sample the covergroups
  virtual function void write(fifo_transaction t);
    tr = t;
    cg_operation.sample()  ;
    cg_wr_en.sample()      ;       // Sample write enable coverage
    cg_rd_en.sample()      ;       // Sample read enable coverage
    cg_full.sample()       ;
    cg_empty.sample()      ;
    cg_data.sample()       ;
    cg_rd_wr_cross.sample(); // Sample read/write cross coverage
  endfunction

  // Report phase to generate the coverage report
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    uvm_report_info("REPORT_PHASE", $sformatf("Operation coverage: %0.2f%%", cg_operation.get_coverage())    , UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("WR_EN coverage: %0.2f%%", cg_wr_en.get_coverage())            , UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("RD_EN coverage: %0.2f%%", cg_rd_en.get_coverage())            , UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("Full flag coverage: %0.2f%%", cg_full.get_coverage())         , UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("Empty flag coverage: %0.2f%%", cg_empty.get_coverage())       , UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("Data coverage: %0.2f%%", cg_data.get_coverage())              , UVM_LOW);
    uvm_report_info("REPORT_PHASE", $sformatf("RD_WR Cross coverage: %0.2f%%", cg_rd_wr_cross.get_coverage()), UVM_LOW);

  endfunction

endclass
