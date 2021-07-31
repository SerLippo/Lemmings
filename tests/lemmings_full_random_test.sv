`ifndef LEMMINGS_FULL_RANDOM_TEST_SV
`define LEMMINGS_FULL_RANDOM_TEST_SV

class lemmings_full_random_test extends lemmings_base_test;

  `uvm_component_utils(lemmings_full_random_test)

  function new(string name = "lemmings_full_random_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  task run_top_virtual_sequence();
    lemmings_full_random_virt_seq seq = new();
    seq.start(env.virt_sqr);
  endtask: run_top_virtual_sequence

endclass: lemmings_full_random_test

`endif