class fifo_base_vseq extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(fifo_base_vseq)

  // Declare the parent sequencer using uvm_declare_p_sequencer
  `uvm_declare_p_sequencer(fifo_virtual_sequencer)

  // Constructor
  function new(string name = "fifo_base_vseq");
    super.new(name);
  endfunction
endclass

class fifo_rw_sequence extends fifo_base_vseq;
  `uvm_object_utils(fifo_rw_sequence)

  typedef fifo_sequence fifo_obj_sequence;

  function new(string name = "fifo_rw_sequence");
    super.new(name);
  endfunction

  task body();

     fifo_obj_sequence fifo_vseq ;
     fifo_vseq = fifo_obj_sequence::type_id::create("fifo_vseq");
     fifo_vseq.start(p_sequencer.fifo_sqr); // Start the sequence using the sequencer
    // Access the sequencer using p_sequencer
    // Rest of the sequence body
  endtask
endclass