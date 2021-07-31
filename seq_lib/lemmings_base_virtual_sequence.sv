`ifndef LEMMINGS_BASE_VIRTUAL_SEQUENCE_SV
`define LEMMINGS_BASE_VIRTUAL_SEQUENCE_SV

class lemmings_base_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
  lemmings_master_sequence mst_seq;

  `uvm_object_utils(lemmings_base_virtual_sequence)

  `uvm_declare_p_sequencer(lemmings_virtual_sequencer)

  function new(string name = "lemmings_base_virtual_sequence");
    super.new(name);
  endfunction: new

  virtual task body();
    `uvm_info("VIRT_SEQ", "=================STARTED=================", UVM_LOW)
    this.do_mst_seq();
    `uvm_info("VIRT_SEQ", "=================FINISHED================", UVM_LOW)
  endtask: body

  virtual task do_mst_seq();
  endtask: do_mst_seq

endclass: lemmings_base_virtual_sequence

`endif