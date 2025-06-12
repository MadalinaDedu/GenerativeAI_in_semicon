//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : tb_fifo.sv
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         :   All verification components, interfaces and DUT are instantiated in a top level module called testbench.
//  ======================================================================================================

module tb_fifo;
    // Import packages and UVM macros
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import fifo_pkg::*;
    import tb_pkg::*;
    import reset_pkg::*;
    import test_pkg::*;

    // Clocks, reset, and interface signals
    bit clk_wr, clk_rd, rst;
    bit [7:0] data_in;
    bit wr_en, rd_en;
    bit [7:0] data_out;
    bit full, empty;
    parameter DATA_WIDTH = 8, ADDR_WIDTH = 4;

    // Instantiate the virtual interface
    fifo_if vif( .clk_wr(clk_wr),
                 .clk_rd(clk_rd),
                 .rst(rst));
    reset_interface rvif (.clk(clk_wr));

    // Instantiate the DUT
    dual_clock_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .wr_clk  (clk_wr),
        .rd_clk  (clk_rd),
        .reset   (rst),
        .data_in (data_in),
        .wr_en   (wr_en),
        .rd_en   (rd_en),
        .data_out(data_out),
        .full    (full),
        .empty   (empty)
    );

    // Connect with interface
    // DUT -> vif
    assign vif.data_out = data_out;
    assign vif.full = full;
    assign vif.empty = empty;

    // vif -> DUT
    assign data_in = vif.data_in;
    assign wr_en = vif.wr_en;
    assign rd_en = vif.rd_en;
    assign rst = rvif.reset;

    // Clock generation
    initial begin
        clk_wr = 0;
        forever #5 clk_wr = ~clk_wr; // Adjust the clock period as needed
    end

    initial begin
        clk_rd = 0;
        forever #10 clk_rd = ~clk_rd; // Adjust the clock period as needed
    end


    // Connect the virtual interface to the UVM testbench
    initial begin
        uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*.fifo_agent_inst.*", "vif", vif);
        uvm_config_db#(virtual reset_interface)::set(uvm_root::get(), "*.reset_agent_inst.*", "vif", rvif);

        // Uncomment the desired test to run
        // run_test("first_success_test");                                         // 1 write test
        // run_test("write_read_test");                                            // write 16 values incremented by 1 and read them
        // run_test("fifo_random_operation_test");                                 // make 10 random operation read and write - maybe ILLEGAL TEST if it's reads when is empty SOMETHING IS WRONG ?????
        // run_test("fifo_100_writes_and_reads_test");                             // The test will perfrom 100 write and after that all reads (but we accept just 17)
        // run_test("fifo_4_writes_in_each_range_and_read_all_test");              // Perform 4 write in different 4 intervals ranges and reads them
        // run_test("fifo_16_writes_read_all_repeat_4_times_test");                // The test will perform 16 writes and after, read all ( 4 times )
        // run_test("simultaneous_read_write_test");                               // The test will perform simultaneous read and write
        // run_test("write_two_reads_test");                                       // The test should rise an error because after a first read, the data must be 0.
        // run_test("fifo_simultaneous_write_read_reset_write_read");              // The test will do a simultaneous write-read, the reset and after that, a write and read
        // run_test("write_reset_write_read_test");                                // The test will perform a write, reset and after reset a new read-write operation
        // run_test("two_repeated_write_read_two_reset_test");                     // The test will perform two write-read operation followed by two resets
        // run_test("complex_operation_test");                                     // The test will do 5 writes, after that, 2 resets consecutive and after, a 5 writes and 5 reads
        // run_test("fifo_stress_test");                                           // This test is based on the previews tests and it is created for stressing the DUT with multiple operatoins ( read / write / reset / read in range / simultaneous read write / and so on )
        run_test("write_read_x8");                                           // This test is based on the previews tests and it is created for stressing the DUT with multiple operatoins ( read / write / reset / read in range / simultaneous read write / and so on )
    end
endmodule

