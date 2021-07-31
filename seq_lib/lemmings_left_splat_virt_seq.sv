`ifndef LEMMINGS_LEFT_SPLAT_VIRT_SEQ_SV
`define LEMMINGS_LEFT_SPLAT_VIRT_SEQ_SV

class lemmings_left_splat_virt_seq extends lemmings_base_virtual_sequence;
  lemmings_master_trans mst_trans;

  `uvm_object_utils(lemmings_left_splat_virt_seq)

  function new(string name = "lemmings_left_splat_virt_seq");
    super.new(name);
  endfunction: new

  task do_mst_seq();
    `uvm_do_on_with(mst_trans, p_sequencer.mst_sqr, {
      size == 30;
      bump_left[0] == 0;
      bump_right[0] == 1;
      ground[0] == 1;
      dig[0] == 0;
      ground[1] == 1;
      ground[2] == 1;
      dig[2] == 0;
      ground[3] == 1;
      dig[3] == 0;
      ground[4] == 1;
      dig[4] == 0;
      ground[5] == 1;
      dig[5] == 0;
      ground[6] == 1;
      dig[6] == 0;
      bump_left[7] == 0;
      bump_right[7] == 1;
      ground[7] == 1;
      dig[7] == 0;
      ground[8] == 0;
      ground[9] == 0;
      ground[10] == 0;
      ground[11] == 0;
      ground[12] == 0;
      ground[13] == 0;
      ground[14] == 0;
      ground[15] == 0;
      ground[16] == 0;
      ground[17] == 0;
      ground[18] == 0;
      ground[19] == 0;
      ground[20] == 0;
      ground[21] == 0;
      ground[22] == 0;
      ground[23] == 0;
      ground[24] == 0;
      ground[25] == 0;
      ground[26] == 0;
      ground[27] == 0;
      ground[28] == 0;
      ground[29] == 1;
    })
    #1ns;
  endtask: do_mst_seq
endclass: lemmings_left_splat_virt_seq

`endif