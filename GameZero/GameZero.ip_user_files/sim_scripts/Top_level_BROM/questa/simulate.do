onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Top_level_BROM_opt

do {wave.do}

view wave
view structure
view signals

do {Top_level_BROM.udo}

run -all

quit -force
