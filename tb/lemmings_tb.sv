`ifndef LEMMINGS_TB_SV
`define LEMMINGS_TB_SV

module lemmings_tb;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import lemmings_pkg::*;

  lemmings_if intf();

  top_module dut(
    .areset(intf.rstn),
    .clk(intf.clk),
    .bump_left(intf.bump_left),
    .bump_right(intf.bump_right),
    .ground(intf.ground),
    .dig(intf.dig),
    .walk_left(intf.walk_left),
    .walk_right(intf.walk_right),
    .aaah(intf.aaah),
    .digging(intf.digging)
  );

  initial begin
    uvm_config_db#(virtual lemmings_if)::set(uvm_root::get(), "uvm_test_top.env.*", "vif", intf);
    run_test();
  end

endmodule

`endif