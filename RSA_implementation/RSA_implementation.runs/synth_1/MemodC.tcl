# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a50tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/student/Documents/RSA_encryption/RSA_encryption.cache/wt [current_project]
set_property parent.project_path C:/Users/student/Documents/RSA_encryption/RSA_encryption.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/student/Documents/RSA_encryption/RSA_encryption.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/student/Documents/RSA_encryption/RSA_encryption.srcs/sources_1/new/ABmodN.vhd
  C:/Users/student/Documents/RSA_encryption/RSA_encryption.srcs/sources_1/new/MemodC.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/student/Documents/RSA_encryption/RSA_encryption.srcs/constrs_1/new/clock.xdc
set_property used_in_implementation false [get_files C:/Users/student/Documents/RSA_encryption/RSA_encryption.srcs/constrs_1/new/clock.xdc]


synth_design -top MemodC -part xc7a50tcsg324-1


write_checkpoint -force -noxdef MemodC.dcp

catch { report_utilization -file MemodC_utilization_synth.rpt -pb MemodC_utilization_synth.pb }