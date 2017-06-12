# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -msgmgr_mode ooc_run
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.cache/wt [current_project]
set_property parent.project_path C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM.xci
set_property is_locked true [get_files C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM.xci]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

set cached_ip [config_ip_cache -export -no_bom -use_project_ipc -dir C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1 -new_name Top_level_BROM -ip [get_ips Top_level_BROM]]

if { $cached_ip eq {} } {

synth_design -top Top_level_BROM -part xc7a100tcsg324-1 -mode out_of_context

#---------------------------------------------------------
# Generate Checkpoint/Stub/Simulation Files For IP Cache
#---------------------------------------------------------
catch {
 write_checkpoint -force -noxdef -rename_prefix Top_level_BROM_ Top_level_BROM.dcp

 set ipCachedFiles {}
 write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Top_level_BROM_stub.v
 lappend ipCachedFiles Top_level_BROM_stub.v

 write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Top_level_BROM_stub.vhdl
 lappend ipCachedFiles Top_level_BROM_stub.vhdl

 write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Top_level_BROM_sim_netlist.v
 lappend ipCachedFiles Top_level_BROM_sim_netlist.v

 write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Top_level_BROM_sim_netlist.vhdl
 lappend ipCachedFiles Top_level_BROM_sim_netlist.vhdl

 config_ip_cache -add -dcp Top_level_BROM.dcp -move_files $ipCachedFiles -use_project_ipc -ip [get_ips Top_level_BROM]
}

rename_ref -prefix_all Top_level_BROM_

write_checkpoint -force -noxdef Top_level_BROM.dcp

catch { report_utilization -file Top_level_BROM_utilization_synth.rpt -pb Top_level_BROM_utilization_synth.pb }

if { [catch {
  file copy -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1/Top_level_BROM.dcp C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}


} else {


if { [catch {
  file copy -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1/Top_level_BROM.dcp C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  file rename -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1/Top_level_BROM_stub.v C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1/Top_level_BROM_stub.vhdl C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1/Top_level_BROM_sim_netlist.v C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.runs/Top_level_BROM_synth_1/Top_level_BROM_sim_netlist.vhdl C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

}; # end if cached_ip 

if {[file isdir C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.ip_user_files/ip/Top_level_BROM]} {
  catch { 
    file copy -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.v C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.ip_user_files/ip/Top_level_BROM
  }
}

if {[file isdir C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.ip_user_files/ip/Top_level_BROM]} {
  catch { 
    file copy -force C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.vhdl C:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.ip_user_files/ip/Top_level_BROM
  }
}
