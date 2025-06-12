class base_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(base_virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    function new(string name = "base_virtual_sequence");
        super.new(name);
    endfunction : new
endclass : base_virtual_sequence

  class fifo_rw_sequence extends base_virtual_sequence;
    `uvm_object_utils(fifo_rw_sequence)

    typedef fifo_sequence fifo_obj_sequence;
    function new(string name = "fifo_rw_sequence");
      super.new(name);
    endfunction : new

    task body();
      fifo_obj_sequence fifo_sequence;
      fifo_sequence = fifo_obj_sequence::type_id::create("fifo_sequence");
      fifo_sequence.start(p_sequencer.fifo_seqr);
    endtask : body
  endclass : fifo_rw_sequence
