onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+controller_clock -L xil_defaultlib -L secureip -O5 xil_defaultlib.controller_clock

do {wave.do}

view wave
view structure

do {controller_clock.udo}

run -all

endsim

quit -force
