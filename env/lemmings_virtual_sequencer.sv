`ifndef LEMMINGS_VIRTUAL_SEQUENCER_SV
`define LEMMINGS_VIRTUAL_SEQUENCER_SV

class lemmings_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
  lemmings_master_sequencer mst_sqr;
  virtual lemmings_if vif;

  `uvm_component_utils(lemmings_virtual_sequencer)

  function new(string name = "lemmings_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual lemmings_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("VIRT_SQR", "can not get vif handle from config db")
    end
  endfunction: build_phase

endclass: lemmings_virtual_sequencer

`endif