
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Experimento2 -dir "/home/kenneth/temp_2014-08-27/LaboDigi/Experimento2/planAhead_run_2" -part xc3s500efg320-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "MiniAlu.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {RAM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Module_ROM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Collaterals.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {MiniAlu.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top MiniAlu $srcset
add_files [list {MiniAlu.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500efg320-4
