class virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(virtual_sequencer)

    // Declare the sequencer handles
    fifo_sequencer fifo_seqr;
    reset_sequencer reset_seqr;

    // Constructor
    function new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Instantiate the sequencers
        fifo_seqr = fifo_sequencer::type_id::create("fifo_seqr", this);
        reset_seqr = reset_sequencer::type_id::create("reset_seqr", this);
    endfunction
endclass
