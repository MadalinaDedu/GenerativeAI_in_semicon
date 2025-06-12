class reset_sequence extends uvm_sequence#(reset_item);
  `uvm_object_utils(reset_sequence)

  // Constructor
  reset_item reset_tx;
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction

  // Body task
  virtual task body();

    // Create a new reset transaction
    reset_tx = reset_item::type_id::create("reset_tx");

    start_item(reset_tx);
      reset_tx.reset = 1'b0;  // Assert reset (active low)
    finish_item(reset_tx);
    #50;

    start_item(reset_tx);
      reset_tx.reset = 1'b1;  // De-assert reset (active low)
    finish_item(reset_tx);

  endtask: body

endclass: reset_sequence
