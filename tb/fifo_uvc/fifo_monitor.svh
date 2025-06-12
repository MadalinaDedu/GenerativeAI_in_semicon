

class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  // Virtual interface reference
  virtual fifo_if vif;
  fifo_item trans;

  // Analysis ports
  uvm_analysis_port #(fifo_item) item_collected_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_port = new("item_collected_port", this);

    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"})

    trans = fifo_item::type_id::create("trans");
  endfunction: build_phase

  // Run phase
  task run_phase(uvm_phase phase);
    fork
      monitor_writes();
      monitor_reads();
    join
  endtask: run_phase

  // Monitor write transactions
  task monitor_writes();
    forever begin
      @(posedge vif.wr_clk);

        `uvm_info(get_type_name(), $sformatf("Monitoring transaction 1:  WRITE %s", trans.convert2string()), UVM_LOW);
      if (vif.wr_en ) begin

        `uvm_info(get_type_name(), $sformatf("Monitoring transaction 2:  WRITE %s", trans.convert2string()), UVM_LOW);
        trans.data  = vif.data_in;
        trans.operation = WRITE;
        trans.full  = vif.full   ;
        trans.empty = vif.empty  ;
        trans.wr_en = vif.wr_en  ;
        trans.rd_en = vif.rd_en  ;
        `uvm_info(get_type_name(), $sformatf("Monitoring transaction 3:  WRITE %s", trans.convert2string()), UVM_LOW);
        item_collected_port.write(trans);
      end
    end
  endtask: monitor_writes

  // Monitor read transactions
  task monitor_reads();
   forever begin
      @(posedge vif.rd_clk);
      `uvm_info(get_type_name(), $sformatf("Monitoring transaction 1:  READ %s", trans.convert2string()), UVM_LOW);
      if ( vif.rd_en ) begin
        trans.data  = vif.data_out;
        trans.operation = READ;
        trans.full  = vif.full    ;
        trans.empty = vif.empty   ;
        trans.rd_en = vif.rd_en   ;
        trans.wr_en = vif.wr_en   ;
      `uvm_info(get_type_name(), $sformatf("Monitoring transaction 3:  READ %s", trans.convert2string()), UVM_LOW);
        item_collected_port.write(trans);
      end
    end
  endtask: monitor_reads

endclass: fifo_monitor
