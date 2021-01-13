# operating conditions and boundary conditions #
# read_file MIPS_CPU.v
read_file {../define ../} -autoread -recursive -format verilog -top MIPS_CPU

current_design MIPS_CPU

create_clock "clk" -period 5 -waveform {}
set_fix_hold [get_clocks clk]
set_dont_touch_network   [get_clocks clk]

set_operating_conditions  -max slow -max_library slow -min fast -min_library fast
set_driving_cell -library slow -lib_cell DFFX2 -dont_scale-no_design_rule [all_inputs]
set_load [load_of "slow/DFFX2/D"] [all_inputs]

set_input_delay  -max 1      -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay  -min 0.2    -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max 1      -clock clk [all_outputs] 
set_output_delay -min 0.1    -clock clk [all_outputs] 

set_fix_multiple_port_nets -all -constants -buffer_constants [get_designs *]
change_names -rules verilog -hierarchy

set_wire_load_model -name tsmc18_wl10 -library slow                        

set_max_area  3000

compile


write -format verilog -hierarchy -output ../syn/traffic_light_syn.v
write_sdf -version 1.0 -context verilog ../syn/MIPS_CPU_syn.sdf


