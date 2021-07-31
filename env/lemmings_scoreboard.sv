`ifndef LEMMINGS_SCOREBOARD_SV
`define LEMMINGS_SCOREBOARD_SV

class lemmings_scoreboard extends uvm_scoreboard;
  local int error_count;
  local int total_count;
  virtual lemmings_if vif;
  local lemmings_refmod refmod;
  uvm_tlm_analysis_fifo#(lemmings_master_trans) sbd_mst_tlm_fifo;
  uvm_tlm_analysis_fifo#(lemmings_slave_trans) sbd_slv_tlm_fifo;
  uvm_blocking_get_port#(lemmings_slave_trans) sbd_exp_bg_port;

  `uvm_component_utils(lemmings_scoreboard)

  function new(string name = "lemmings_scoreboard", uvm_component parent);
    super.new(name, parent);
    this.error_count = 0;
    this.total_count = 0;
    sbd_mst_tlm_fifo = new("sbd_mst_tlm_fifo", this);
    sbd_slv_tlm_fifo = new("sbd_slv_tlm_fifo", this);
    sbd_exp_bg_port = new("sbd_exp_bg_port", this);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual lemmings_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("SBD", "can not get lemmings vif handle from config db")
    end
    refmod = lemmings_refmod::type_id::create("refmod", this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    refmod.ref_in_bg_port.connect(this.sbd_mst_tlm_fifo.blocking_get_export);
    this.sbd_exp_bg_port.connect(refmod.ref_out_tlm_fifo.blocking_get_export);
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    do_data_compare();
  endtask: run_phase

  task do_data_compare();
    lemmings_slave_trans expt, mont;
    bit[3:0] cmp;
    forever begin
      this.sbd_slv_tlm_fifo.get(mont);
      this.sbd_exp_bg_port.get(expt);
      // cmp = mont.compare(expt);
      // this.total_count++;
      // if(cmp == 0) begin
      //   this.error_count++;
      //   #1ns;
      //   `uvm_info("CMPERR", $sformatf("monitored formatter data packet:\n %s", mont.sprint()), UVM_MEDIUM)
      //   `uvm_info("CMPERR", $sformatf("expected formatter data packet:\n %s", expt.sprint()), UVM_MEDIUM)
      //   `uvm_error("CMPERR", "comparing but failed!")
      // end
      // else begin
      //   `uvm_info("CMPSUC", "comparing and succeeded!", UVM_HIGH)
      // end
      foreach(expt.digging[i]) begin
        cmp[0] = compare_data(expt.walk_left[i], mont.walk_left[i]);
        cmp[1] = compare_data(expt.walk_right[i], mont.walk_right[i]);
        cmp[2] = compare_data(expt.aaah[i], mont.aaah[i]);
        cmp[3] = compare_data(expt.digging[i], mont.digging[i]);
        this.total_count++;
        if(cmp != 4'b1111) begin
          this.error_count++;
          `uvm_info("SBD", $sformatf("in expt %0d, walk_left=%0b, walk_right=%0b, aaah=%0b, digging=%0b", i, expt.walk_left[i], expt.walk_right[i], expt.aaah[i], expt.digging[i]), UVM_HIGH)
          `uvm_info("SBD", $sformatf("in mont %0d, walk_left=%0b, walk_right=%0b, aaah=%0b, digging=%0b", i, mont.walk_left[i], mont.walk_right[i], mont.aaah[i], mont.digging[i]), UVM_HIGH)
          `uvm_error("SBD", $sformatf("wrong in %0d", i))
        end
        else begin
          `uvm_info("SBD", $sformatf("succeeded in %0d", i), UVM_HIGH)
        end
      end
    end
  endtask: do_data_compare

  function void report_phase(uvm_phase phase);
    string s;
    super.report_phase(phase);
    s = "\n---------------------------------------------------------------\n";
    s = {s, "CHECKER SUMMARY \n"}; 
    s = {s, $sformatf("total comparison count: %0d \n", this.total_count)}; 
    s = {s, $sformatf("total error count: %0d \n", this.error_count)}; 
    s = {s, "---------------------------------------------------------------\n"};
    `uvm_info("SBD", s, UVM_LOW)
  endfunction: report_phase

  function bit compare_data(input bit a, b);
    if(a == b) return 1;
    else return 0;
  endfunction: compare_data

endclass: lemmings_scoreboard

`endif