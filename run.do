# File: run.do
# Description: Questa automation script for Phase 2 Integration

# 1. Create the working library
vlib work

# 2. Compile all Phase 2 SystemVerilog files
# (Order matters: compile IP blocks and FSM first, then Wrapper, then Testbench)
vlog alu.sv counter_4bit.sv control_fsm.sv top_datapath.sv tb_top.sv

# 3. Launch the simulator with optimization disabled (+acc) so we can see internal signals
vsim -voptargs=+acc work.tb_top

# 4. Automatically add all Top-Level wrapper signals to the Wave window
add wave -position insertpoint sim:/tb_top/dut/*

# 5. Run the simulation until the $finish command is hit in the testbench
run -all