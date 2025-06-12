
class fifo_base_sequence extends uvm_sequence #(fifo_item);
  `uvm_object_utils(fifo_base_sequence)
  `uvm_declare_p_sequencer(fifo_sequencer)

  fifo_item fifo_tr;

  function new(string name = "fifo_base_sequence");
    super.new(name);
    fifo_tr = fifo_item::type_id::create("fifo_tr");
  endfunction
endclass

class fifo_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  task body();
    fifo_item fifo_tr;

    `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)

    repeat(16) begin
      start_item(fifo_tr);
      if (!fifo_tr.randomize() with {operation == WRITE;
                                     data inside {[1:255]};}) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
      finish_item(fifo_tr);
    end

    repeat(16) begin
      // fifo_tr = fifo_item::type_id::create("fifo_tr");
      start_item(fifo_tr);
      if (!fifo_tr.randomize() with {operation == READ;}) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
      finish_item(fifo_tr);
    end

    `uvm_info(get_type_name(), "Write sequence completed", UVM_LOW)
  endtask
endclass

class fifo_write_16_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_write_16_sequence)

  function new(string name = "fifo_write_16_sequence");
    super.new(name);
  endfunction

  task body();
    fifo_item fifo_tr;

    `uvm_info(get_type_name(), "Starting 16 write sequence", UVM_LOW)

    repeat(16) begin
      fifo_tr = fifo_item::type_id::create("fifo_tr");
      start_item(fifo_tr);
      if (!fifo_tr.randomize() with {operation == WRITE;
                                     data inside {[1:255]};}) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
      finish_item(fifo_tr);
    end

    `uvm_info(get_type_name(), "16 write sequence completed", UVM_LOW)
  endtask
endclass

class fifo_read_16_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_read_16_sequence)

  function new(string name = "fifo_read_16_sequence");
    super.new(name);
  endfunction

  task body();
    fifo_item fifo_tr;
    fifo_tr = fifo_item::type_id::create("fifo_tr");

    `uvm_info(get_type_name(), "Starting 16 read sequence", UVM_LOW)

    repeat(16) begin
      start_item(fifo_tr);
      if (!fifo_tr.randomize() with {operation == READ;}) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
      finish_item(fifo_tr);
    end

    `uvm_info(get_type_name(), "16 read sequence completed", UVM_LOW)
  endtask
endclass

class fifo_write_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_write_sequence)

  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Starting write sequence", UVM_LOW)

    start_item(fifo_tr);
      if (!fifo_tr.randomize() with {operation == WRITE;
                                     data inside {[1:255]};}) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
    finish_item(fifo_tr);

    `uvm_info(get_type_name(), "Write sequence completed", UVM_LOW)
  endtask
endclass

class fifo_read_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_read_sequence)

  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Starting read sequence", UVM_LOW)

    start_item(fifo_tr);
    fifo_tr.operation = READ;
    finish_item(fifo_tr);

    `uvm_info(get_type_name(), "Read sequence completed", UVM_LOW)
  endtask
endclass

class fifo_write_100_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_write_100_sequence)

  function new(string name = "fifo_write_100_sequence");
    super.new(name);
  endfunction

  task body();
    fifo_item fifo_tr;

    `uvm_info(get_type_name(), "Starting 100 write sequence", UVM_LOW)

    repeat(100) begin
      fifo_tr = fifo_item::type_id::create("fifo_tr");
      start_item(fifo_tr);
      if (!fifo_tr.randomize() with {operation == WRITE;
                                     data inside {[1:255]};}) begin
        `uvm_error(get_type_name(), "Randomization failed")
      end
      finish_item(fifo_tr);
    end

    `uvm_info(get_type_name(), "100 write sequence completed", UVM_LOW)
  endtask
endclass