`ifndef LEMMINGS_SLAVE_TRANS_SV
`define LEMMINGS_SLAVE_TRANS_SV

class lemmings_slave_trans extends uvm_sequence_item;
  bit walk_left[];
  bit walk_right[];
  bit aaah[];
  bit digging[];
  int size;

  `uvm_object_utils_begin(lemmings_slave_trans)
    `uvm_field_array_int(walk_left, UVM_ALL_ON)
    `uvm_field_array_int(walk_right, UVM_ALL_ON)
    `uvm_field_array_int(aaah, UVM_ALL_ON)
    `uvm_field_array_int(digging, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "lemmings_slave_trans");
    super.new(name);
  endfunction: new

endclass: lemmings_slave_trans

`endif