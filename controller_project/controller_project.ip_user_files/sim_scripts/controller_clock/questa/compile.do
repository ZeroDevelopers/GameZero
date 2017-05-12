vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"../../../../controller_project.srcs/sources_1/ip/controller_clock/controller_clock_sim_netlist.vhdl" \


