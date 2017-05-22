vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../GameZero.srcs/sources_1/ip/BRAM_VGA_Clock" "+incdir+../../../../GameZero.srcs/sources_1/ip/BRAM_VGA_Clock" \
"C:/.Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/.Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../GameZero.srcs/sources_1/ip/BRAM_VGA_Clock/BRAM_VGA_Clock_sim_netlist.vhdl" \


vlog -work xil_defaultlib "glbl.v"

