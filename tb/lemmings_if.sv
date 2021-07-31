`ifndef LEMMINGS_IF_SV
`define LEMMINGS_IF_SV

interface lemmings_if;
	logic clk;
	logic rstn;
  logic bump_left;
  logic bump_right;
  logic ground;
  logic dig;
  logic walk_left;
  logic walk_right;
  logic aaah;
  logic digging;

  clocking drv_ck@(posedge clk);
    default input #1ps output #1ps;
    input walk_left, walk_right, aaah, digging;
    output bump_left, bump_right, ground, dig;
  endclocking: drv_ck

  clocking mon_ck@(posedge clk);
    default input #1ps output #1ps;
    input bump_left, bump_right, ground, dig, walk_left, walk_right, aaah, digging;
  endclocking: mon_ck

  initial begin
    clk <= 0;
    forever begin
      #5 clk <= !clk;
    end
  end
  
  initial begin
    #10;
    rstn <= 0;
    #100;
    rstn <= 1;
  end

endinterface: lemmings_if

`endif