-makelib ies/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies/xpm \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../GameZero.srcs/sources_1/ip/pixelClkGen/pixelClkGen_clk_wiz.v" \
  "../../../../GameZero.srcs/sources_1/ip/pixelClkGen/pixelClkGen.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

