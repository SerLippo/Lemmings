`ifndef LEMMINGS_MASTER_DRIVER_SV
`define LEMMINGS_MASTER_DRIVER_SV

class lemmings_master_driver extends uvm_driver#(lemmings_master_trans);
  virtual lemmings_if vif;
  uvm_analysis_port#(int) mst_drv_handshake_ana_port;
  // uvm_tlm_analysis_fifo#(int) mst_drv_handshake_ana_fifo;

  `uvm_component_utils(lemmings_master_driver)

  function new(string name = "lemmings_mater_driver", uvm_component parent);
    super.new(name, parent);
    mst_drv_handshake_ana_port = new("mst_drv_handshake_ana_port", this);
    // mst_drv_handshake_ana_imp = new("mst_drv_handshake_ana_imp", this);
  endfunction: new

  task run_phase(uvm_phase phase);
    fork
      do_reset();
      do_drive();
    join
  endtask: run_phase

  task do_reset();
    forever begin
      @(negedge vif.rstn);
      vif.bump_left <= 0;
      vif.bump_right <= 0;
      vif.ground <= 1;
      vif.dig <= 0;
    end
  endtask: do_reset

  task do_drive();
    int shakeback;
    @(posedge vif.rstn);
    forever begin
      wait(vif.rstn == 1);
      seq_item_port.get_next_item(req);
      mst_drv_handshake_ana_port.write(req.size);
      this.do_write(req);
      void'($cast(rsp, req.clone()));
      rsp.set_sequence_id(req.get_sequence_id());
      rsp.rsp = '1;
      // mst_drv_handshake_ana_fifo.get(shakeback);
      seq_item_port.item_done(rsp);
    end
  endtask: do_drive

  task do_write(lemmings_master_trans t);
    foreach(t.dig[i]) begin
      string s;
      @(vif.drv_ck);
      vif.drv_ck.bump_left <= t.bump_left[i];
      vif.drv_ck.bump_right <= t.bump_right[i];
      vif.drv_ck.ground <= t.ground[i];
      vif.drv_ck.dig <= t.dig[i];
      s = $sformatf("\n=======================================\n");
      s = {s, $sformatf("this trans' %0dth lemmings' next step: \n", i)};
      s = {s, $sformatf("bump_left = %0d: \n", t.bump_left[i])};
      s = {s, $sformatf("bump_right = %0d: \n", t.bump_right[i])};
      s = {s, $sformatf("ground = %0d: \n", t.ground[i])};
      s = {s, $sformatf("dig = %0d: \n", t.dig[i])};
      s = {s, $sformatf("=======================================\n")};
      `uvm_info("MST_DRV", s, UVM_HIGH)
    end
  endtask: do_write
  
endclass: lemmings_master_driver

`endif