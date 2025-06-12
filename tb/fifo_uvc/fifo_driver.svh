class fifo_driver extends uvm_driver #(fifo_item);
  `uvm_component_utils(fifo_driver)
  // Virtual interface to connect with DUT
  virtual fifo_if vif;
  fifo_item tr;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

// Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface must be set for fifo_driver")
    end
  endfunction

    // Run phase
  virtual task run_phase(uvm_phase phase);
   initialize();
   @(posedge vif.reset)

   forever begin

    seq_item_port.get_next_item(tr);
    drive_transaction(tr); // Drive the transaction based on operation type
    seq_item_port.item_done();

   end
  endtask

  // Task to initialize the FIFO
  task initialize();
    vif.wr_en   <= 1'b0;
    vif.rd_en   <= 1'b0;
    vif.data_in <= 8'h00;
  endtask

  // Task to drive a transaction based on operation type
  virtual task drive_transaction(fifo_item tr);
  `uvm_info(get_type_name(), $sformatf("Driving transaction: %s", tr.convert2string()), UVM_LOW);

     if(~vif.reset)    initialize();
    case (tr.operation)
      WRITE: begin
        @( vif.wr_cb);
        if (vif.reset) begin
          `uvm_info(get_type_name(), $sformatf("Driving transaction 1:  WRITE %s", tr.convert2string()), UVM_LOW);
          vif.wr_en   <= 1'b1   ;
          vif.data_in <= tr.data; // Assign data to be written
          `uvm_info(get_type_name(), $sformatf("Driving transaction 2:  WRITE %s", tr.convert2string()), UVM_LOW);
          @(vif.wr_cb);
          vif.wr_en   <= 1'b0;
          `uvm_info(get_type_name(), $sformatf("Driving transaction 3:  WRITE %s", tr.convert2string()), UVM_LOW);
        end
      end
      READ: begin
        @(vif.rd_cb);
        if (vif.reset) begin
          `uvm_info(get_type_name(), $sformatf("Driving transaction 1:  READ %s", tr.convert2string()), UVM_LOW);
          vif.rd_en <= 1'b1;
          `uvm_info(get_type_name(), $sformatf("Driving transaction 2:  READ %s", tr.convert2string()), UVM_LOW);
          @(vif.rd_cb);
          // tr.data   <= vif.data_out; // Capture data read from FIFO
          vif.rd_en <= 1'b0;
          `uvm_info(get_type_name(), $sformatf("Driving transaction 3:  READ %s", tr.convert2string()), UVM_LOW);
        end
      end
      default: begin
        $display("Invalid operation type: %0d", tr.operation);
      end
    endcase
  endtask

  // // Task to write data to the FIFO
  // task write_data();
  //   @(vif.wr_cb);
  //   // if (!vif.full) begin
  //     vif.wr_en <= 1'b1;
  //     vif.data_in <= tr.data_in; // Assign data to be written
  //     @(vif.wr_cb);
  //     vif.wr_en <= 1'b0;
  //   // end else begin
  //     $display("FIFO is full, cannot write data: %h", tr.data_in);
  //   // end
  // endtask

  // // Task to read data from the FIFO
  // task read_data();
  //   @(vif.rd_cb);
  //   // if (!vif.empty) begin
  //     vif.rd_en <= 1'b1;
  //     @(vif.rd_cb);
  //     tr.data_out = vif.data_out;
  //     vif.rd_en <= 1'b0;
  //   // end else begin
  //     $display("FIFO is empty, cannot read data");
  //     // tr.data_out = 8'hXX;
  //   // end
  // endtask

  // // Task to monitor FIFO status
  // task monitor_status();
  //   forever begin
  //     @(posedge vif.wr_clk or posedge vif.rd_clk);
  //     if (vif.full)
  //       $display("FIFO is full");
  //     if (vif.empty)
  //       $display("FIFO is empty");
  //   end
  // endtask

endclass
