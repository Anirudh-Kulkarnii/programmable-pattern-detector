### 2. Run Post-Layout Gate-Level Simulation (GLS)
Validates the synthesized gate-level netlist against Sky130 technology library primitives with power pins and unit delays:
```bash
iverilog -g2012 -DFUNCTIONAL -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
  -o sim_gls \
  ~/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
  ~/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
  openlane/pattern_detector/runs/hardening_run/results/synthesis/pattern_detector.v \
  tb/tb_pattern_detector_gls.v
vvp sim_gls

