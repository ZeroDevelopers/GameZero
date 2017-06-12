// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Mon Jun 12 10:45:35 2017
// Host        : DESKTOP-PK5D2H9 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top Top_level_BROM -prefix
//               Top_level_BROM_ Top_level_BROM_stub.v
// Design      : Top_level_BROM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_5,Vivado 2016.4" *)
module Top_level_BROM(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[17:0],douta[11:0]" */;
  input clka;
  input [17:0]addra;
  output [11:0]douta;
endmodule