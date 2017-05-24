onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BROM_Pedana_opt

do {wave.do}

view wave
view structure
view signals

do {BROM_Pedana.udo}

run -all

quit -force
