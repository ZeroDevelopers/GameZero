onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Wolvie_BROM_opt

do {wave.do}

view wave
view structure
view signals

do {Wolvie_BROM.udo}

run -all

quit -force
