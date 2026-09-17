###############################################################################
# Created by write_sdc
# Thu Sep 17 19:52:42 2026
###############################################################################
current_design pattern_detector
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_en}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_idx[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_idx[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_mask[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_pattern[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {cfg_we}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_valid}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {any_match}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pattern_match[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pattern_match[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pattern_match[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pattern_match[3]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {any_match}]
set_load -pin_load 0.0334 [get_ports {pattern_match[3]}]
set_load -pin_load 0.0334 [get_ports {pattern_match[2]}]
set_load -pin_load 0.0334 [get_ports {pattern_match[1]}]
set_load -pin_load 0.0334 [get_ports {pattern_match[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_en}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_we}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_valid}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_idx[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_idx[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_mask[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {cfg_pattern[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 10.0000 [current_design]
