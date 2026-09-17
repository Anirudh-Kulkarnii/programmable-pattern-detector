# Sky130 Programmable Pattern Detector ASIC

[![PDK](https://img.shields.io/badge/PDK-SkyWater%20130nm-orange)](https://github.com/google/skywater-pdk)
[![Flow](https://img.shields.io/badge/Flow-OpenLane%20%2F%20OpenROAD-green)](https://github.com/The-OpenROAD-Project/OpenLane)
[![Signoff](https://img.shields.io/badge/Signoff-DRC%20%7C%20LVS%20Clean-brightgreen)](#4-physical-signoff-drc--lvs)
[![Timing](https://img.shields.io/badge/Timing-100MHz%20Met%20(WNS%3A%200.00ns)-blue)](#key-signoff-metrics)

An end-to-end digital ASIC design and physical implementation of a **Runtime-Programmable Bitstream Pattern Detector**, implemented in synthesizable Verilog HDL and hardened down to GDSII on the **SkyWater 130nm (`sky130_fd_sc_hd`)** open-source process node using OpenLane and OpenROAD.

---

## 1. What This Design Does

Pattern detectors are fundamental building blocks in serial communication protocols (frame synchronization, packet preamble detection, delimiter decoding). 

Typical hardware detectors use fixed-wire sequence logic. This core adds **runtime reconfigurability**:
* **Sliding Window Matching:** Scans a continuous serial input stream bit-by-bit with zero wait cycles.
* **Dynamic Reprogramming:** Allows host logic to rewrite the target matching sequence on-the-fly without resetting internal detector state.
* **Overlapping Match Detection:** Reliably detects repeating, overlapping signatures (e.g., finding all instances of `1010` in a stream of `101010`).
* **Synchronous Output Pulse:** Asserts a single-cycle flag whenever a sliding-window match occurs.

### Hardware Architecture
Elaborated using Yosys to verify register transfer logic, multiplexer trees, and comparator arrays before mapping to standard cells:

<p align="center">
  <img src="assets/schematic.png" alt="Yosys Architecture Schematic" width="90%"/>
  <br>
  <em>Figure 1: Elaborated gate-level schematic showing internal shift register chain, pattern registers, and comparator logic.</em>
</p>

---

## 2. Key Signoff Metrics

The design was fully hardened through placement, clock tree synthesis (CTS), routing, and physical verification with zero violations at 100 MHz:

| Signoff Metric | Value | Constraint / Target | Outcome |
| :--- | :--- | :--- | :--- |
| **Clock Frequency** | **100 MHz** ($T_{clk} = 10.0\text{ ns}$) | $100\text{ MHz}$ | **Target Met** |
| **Setup Slack (WNS)** | **$0.00\text{ ns}$** | $\ge 0.00\text{ ns}$ | **Zero Setup Violations** |
| **Hold Slack (WHS)** | **$0.00\text{ ns}$** | $\ge 0.00\text{ ns}$ | **Zero Hold Violations** |
| **Design Rule Check (DRC)** | **0 errors** (`COUNT: 0`) | Magic Clean | **Tapeout Ready** |
| **Layout vs. Schematic (LVS)**| **Net & Device Match** | Netgen Clean | **Topologically Equivalent** |
| **Antenna Violations** | **0 pins** | 0 Violations | **No Diode Violations** |
| **Post-Layout Gate Simulation**| **Passed** (Unit Delay) | Match RTL output | **Timing & Logic Verified** |

---

## 3. Implementation Flow & Evidence

### Step 1: Functional RTL Verification
Before logic synthesis, behavioral correctness was verified using Icarus Verilog and inspected via GTKWave. Test cases covered sequence reloads, sliding window assertions, and overlapping detection flags.

<p align="center">
  <img src="assets/waveform_sim.png" alt="GTKWave Behavioral Waveform" width="90%"/>
  <br>
  <em>Figure 2: Pre-synthesis waveform demonstrating continuous pattern tracking and single-cycle match assertions.</em>
</p>

### Step 2: Floorplan, Placement, and Power Grid
Floorplanned with targeted core utilization to balance standard-cell density against routing resources. Power rings (`VDD`/`VSS`) and strap meshes across higher metal layers (Met4/Met5) ensure low IR drop across all standard cell rows.

<p align="center">
  <img src="assets/openroad_floorplan.png" alt="OpenROAD Floorplan & Standard Cell Placement" width="90%"/>
  <br>
  <em>Figure 3: OpenROAD core view displaying standard-cell row assignments, I/O pin placements, and power distribution network (PDN).</em>
</p>

### Step 3: Global Routing & Congestion Heatmap
Global routing evaluated through FastRoute verified that wire channel demand remained well below capacity. Zero routing overflow was encountered across all routing layers.

<p align="center">
  <img src="assets/routing_congestion.png" alt="OpenROAD Routing Congestion Heatmap" width="90%"/>
  <br>
  <em>Figure 4: Congestion heatmap showing uniform routing resource distribution with zero congested channels.</em>
</p>

### Step 4: Silicon Signoff Layout (GDSII)
The final tapeout mask was inspected in KLayout after global/detailed routing, clock tree synthesis (CTS), antenna diode insertion, and physical verification signoff (Magic DRC and Netgen LVS).

<p align="center">
  <img src="assets/layout_gds.png" alt="Final KLayout GDS Layout" width="90%"/>
  <br>
  <em>Figure 5: Full chip silicon layout generated for Sky130 high-density standard cells.</em>
</p>

---

## 4. Repository Structure

```text
├── assets/                                 # Verification waveforms, floorplan captures, and GDS renders
│   ├── layout_gds.png                      # KLayout full die render
│   ├── openroad_floorplan.png              # OpenROAD placement & PDN
│   ├── routing_congestion.png              # FastRoute congestion heatmap
│   ├── schematic.png                       # Yosys gate-level architecture
│   └── waveform_sim.png                    # GTKWave simulation trace
├── openlane/
│   └── pattern_detector/
│       ├── config.json                     # OpenLane synthesis, clock, and floorplan configuration
│       └── runs/hardening_run/results/     # Tapeout artifacts: final GDSII, DEF, SPEF, and netlists
├── rtl/
│   └── pattern_detector.v                  # Synthesizable RTL source
├── tb/
│   ├── tb_pattern_detector.v               # Pre-synthesis behavioral testbench
│   └── tb_pattern_detector_gls.v           # Post-layout gate-level simulation (GLS) testbench
├── .gitignore                              # Transient synthesis ignore rules
└── README.md                               # Project documentation & signoff report
