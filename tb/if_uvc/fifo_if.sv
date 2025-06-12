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
//  Description         : It is a way to encapsulate signals into a block. All related signals are grouped together to form an interface block so that the same interface.
//  ======================================================================================================


interface fifo_if(
    input reg clk_wr,
    input reg clk_rd,
    input reg rst
 );
    parameter DATA_WIDTH = 8;

    reg [DATA_WIDTH-1:0] data_in ;
    reg                  wr_en   ;
    reg                  rd_en   ;
    reg [DATA_WIDTH-1:0] data_out;
    reg                  full    ;
    reg                  empty   ;

    // Clocking block for write domain
    clocking cb_wr @(posedge clk_wr);
        input  rst;
        output data_in;
        output wr_en;
        input  full;
    endclocking

    // Clocking block for read domain
    clocking cb_rd @(posedge clk_rd);
        input  rst;
        output rd_en;
        input  data_out;
        input  empty;
    endclocking



//==============================================Asertii==================================================
    property p_wr_data_stable;
        @(posedge clk_wr) disable iff (~rst)
        wr_en |-> ##1 $stable(data_in);
    endproperty

    property p_rd_data_stable;
        @(posedge clk_rd) disable iff (~rst)
        rd_en |-> $stable(data_out);
    endproperty

    property p_fifo_not_write_when_full;
        @(posedge clk_wr) disable iff (~rst)
        full |->  !wr_en;
    endproperty

    property p_fifo_not_read_when_empty;
        @(posedge clk_rd) disable iff (~rst)
          rd_en |->  ~empty;
    endproperty


    assert property(p_wr_data_stable)           else $error("Data is not stable during write transaction at time %t", $realtime);
    assert property(p_rd_data_stable)           else $error("Data is not stable during read transaction at time %t", $realtime) ;
    assert property(p_fifo_not_write_when_full) else $error("Write enable is asserted when FIFO is full at time %t", $realtime) ;
    assert property(p_fifo_not_read_when_empty) else $error("Read enable is asserted when FIFO is empty at time %t", $realtime) ;

endinterface