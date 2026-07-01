# System-on-Chip (SoC) Data Processing Unit

##  Project Overview
This repository contains a full RTL-to-Synthesis pipeline for a custom digital datapath. The project demonstrates the progression from designing isolated combinational/sequential Intellectual Property (IP) blocks to integrating them into a fully automated, timing-closed System-on-Chip (SoC) architecture.

The project is structured into two distinct phases to highlight modular design, automated Design Verification (DV), and physical synthesis constraints.

##  Toolchain
* **RTL Implementation:** SystemVerilog (IEEE 1800-2012)
* **Design Verification:** Questa Intel FPGA Starter Edition (Automated TCL Scripting)
* **Physical Synthesis & Timing:** AMD Vivado 2026.1
* **Target Architecture:** Xilinx Artix-7 (`xc7a35tcpg236-1`)



##  Architecture Breakdown

### [Phase 1: Independent IP Cores](./phase1_independent_ips)
See the Phase 1 Independent IPs folder for individual unit tests and schematic extractions.
* **Parametric ALU:** Purely combinational arithmetic unit mapped strictly to LUTs.
* **4-bit Synchronous Counter:** Sequential state memory mapped to physical flip-flops.

### [Phase 2: SoC Integration & FSM Control](./phase1_soc_integration)
The IP blocks from Phase 1 are instantiated into a unified Top-Level Wrapper and driven by a custom Moore Finite State Machine (FSM). 
* **The Control Unit:** The FSM cycles through `IDLE -> COUNT -> COMPUTE -> DONE`, actively managing the enable signals of the Counter and routing opcodes to the ALU.
* **Datapath Flow:** The Counter generates dynamic data, which is fed directly into the ALU alongside hardcoded constants for real-time mathematical processing.



##  Automated Design Verification (DV)

Instead of relying on visual waveform inspection, the integrated datapath is verified using a **Self-Checking Testbench**. 

The testbench automatically asserts the start condition, pauses execution using hardware-driven `wait()` statements until the FSM asserts `valid_out`, and algorithmically compares the ALU output against the expected mathematical result.

**Automated Transcript Log:**
(Demonstrates 0 errors and successful assertion passes)

<img width="565" height="412" alt="image" src="https://github.com/user-attachments/assets/c0280df6-5a91-4dbd-ae88-9877ef9fb6dc" />


**FSM State Execution Waveform:**
(Chronological display of state transitions: Fetching data, pushing opcodes, and raising the valid flag)

<img width="1272" height="292" alt="image" src="https://github.com/user-attachments/assets/da247f56-9031-4df0-a338-d85a6a1ab15b" />




##  Physical Synthesis & Timing Closure

The integrated RTL was synthesized and mapped to the Artix-7 physical fabric. To ensure real-world viability, a strict `.xdc` constraint was applied, commanding a **100 MHz System Clock** (10.000 ns period).

The architecture successfully passed Setup and Hold timing analysis with zero negative slack, proving the physical combinational logic paths are highly optimized.

* **Target Clock Frequency:** 100 MHz
* **Worst Negative Slack (WNS):** +8.295 ns
* **Maximum Theoretical Operating Frequency:** > 500 MHz

**Vivado Timing Summary Report:**

<img width="1030" height="222" alt="image" src="https://github.com/user-attachments/assets/515e5859-6a77-43e5-9844-f6ed8825bf4f" />




##  How to Reproduce the Verification Environment
This repository utilizes a scripted verification workflow. To run the automated testbench:
1. Clone the repository and open Questa/ModelSim.
2. Navigate to the `phase1_soc_integration` directory in the transcript terminal.
3. Execute the automation script:
   ```tcl
   do run.do
