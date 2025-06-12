interface fifo_if(
    input logic wr_clk,
    input logic rd_clk,
    input logic reset
);
    // Write port signals
    logic        wr_en  ;
    logic [7:0]  data_in;
    logic        full   ;

    // Read port signals
    logic        rd_en   ;
    logic [7:0]  data_out;
    logic        empty   ;

    // Clocking block for write operations (used in driver)
    clocking wr_cb @(posedge wr_clk);
        default input #1step output #1;
        output wr_en, data_in;
        input  full;
    endclocking

    // Clocking block for read operations (used in driver)
    clocking rd_cb @(posedge rd_clk);
        default input #1step output #1;
        output rd_en;
        input  data_out, empty;
    endclocking

    // Clocking block for monitor (samples both write and read operations)
    clocking mon_cb @(posedge wr_clk or posedge rd_clk);
        default input #1step output #1;
        input wr_en, data_in, full, rd_en, data_out, empty;
    endclocking

    property no_write_when_full;
        @(posedge wr_clk) disable iff (!reset)
        full |-> !wr_en;
    endproperty

    // Assertion: Check that writes are not attempted when FIFO is full
    assert property (no_write_when_full)
    else $error("Assertion failed: Write attempted when FIFO is full");



    // Property: Cannot read when FIFO is empty
    property no_read_when_empty;
        @(posedge rd_clk) disable iff (!reset)
        empty |->  !rd_en;
    endproperty

    // Assertion: Check that reads are not attempted when FIFO is empty
    assert property (no_read_when_empty)
    else $error("Assertion failed: Read attempted when FIFO is empty");


    // Property: FIFO should not be both full and empty simultaneously
    property not_full_and_empty;
        @(posedge wr_clk) disable iff (!reset)
        !(full && empty);
    endproperty

    // Assertion: Check that FIFO is never both full and empty
    assert property (not_full_and_empty)
    else $error("Assertion failed: FIFO is both full and empty");

    // Property: Data input should remain stable throughout a write operation
    property data_in_stable_during_write;
        @(posedge wr_clk) disable iff (!reset)
        wr_en  |=> $stable(data_in) ;
    endproperty

    // Assertion: Check that data_in remains stable during write operation
    assert property (data_in_stable_during_write)
    else $error("Assertion failed: data_in changed during active write operation");

    // Property: Data input should remain stable when FIFO is full and write is attempted
    property data_in_stable_when_full;
        @(posedge wr_clk) disable iff (!reset)
        wr_en && full |-> $stable(data_in);
    endproperty

    // Assertion: Check that data_in remains stable when FIFO is full
    assert property (data_in_stable_when_full)
    else $error("Assertion failed: data_in changed during write to full FIFO");

    // ====================================================================
    // Read domain data stability assertions
    // ====================================================================

    // Property: Data output should remain stable when not reading
    property data_out_stable_when_not_reading;
        @(posedge rd_clk) disable iff (!reset)
        rd_en |-> $stable(data_out);
    endproperty

    // Assertion: Check that data_out remains stable when not reading
    assert property (data_out_stable_when_not_reading)
    else $error("Assertion failed: data_out changed without read operation");

endinterface
