onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib utilBROM_opt

do {wave.do}

view wave
view structure
view signals

do {utilBROM.udo}

run -all

quit -force
