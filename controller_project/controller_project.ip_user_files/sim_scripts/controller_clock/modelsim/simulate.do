onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.controller_clock

do {wave.do}

view wave
view structure
view signals

do {controller_clock.udo}

run -all

quit -force
