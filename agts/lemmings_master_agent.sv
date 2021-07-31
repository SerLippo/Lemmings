`ifndef LEMMINGS_MASTER_AGENT_SV
`define LEMMINGS_MASTER_AGENT_SV

class lemmings_master_agent extends uvm_agent;
  lemmings_master_sequencer sqr;
  lemmings_master_driver drv;
  lemmings_master_monitor mon;
  virtual lemmings_if vif;

  `uvm_component_utils(lemmings_master_agent)

  function new(string name = "lemmings_master_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual lemmings_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MST_AGT", "can not get vif handle from config db")
    end
    mon = lemmings_master_monitor::type_id::create("mon", this);
    mon.vif = this.vif;
    sqr = lemmings_master_sequencer::type_id::create("sqr", this);
    drv = lemmings_master_driver::type_id::create("drv", this);
    drv.vif = this.vif;
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction: connect_phase

endclass: lemmings_master_agent

`endif