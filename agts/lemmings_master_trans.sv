`ifndef LEMMINGS_MASTER_TRANS_SV
`define LEMMINGS_MASTER_TRANS_SV

class lemmings_master_trans extends uvm_sequence_item;
  rand bit bump_left[];
  rand bit bump_right[];
  rand bit ground[];
  rand bit dig[];
  rand int size;
  bit rsp;

  `uvm_object_utils_begin(lemmings_master_trans)
    `uvm_field_array_int(bump_left, UVM_ALL_ON)
    `uvm_field_array_int(bump_right, UVM_ALL_ON)
    `uvm_field_array_int(ground, UVM_ALL_ON)
    `uvm_field_array_int(dig, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint cstr{
    bump_left.size() == size;
    bump_right.size() == size;
    ground.size() == size;
    dig.size() == size;
  }

  function new(string name = "lemmings_master_trans.sv");
    super.new(name);
  endfunction: new

endclass: lemmings_master_trans

`endif