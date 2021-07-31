`ifndef LEMMINGS_MASTER_SEQUENCER_SV
`define LEMMINGS_MASTER_SEQUENCER_SV

class lemmings_master_sequencer extends uvm_sequencer#(lemmings_master_trans);

  `uvm_component_utils(lemmings_master_sequencer)

  function new(string name = "lemmings_master_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new

endclass: lemmings_master_sequencer

`endif