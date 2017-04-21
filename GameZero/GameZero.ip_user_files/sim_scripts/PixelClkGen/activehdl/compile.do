vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../vga.srcs/sources_1/ip/PixelClkGen" "+incdir+../../../../vga.srcs/sources_1/ip/PixelClkGen" \
"C:/.Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/.Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../vga.srcs/sources_1/ip/PixelClkGen/PixelClkGen_sim_netlist.vhdl" \


vlog -work xil_defaultlib "glbl.v"

