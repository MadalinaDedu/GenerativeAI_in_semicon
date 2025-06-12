//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : fifo_if.sv
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : Defines an interface block for FIFO (First-In-First-Out) operations.
//                        This encapsulates signals related to FIFO functionality and provides clocking blocks
//                        for write and read domains, along with assertions for signal stability and FIFO conditions.
//  ======================================================================================================

interface fifo_if(
    input reg clk_wr,    // Write clock input
    input reg clk_rd,    // Read clock input
    input reg rst        // Reset input
);
    parameter DATA_WIDTH = 8; // Parameter defining the width of the data signals
    logic [DATA_WIDTH-1:0] data_in; // Input data for writing to FIFO
    logic wr_en;             // Write enable signal
    logic rd_en;             // Read enable signal
    logic [DATA_WIDTH-1:0] data_out; // Output data from FIFO
    logic full;              // FIFO full flag
    logic empty;             // FIFO empty flag

    // Clocking block for the write domain
    clocking cb_wr @(posedge clk_wr);
        input rst;            // Read reset signal (from write domain perspective)
        output data_in;      // Output data input signal
        output wr_en;        // Output write enable signal
        input full;          // Input FIFO full signal
    endclocking

    // Clocking block for the read domain
    clocking cb_rd @(posedge clk_rd);
        input rst;            // Read reset signal (from read domain perspective)
        output rd_en;        // Output read enable signal
        input data_out;      // Input data output signal
        input empty;         // Input FIFO empty signal
    endclocking

    // Clocking block for the read domain
    clocking cb_mon @(posedge clk_rd) ; //here was a mistake - also add clk wr should choose one
        input rst;            // Read reset signal (from read domain perspective)
        input rd_en;        // Output read enable signal
        input wr_en;        // Output write enable signal
        input data_out;      // Input data output signal
        input empty;         // Input FIFO empty signal
        input full;         // Input FIFO full signal
    endclocking

    // Assertion to ensure data stability during write operations
    property p_wr_data_stable;
        @(posedge clk_wr)    // Trigger at rising edge of the write clock
        disable iff (~rst)   // Disable assertion if reset is active
        wr_en |=> $stable(data_in); // Ensure data_in remains stable if write enable is high
    endproperty
    assert property (p_wr_data_stable)
        else $error("Assertion failed: During write transactions, data_in must be stable at time %t", $realtime);

    // Assertion to ensure data stability during read operations
    property p_rd_data_stable;
        @(posedge clk_rd)    // Trigger at rising edge of the read clock
        disable iff (~rst)   // Disable assertion if reset is active
        rd_en |-> $stable(data_out); // Ensure data_out remains stable if read enable is high
    endproperty
    assert property (p_rd_data_stable)
        else $error("Assertion failed: During read transactions, data_out must be stable at time %t", $realtime);

    // Assertion to check FIFO full condition
    property full_fifo_check;
      @(posedge clk_wr)      // Trigger at rising edge of the write clock
      disable iff (!rst)     // Disable assertion if reset is inactive
      full |-> ~wr_en;       // If FIFO is full, write enable must be low
    endproperty
    assert property (full_fifo_check)
      else $error("Assertion failed: Write attempt when FIFO is FULL at time %t", $realtime);

    // Assertion to check FIFO empty condition
    property empty_fifo_check;
      @(posedge clk_rd)      // Trigger at rising edge of the read clock
      disable iff (!rst)     // Disable assertion if reset is inactive
      rd_en |-> ~empty;     // If read enable is high, FIFO must not be empty
    endproperty
    assert property (empty_fifo_check)
      else $error("Assertion failed: Read attempt when FIFO is EMPTY at time %t", $realtime);

endinterface
