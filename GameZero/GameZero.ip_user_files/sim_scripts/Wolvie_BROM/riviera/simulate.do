onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Wolvie_BROM -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_5 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Wolvie_BROM xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Wolvie_BROM.udo}

run -all

endsim

quit -force
