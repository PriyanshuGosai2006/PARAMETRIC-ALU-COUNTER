# Parametric ALU & 4-bit Counter IP

## Project Overview
This repository contains the RTL design, functional verification, and physical synthesis of two foundational digital IP blocks: a Parametric Arithmetic Logic Unit (ALU) (Combinational) and a 4-bit Synchronous Counter (Sequential). 

The objective of this is to establish a rigorous, industry-standard EDA workflow from RTL concept to hardware synthesis.

## Toolchain
* RTL Implementation: SystemVerilog (`logic`, `always_comb`, `always_ff`)
* Functional Verification (Simulation): Questa Intel FPGA Starter Edition
* Hardware Synthesis: AMD Vivado 2026.1
* Target Architecture: Xilinx Artix-7 (`xc7a35tcpg236-1`)



## Functional Verification (Questa)
(Demonstrates 100% correct mathematical output across all opcodes, clean clock-edge transitions, and synchronous reset functionality)

<img width="1448" height="697" alt="waveform" src="https://github.com/user-attachments/assets/13dad0fb-0a3b-4c38-9eb5-1826cc04d5b4" />




## Hardware Synthesis (Vivado)

### 1. The Parametric ALU (Combinational IP)
A purely combinational logic block capable of standard arithmetic and bitwise operations. Designed using modern `always_comb` constructs to prevent unintended latch inference.

(Synthesized strictly to Look-Up Tables with 0 inferred memory)
* Slice LUTs: 40
* Slice Registers: 0 (Purely Combinational)

Extracted Netlist Schematic:

<img width="1341" height="857" alt="schematic_alu" src="https://github.com/user-attachments/assets/62b06442-4919-4cfd-8053-d34a76180113" />

### 2. The 4-bit Synchronous Counter (Sequential IP)
A clock-driven sequential block demonstrating state memory and synchronous reset behavior using `always_ff` constructs.

(Successfully mapped to physical flip-flops on the Artix-7 fabric)
* Slice LUTs: 3
* Slice Registers: 4

Extracted Netlist Schematic:

<img width="1895" height="622" alt="schematic_counter" src="https://github.com/user-attachments/assets/a9bab774-cc33-41b1-ad65-6c6e03404507" />

---

## How to Run the Simulation
1. Clone the repository.
2. Open Questa/ModelSim.
3. Change directory to the `sim` folder.
4. Execute `do run.do` to compile the `.sv` files and launch the waveform viewer.
