
module fifo_tb;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import fifo_pkg::*;
  import fifo_tb_pkg::*;
  import reset_pkg::*;
  import fifo_test_pkg::*;

  // Declare all the signals
  logic wr_clk        ;
  logic rd_clk        ;
  logic reset         ;
  logic wr_en         ;
  logic rd_en         ;
  logic [7:0] data_in ;
  logic [7:0] data_out;
  logic full          ;
  logic empty         ;

  // Instantiate the interfaces
  fifo_if fifo_intf(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .reset (reset)
  );

  reset_if reset_intf(.clk(wr_clk));

  // Instantiate the DUT
  fifo_dual_clock dut (
    .wr_clk  (wr_clk)  ,
    .rd_clk  (rd_clk)  ,
    .rst_n   (reset)   ,
    .wr_en   (wr_en)   ,
    .rd_en   (rd_en)   ,
    .data_in (data_in) ,
    .data_out(data_out),
    .full    (full)    ,
    .empty   (empty)
  );

  // Assign DUT outputs to the virtual interface
  assign fifo_intf.data_out = data_out;
  assign fifo_intf.full     = full    ;
  assign fifo_intf.empty    = empty   ;

  // Assign virtual interface outputs to DUT inputs
  assign wr_en   = fifo_intf.wr_en  ;
  assign rd_en   = fifo_intf.rd_en  ;
  assign data_in = fifo_intf.data_in;
  assign reset   = reset_intf.reset ;

  // Clock generation
  initial begin
    wr_clk = 0;
    forever begin
      #5 wr_clk = ~wr_clk;  // 100 MHz
    end
  end

    initial begin
    rd_clk = 0;
    forever begin
      #10 rd_clk = ~rd_clk;  // 125 MHz
    end
  end

  // Connect the interface using uvm_config_db
  initial begin
    uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*", "vif", fifo_intf);
    uvm_config_db#(virtual reset_if)::set(uvm_root::get(), "*", "reset_vif", reset_intf);

    // Start the UVM test
    // run_test("fifo_dual_clock_simple_test");
    // run_test("fifo_write_100_test");
    run_test("fifo_simultaneous_wr_rd_test");
    // run_test("fifo_simultaneous_wr_wr_rd_reset_test");
    // run_test("write_read_read_test");
    // run_test("fifo_write_all_read_all_test");
  end

endmodule
