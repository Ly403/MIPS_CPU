# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_param simulator.modelsimInstallPath D:/digital_logic/modelsim_10.4c/_modelsim/win32
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/digital_logic/project/CPU54/CPU54.cache/wt [current_project]
set_property parent.project_path D:/digital_logic/project/CPU54/CPU54.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property include_dirs D:/digital_logic/project/CPU54 [current_fileset]
read_ip -quiet D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci
set_property is_locked true [get_files D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top imem -part xc7a100tcsg324-1 -mode out_of_context

rename_ref -prefix_all imem_

write_checkpoint -force -noxdef imem.dcp

catch { report_utilization -file imem_utilization_synth.rpt -pb imem_utilization_synth.pb }

if { [catch {
  write_verilog -force -mode synth_stub D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

add_files D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_stub.v -of_objects [get_files D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci]

add_files D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_stub.vhdl -of_objects [get_files D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci]

add_files D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_sim_netlist.v -of_objects [get_files D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci]

add_files D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_sim_netlist.vhdl -of_objects [get_files D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci]

add_files D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem.dcp -of_objects [get_files D:/digital_logic/project/CPU54/CPU54.srcs/sources_1/ip/imem/imem.xci]

if {[file isdir D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem]} {
  catch { 
    file copy -force D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_sim_netlist.v D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem
  }
}

if {[file isdir D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem]} {
  catch { 
    file copy -force D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_sim_netlist.vhdl D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem
  }
}

if {[file isdir D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem]} {
  catch { 
    file copy -force D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_stub.v D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem
  }
}

if {[file isdir D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem]} {
  catch { 
    file copy -force D:/digital_logic/project/CPU54/CPU54.runs/imem_synth_1/imem_stub.vhdl D:/digital_logic/project/CPU54/CPU54.ip_user_files/ip/imem
  }
}
