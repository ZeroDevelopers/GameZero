onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib PixelClkGen_opt

do {wave.do}

view wave
view structure
view signals

do {PixelClkGen.udo}

run -all

quit -force
