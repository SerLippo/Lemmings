`ifndef LEMMINGS_MASTER_SEQUENCE_SV
`define LEMMINGS_MASTER_SEQUENCE_SV

class lemmings_master_sequence extends uvm_sequence#(lemmings_master_trans);
  rand int size;

  `uvm_object_utils_begin(lemmings_master_sequence)
    `uvm_field_int(size, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "lemmings_master_sequence");
    super.new(name);
  endfunction: new

  task body();
    this.send_trans();
  endtask: body

  task send_trans();
    `uvm_do_with(req, {
      size == local::size;
      foreach(bump_left[i]) bump_left[i] dist {1:/3, 0:/97};
      foreach(bump_right[i]) bump_right[i] dist {1:/3, 0:/97};
      foreach(ground[i]) ground[i] dist {1:/60, 0:/40};
      foreach(dig[i]) dig[i] dist {1:/40, 0:/60};
    })
    `uvm_info("MST_SEQ", req.sprint(), UVM_HIGH)
    get_response(rsp);
    assert(rsp.rsp)
    else
      `uvm_error("MST_SEQ", $sformatf("%0t, error rsp received!", $time))
  endtask: send_trans

  function void post_randomize();
    string s;
    s = {s, "AFTER RANDOMIZATION \n"};
    s = {s, "=======================================\n"};
    s = {s, "master_sequence object content is as below: \n"};
    s = {s, super.sprint()};
    s = {s, "=======================================\n"};
    `uvm_info("MST_SEQ", s, UVM_HIGH)
  endfunction: post_randomize

endclass: lemmings_master_sequence

`endif