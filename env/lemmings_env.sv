`ifndef LEMMINGS_ENV_SV
`define LEMMINGS_ENV_SV

class lemmings_env extends uvm_env;
  lemmings_master_agent mst_agt;
  lemmings_slave_agent slv_agt;
  lemmings_scoreboard sbd;
  lemmings_virtual_sequencer virt_sqr;

  `uvm_component_utils(lemmings_env)

  function new(string name = "lemmings_env", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mst_agt = lemmings_master_agent::type_id::create("mst_agt", this);
    slv_agt = lemmings_slave_agent::type_id::create("slv_agt", this);
    sbd = lemmings_scoreboard::type_id::create("sbd", this);
    virt_sqr = lemmings_virtual_sequencer::type_id::create("virt_sqr", this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mst_agt.mon.mst_mon_ana_port.connect(sbd.sbd_mst_tlm_fifo.analysis_export);
    slv_agt.mon.slv_mon_ana_port.connect(sbd.sbd_slv_tlm_fifo.analysis_export);
    // handshake tlm connect
    mst_agt.drv.mst_drv_handshake_ana_port.connect(mst_agt.mon.mst_mon_handshake_ana_fifo.analysis_export);
    mst_agt.drv.mst_drv_handshake_ana_port.connect(slv_agt.mon.slv_mon_handshake_ana_fifo.analysis_export);
    virt_sqr.mst_sqr = mst_agt.sqr;
  endfunction: connect_phase

endclass: lemmings_env

`endif