`ifndef LEMMINGS_BASE_TEST_SV
`define LEMMINGS_BASE_TEST_SV

class lemmings_base_test extends uvm_test;
  lemmings_env env;

  `uvm_component_utils(lemmings_base_test)

  function new(string name = "lemmings_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = lemmings_env::type_id::create("env", this);
  endfunction: build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_root::get().set_report_verbosity_level_hier(UVM_HIGH);
    uvm_root::get().set_report_max_quit_count(1);
    uvm_root::get().set_timeout(1ms);
  endfunction: end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    this.run_top_virtual_sequence();
    phase.drop_objection(this);
  endtask: run_phase

  virtual task run_top_virtual_sequence();
  endtask: run_top_virtual_sequence

endclass: lemmings_base_test

`endif