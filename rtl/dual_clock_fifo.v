//  -----------------------------------------------------------------------------------------------------
//  Project Information:
//
//  Verificator           : Dedu Madalina-Florentina (DMF) & Chelemen Antonia (CA) & Florescu Vlad-Andrei ( FVA )
//  Date                  : 31/05/2024
//  File name             : dual_clock_fifo.v
//  Last modified+updates : 18/06/2024 (DMF & FVA & CA )
//  Project               : Generative AI
//
//  ------------------------------------------------------------------------------------------------------
//  Description         : RTL module for a dual clock FIFO (First In, First Out) memory.
//  ======================================================================================================

module dual_clock_fifo #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4)(
    input wire wr_clk,                    // Write clock signal
    input wire rd_clk,                    // Read clock signal
    input wire reset,                     // Active low reset signal
    input wire [DATA_WIDTH-1:0] data_in,  // Input data to be written into FIFO
    input wire wr_en,                     // Write enable signal
    input wire rd_en,                     // Read enable signal
    output reg [DATA_WIDTH-1:0] data_out, // Output data read from FIFO
    output wire full,                     // FIFO full flag
    output wire empty                     // FIFO empty flag
 );

    // FIFO Memory array: size is 2^ADDR_WIDTH
    reg [DATA_WIDTH-1:0] fifo_mem [(1<<ADDR_WIDTH)-1:0];

    // Write and read pointers (include an extra bit for gray code)
    reg [ADDR_WIDTH:0] wr_ptr, rd_ptr;
    reg [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1; // Synchronization register for read pointer gray code
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1; // Synchronization register for write pointer gray code

    // Write Domain: Increment write pointer on write clock edge
    always @(posedge wr_clk or negedge reset) begin
        if (!reset) begin
            wr_ptr <= 0;  // Reset write pointer on reset
        end else if (wr_en) begin
            wr_ptr <= wr_ptr + 1; // Increment write pointer if write enable is active
        end
    end

    // Write Domain: Convert write pointer to Gray code
    always @(posedge wr_clk or negedge reset) begin
        if (!reset) begin
            wr_ptr_gray <= 0; // Reset Gray code pointer on reset
        end else begin
            // Convert binary write pointer to Gray code
            wr_ptr_gray <= ((wr_ptr + 1) >> 1) ^ (wr_ptr + 1);
        end
    end

    // Read Domain: Increment read pointer on read clock edge
    always @(posedge rd_clk or negedge reset) begin
        if (!reset) begin
            rd_ptr <= 0;  // Reset read pointer on reset
        end else if (rd_en) begin
            rd_ptr <= rd_ptr + 1; // Increment read pointer if read enable is active
        end
    end

    // Read Domain: Convert read pointer to Gray code
    always @(posedge rd_clk or negedge reset) begin
        if (!reset) begin
            rd_ptr_gray <= 0; // Reset Gray code pointer on reset
        end else begin
            // Convert binary read pointer to Gray code
            rd_ptr_gray <= ((rd_ptr + 1) >> 1) ^ (rd_ptr + 1);
        end
    end

    // Synchronize write pointer Gray code to read clock domain
    always @(posedge rd_clk or negedge reset) begin
        if (!reset) begin
            wr_ptr_gray_sync1 <= 0; // Reset synchronized Gray code pointer on reset
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray; // Synchronize write pointer Gray code to read clock domain
        end
    end

    // Synchronize read pointer Gray code to write clock domain
    always @(posedge wr_clk or negedge reset) begin
        if (!reset) begin
            rd_ptr_gray_sync1 <= 0; // Reset synchronized Gray code pointer on reset
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray; // Synchronize read pointer Gray code to write clock domain
        end
    end

    // Write Domain: Write data into FIFO memory
    always @(posedge wr_clk) begin
        if (wr_en) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in; // Write data to FIFO memory at the address specified by write pointer
        end
    end

    // Read Domain: Read data from FIFO memory
    always @(posedge rd_clk or negedge reset) begin
        if (!reset) begin
            data_out <= 0; // Reset output data on reset
        end else if (rd_en) begin
            data_out <= fifo_mem[rd_ptr[ADDR_WIDTH-1:0]]; // Read data from FIFO memory at the address specified by read pointer
        end
    end

    // Combinational logic for full flag
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync1[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync1[ADDR_WIDTH-2:0]});
    // FIFO is full when the write pointer in Gray code matches the read pointer in Gray code, accounting for wrap-around

    // Combinational logic for empty flag
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync1);
    // FIFO is empty when the read pointer in Gray code matches the write pointer in Gray code
endmodule
