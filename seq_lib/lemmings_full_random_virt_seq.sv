`ifndef LEMMINGS_FULL_RANDOM_VIRT_SEQ_SV
`define LEMMINGS_FULL_RANDOM_VIRT_SEQ_SV

class lemmings_full_random_virt_seq extends lemmings_base_virtual_sequence;

  `uvm_object_utils(lemmings_full_random_virt_seq)

  function new(string name = "lemmings_full_random_virt_seq");
    super.new(name);
  endfunction: new

  task do_mst_seq();
    `uvm_do_on_with(mst_seq, p_sequencer.mst_sqr, {
      size inside {[20:300]};
    })
    #1ns;
  endtask: do_mst_seq
endclass: lemmings_full_random_virt_seq

`endif