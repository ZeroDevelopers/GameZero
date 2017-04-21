// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Fri Apr 21 21:55:31 2017
// Host        : DESKTOP-V9D0PGF running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Andrea Diecidue/Desktop/polito/Computer
//               Architecture/Projects/vga/vga.srcs/sources_1/ip/PixelClkGen/PixelClkGen_stub.v}
// Design      : PixelClkGen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module PixelClkGen(clk_out1, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,locked,clk_in1" */;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
