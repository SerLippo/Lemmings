`ifndef LEMMINGS_MASTER_MONITOR_SV
`define LEMMINGS_MASTER_MONITOR_SV

class lemmings_master_monitor extends uvm_monitor;
  virtual lemmings_if vif;
  uvm_analysis_port#(lemmings_master_trans) mst_mon_ana_port;
  uvm_tlm_analysis_fifo#(int) mst_mon_handshake_ana_fifo;

  `uvm_component_utils(lemmings_master_monitor)

  function new(string name = "lemmings_master_monitor", uvm_component parent);
    super.new(name, parent);
    mst_mon_ana_port = new("mst_mon_ana_port", this);
    mst_mon_handshake_ana_fifo = new("mst_mon_handshake_ana_fifo", this);
  endfunction: new

  task run_phase(uvm_phase phase);
    do_mon();
  endtask: run_phase

  task do_mon();
    lemmings_master_trans t;
    string s;
    int size;
    @(posedge vif.rstn);
    forever begin
      mst_mon_handshake_ana_fifo.get(size);
      t = new();
      t.size = size;
      t.bump_left = new[size];
      t.bump_right = new[size];
      t.ground = new[size];
      t.dig = new[size];
      @(vif.mon_ck);
      for(int i=0; i<size; i++) begin
        @(vif.mon_ck);
        t.bump_left[i] = vif.mon_ck.bump_left;
        t.bump_right[i] = vif.mon_ck.bump_right;
        t.ground[i] = vif.mon_ck.ground;
        t.dig[i] = vif.mon_ck.dig;
        s = $sformatf("\n=======================================\n");
        s = {s, $sformatf("this trans' %0dth monitored a packet: \n", i)};
        s = {s, $sformatf("bump_left = %0d: \n", t.bump_left[i])};
        s = {s, $sformatf("bump_right = %0d: \n", t.bump_right[i])};
        s = {s, $sformatf("ground = %0d: \n", t.ground[i])};
        s = {s, $sformatf("dig = %0d: \n", t.dig[i])};
        s = {s, $sformatf("=======================================\n")};
        `uvm_info("MST_MON", s, UVM_FULL)
      end
      mst_mon_ana_port.write(t);
    end
  endtask: do_mon

endclass: lemmings_master_monitor

`endif