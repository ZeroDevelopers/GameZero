vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../GameZero.srcs/sources_1/ip/BRAM_VGA_Clock" "+incdir+../../../../GameZero.srcs/sources_1/ip/BRAM_VGA_Clock" \
"C:/.Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/.Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../GameZero.srcs/sources_1/ip/BRAM_VGA_Clock/BRAM_VGA_Clock_sim_netlist.vhdl" \


vlog -work xil_defaultlib "glbl.v"

