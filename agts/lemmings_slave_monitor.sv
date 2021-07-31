`ifndef LEMMINGS_SLAVE_MONITOR_SV
`define LEMMINGS_SLAVE_MONITOR_SV

class lemmings_slave_monitor extends uvm_monitor;
  virtual lemmings_if vif;
  uvm_analysis_port#(lemmings_slave_trans) slv_mon_ana_port;
  uvm_tlm_analysis_fifo#(int) slv_mon_handshake_ana_fifo;

  `uvm_component_utils(lemmings_slave_monitor)

  function new(string name = "lemmings_slave_monitor", uvm_component parent);
    super.new(name, parent);
    slv_mon_ana_port = new("slv_mon_ana_port", this);
    slv_mon_handshake_ana_fifo = new("slv_mon_handshake_ana_fifo", this);
  endfunction: new

  task run_phase(uvm_phase phase);
    do_mon();
  endtask: run_phase

  task do_mon();
    lemmings_slave_trans t;
    string s;
    int size;
    @(posedge vif.rstn);
    forever begin
      slv_mon_handshake_ana_fifo.get(size);
      t = new();
      t.size = size;
      t.walk_left = new[size];
      t.walk_right = new[size];
      t.aaah = new[size];
      t.digging = new[size];
      repeat(2) @(vif.mon_ck);
      for(int i=0; i<size; i++) begin
        @(vif.mon_ck);
        t.walk_left[i] = vif.mon_ck.walk_left;
        t.walk_right[i] = vif.mon_ck.walk_right;
        t.aaah[i] = vif.mon_ck.aaah;
        t.digging[i] = vif.mon_ck.digging;
        s = $sformatf("\n=======================================\n");
        s = {s, $sformatf("this trans' %0dth monitored a packet: \n", i)};
        s = {s, $sformatf("walk_left = %0d: \n", vif.mon_ck.walk_left)};
        s = {s, $sformatf("walk_right = %0d: \n", vif.mon_ck.walk_right)};
        s = {s, $sformatf("aaah = %0d: \n", vif.mon_ck.aaah)};
        s = {s, $sformatf("digging = %0d: \n", vif.mon_ck.digging)};
        s = {s, $sformatf("=======================================\n")};
        `uvm_info("SLV_MON", s, UVM_HIGH)
      end
      slv_mon_ana_port.write(t);
    end
  endtask: do_mon

endclass: lemmings_slave_monitor

`endif