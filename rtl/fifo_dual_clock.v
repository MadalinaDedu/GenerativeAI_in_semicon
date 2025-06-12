module fifo_dual_clock #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input wire wr_clk,
    input wire rd_clk,
    input wire rst_n,  // Active low asynchronous reset
    input wire [DATA_WIDTH-1:0] data_in,
    input wire wr_en,
    input wire rd_en,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

    // Memory declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;
    reg [ADDR_WIDTH:0] wr_ptr_gray;
    reg [ADDR_WIDTH:0] rd_ptr_gray;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync;

    // Synchronizers
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1;

    // Gray code conversion functions
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    function [ADDR_WIDTH:0] gray2bin(input [ADDR_WIDTH:0] gray);
        integer i;
        reg [ADDR_WIDTH:0] bin;
        begin
            bin = gray;
            for (i = 1; i <= ADDR_WIDTH; i = i + 1)
                bin = bin ^ (gray >> i);
            gray2bin = bin;
        end
    endfunction

    // Write pointer logic
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Write pointer gray code logic
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            wr_ptr_gray <= bin2gray(wr_ptr + 1);
        end
    end

    // Memory write logic
    always @(posedge wr_clk) begin
        if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
        end
    end

    // Read pointer logic
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Read pointer gray code logic
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_gray <= bin2gray(rd_ptr + 1);
        end
    end

    // Data output logic
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr[ADDR_WIDTH-1:0]];
        end
    end

    // Read pointer synchronization - first stage
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_gray_sync1 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
        end
    end

    // Read pointer synchronization - second stage
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_gray_sync <= 0;
        end else begin
            rd_ptr_gray_sync <= rd_ptr_gray_sync1;
        end
    end

    // Write pointer synchronization - first stage
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray_sync1 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
        end
    end

    // Write pointer synchronization - second stage
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray_sync <= 0;
        end else begin
            wr_ptr_gray_sync <= wr_ptr_gray_sync1;
        end
    end

    // Full and empty flag generation
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync[ADDR_WIDTH-2:0]});
    // Early deassertion of empty: check if next read pointer (in gray code) matches the synchronized write pointer
    wire [ADDR_WIDTH:0] rd_ptr_next = rd_ptr + 1;
    wire [ADDR_WIDTH:0] rd_ptr_next_gray = bin2gray(rd_ptr_next);

    assign empty = (rd_ptr_gray == wr_ptr_gray_sync);// || (rd_ptr_next_gray == wr_ptr_gray_sync && !rd_en);

endmodule
