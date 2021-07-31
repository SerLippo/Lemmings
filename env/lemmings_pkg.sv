`ifndef LEMMINGS_PKG_SV
`define LEMMINGS_PKG_SV

package lemmings_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "lemmings_define.sv"
  `include "lemmings_master_trans.sv"
  `include "lemmings_master_sequencer.sv"
  `include "lemmings_master_driver.sv"
  `include "lemmings_master_monitor.sv"
  `include "lemmings_master_agent.sv"
  `include "lemmings_slave_trans.sv"
  `include "lemmings_slave_monitor.sv"
  `include "lemmings_slave_agent.sv"

  `include "lemmings_refmod.sv"
  `include "lemmings_scoreboard.sv"
  `include "lemmings_virtual_sequencer.sv"
  `include "lemmings_env.sv"
  `include "lemmings_sequences.svh"
  `include "lemmings_tests.svh"

endpackage: lemmings_pkg

`endif