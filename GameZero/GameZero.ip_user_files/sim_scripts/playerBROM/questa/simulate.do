onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib playerBROM_opt

do {wave.do}

view wave
view structure
view signals

do {playerBROM.udo}

run -all

quit -force
