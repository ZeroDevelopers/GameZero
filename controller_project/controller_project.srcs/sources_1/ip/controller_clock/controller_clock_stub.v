// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Thu May 04 18:08:36 2017
// Host        : DESKTOP-V9D0PGF running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {C:/Users/Andrea Diecidue/Desktop/polito/Computer
//               Architecture/Projects/controller_project/controller_project.srcs/sources_1/ip/controller_clock/controller_clock_stub.v}
// Design      : controller_clock
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module controller_clock(clk_out1, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,reset,locked,clk_in1" */;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
