`ifndef LEMMINGS_REFMOD_SV
`define LEMMINGS_REFMOD_SV

class lemmings_refmod extends uvm_component;
  uvm_blocking_get_port#(lemmings_master_trans) ref_in_bg_port;
  uvm_tlm_analysis_fifo#(lemmings_slave_trans) ref_out_tlm_fifo;

  `uvm_component_utils(lemmings_refmod)

  function new(string name = "lemmings_refmod", uvm_component parent);
    super.new(name, parent);
    ref_in_bg_port = new("ref_in_bg_port", this);
    ref_out_tlm_fifo = new("ref_out_tlm_fifo", this);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    do_packet();
  endtask: run_phase

  task do_packet();
    state_t state = LEFT;
    state_t next;
    bit[7:0] count;
    int size;
    lemmings_master_trans it;
    lemmings_slave_trans ot;
    string s;
    fork
      forever begin
        ot = new();
        this.ref_in_bg_port.get(it);
        size = it.size;
        ot.size = it.size;
        ot.walk_left = new[size];
        ot.walk_right = new[size];
        ot.aaah = new[size];
        ot.digging = new[size];
        for(int i=0; i<size; i++) begin
          this.do_next(i, it, state, count, next);
          this.do_state(next, state);
          this.do_count(next, count);
          this.do_out(i, next, ot);
          s = $sformatf("\n=======================================\n");
          s = {s, $sformatf("this trans' %0dth refmod a packet: \n", i)};
          s = {s, $sformatf("walk_left = %0d: \n", ot.walk_left[i])};
          s = {s, $sformatf("walk_right = %0d: \n", ot.walk_right[i])};
          s = {s, $sformatf("aaah = %0d: \n", ot.aaah[i])};
          s = {s, $sformatf("digging = %0d: \n", ot.digging[i])};
          s = {s, $sformatf("=======================================\n")};
          `uvm_info("REFMOD", s, UVM_HIGH)
        end
        this.ref_out_tlm_fifo.put(ot);
      end
    join
  endtask: do_packet

  task do_next(input int i, input lemmings_master_trans it, input state_t state, input bit[7:0] count, output state_t next);
    case(state)
      LEFT: begin
        casez({it.bump_left[i],it.ground[i],it.dig[i]})
          3'b110: next = RIGHT;
          3'bz11: next = DIG_L;
          3'bz0z: next = FALL_L;
          default:next = LEFT;
        endcase
      end
      RIGHT: begin
        casez({it.bump_right[i],it.ground[i],it.dig[i]})
          3'b110: next = LEFT;
          3'bz11: next = DIG_R;
          3'bz0z: next = FALL_R;
          default: next = RIGHT;
        endcase
      end
      DIG_L: begin
        next = it.ground[i] ? DIG_L : FALL_L;
      end
      DIG_R: begin
        next = it.ground[i] ? DIG_R : FALL_R;
      end
      FALL_L: begin
        if(it.ground[i]) begin
          if(count > 20) next = SPLAT;
          else next = LEFT;
        end
        else next = FALL_L;
      end
      FALL_R: begin
        if(it.ground[i]) begin
          if(count > 20) next = SPLAT;
          else next = RIGHT;
        end 
        else next = FALL_R;
      end
      SPLAT: begin
        next = SPLAT;
      end
    endcase
  endtask: do_next

  task do_state(input state_t next, output state_t state);
    state = next;
  endtask: do_state

  task do_count(input state_t next, ref bit[7:0] count);
    if(next == FALL_L | next == FALL_R) count++;
    else count = 0;
  endtask: do_count

  task do_out(input int i, input state_t next, ref lemmings_slave_trans ot);
    case(next)
      LEFT:  {ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b1000;
      RIGHT: {ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b0100;
      DIG_L: {ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b0001;
      DIG_R: {ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b0001;
      FALL_L:{ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b0010;
      FALL_R:{ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b0010;
      SPLAT: {ot.walk_left[i],ot.walk_right[i],ot.aaah[i],ot.digging[i]} = 4'b0000;
    endcase
  endtask: do_out
endclass: lemmings_refmod

`endif