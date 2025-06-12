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
//  Description         : All verification components, interfaces, and DUT are instantiated in a top-level module called testbench.
//  ======================================================================================================

module tb_fifo;
    // Import packages and UVM macros
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import fifo_pkg::*;
    import tb_pkg::*;
    import reset_pkg::*;
    import test_pkg::*;

    // Clock, reset, and interface signals
    bit clk_wr, clk_rd, rst;
    bit [7:0] data_in;
    bit wr_en, rd_en;
    bit [7:0] data_out;
    bit full, empty;

    // Instantiate the virtual interface for FIFO
    fifo_if vif( .clk_wr(clk_wr),
                 .clk_rd(clk_rd),
                 .rst(rst));

    // Instantiate the virtual interface for reset
    reset_interface rvif (.clk(clk_wr));

    // Instantiate the DUT (Device Under Test)
    dual_clock_fifo dut (
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

    // Connect DUT outputs to the virtual interface
    assign vif.data_out = data_out;
    assign vif.full = full;
    assign vif.empty = empty;

    // Connect virtual interface outputs to the DUT inputs
    assign data_in = vif.data_in;
    assign wr_en = vif.wr_en;
    assign rd_en = vif.rd_en;
    assign rst = rvif.reset;

    // Generate the write clock signal
    initial begin
        clk_wr = 0;
        forever #5 clk_wr = ~clk_wr; // Clock period: 10 time units
    end

    // Generate the read clock signal
    initial begin
        clk_rd = 0;
        forever #10 clk_rd = ~clk_rd; // Clock period: 20 time units
    end

    // Connect the virtual interface to the UVM testbench
    initial begin
        // Set virtual interface for FIFO agent
        uvm_config_db#(virtual fifo_if)::set(uvm_root::get(), "*.fifo_agent_inst.*", "vif", vif);
        // Set virtual interface for reset agent
        uvm_config_db#(virtual reset_interface)::set(uvm_root::get(), "*.reset_agent_inst.*", "vif", rvif);

        // Uncomment the desired test to run
        // run_test("write_read_test");                                                         // write 16 values incremented by 2 and read them                                                    - test passed
        // run_test("random_data_test");                                                        // perform 2 of writes and 2 reads, write 10 random data                                             - test passed
        // run_test("random_operation_property_test");                                          // perform random read or write sequences                                                            - test passed
        // run_test("test_writes_in_ranges");                                                   // split data in 4 intervals and write 4 values from each and reads all                              - test passed
        // run_test("write_16_random_data_read_test");                                          // perfrom 100 write and after that all reads (but we accept just 17)                                - test passed
        // run_test("repeated_write_read_reset_test");                                          // do 16 writes and 16 reads ( after 600ns, reset) and after that do the same sequence another time  - test passed
        // run_test("two_repeated_write_read_two_reset_test");                                  // do two series of 16 writes and 16 reads and between both writes, do reset                         - test passed
        run_test("simultaneous_read_write_test");                                            // do simultaneous write read with a small delay                                                     - test passed
        // run_test("simultaneous_read_write_reset_simultaneous_write_again_write_read_test");  //simultaneous read write reset simultaneous write again 16x write, 16x read             - test passed
        // run_test("write_read_read_test");                                                    // do one write two reads ( to see if the second read happened. Should not)                          - test passed
        // run_test("write_read_x8");                                                           // do 8 random writes and 8 reads                                                                    - test passed
        // run_test("complex_operation_test");                                                  // do 5 writes, after that, 2 resets consecutive and after, a 5 writes and 5 reads                   - test passed
        // run_test("fifo_stress_test");

    end
endmodule
