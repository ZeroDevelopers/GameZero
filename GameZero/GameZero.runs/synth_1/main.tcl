# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.xpr} [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo {c:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/bram_init.coe}}
add_files {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Brom_util_init.coe}}
add_files -quiet {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/playerBROM/playerBROM.dcp}}
set_property used_in_implementation false [get_files {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/playerBROM/playerBROM.dcp}}]
add_files -quiet {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/utilBROM/utilBROM.dcp}}
set_property used_in_implementation false [get_files {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/utilBROM/utilBROM.dcp}}]
add_files -quiet {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/pixelClkGen_1/pixelClkGen.dcp}}
set_property used_in_implementation false [get_files {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/pixelClkGen_1/pixelClkGen.dcp}}]
read_vhdl -library xil_defaultlib {
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/vga.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/graphic.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Wolvie_attack.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Wolverine_movement.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Wolvie_jump.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Green_Goblin_attack.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Green_Goblin_movement.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/Green_Goblin_jump.vhd}
  {C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/new/main.vhd}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/constrs_1/Nexys4_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Andrea Diecidue/Documents/GitHub/GameZero/GameZero/GameZero.srcs/constrs_1/Nexys4_Master.xdc}}]


synth_design -top main -part xc7a100tcsg324-1


write_checkpoint -force -noxdef main.dcp

catch { report_utilization -file main_utilization_synth.rpt -pb main_utilization_synth.pb }
