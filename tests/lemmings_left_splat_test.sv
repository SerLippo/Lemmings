`ifndef LEMMINGS_LEFT_SPLAT_TEST_SV
`define LEMMINGS_LEFT_SPLAT_TEST_SV

class lemmings_left_splat_test extends lemmings_base_test;

  `uvm_component_utils(lemmings_left_splat_test)

  function new(string name = "lemmings_left_splat_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  task run_top_virtual_sequence();
    lemmings_left_splat_virt_seq seq = new();
    seq.start(env.virt_sqr);
  endtask: run_top_virtual_sequence

endclass: lemmings_left_splat_test

`endif