`ifndef LEMMINGS_SLAVE_AGENT_SV
`define LEMMINGS_SLAVE_AGENT_SV

class lemmings_slave_agent extends uvm_agent;
  lemmings_slave_monitor mon;
  virtual lemmings_if vif;

  `uvm_component_utils(lemmings_slave_agent)

  function new(string name = "lemmings_slave_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual lemmings_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("SLV_AGT", "can not get vif handle from config db")
    end
    mon = lemmings_slave_monitor::type_id::create("mon", this);
    mon.vif = this.vif;
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

endclass: lemmings_slave_agent

`endif