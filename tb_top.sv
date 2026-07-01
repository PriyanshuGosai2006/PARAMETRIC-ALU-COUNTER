// File: tb_top.sv
// Module: tb_top
// Description: Automated Self-Checking Testbench for Phase 2 Integrated Datapath

`timescale 1ns / 1ps

module tb_top;

    // TB Signals
    logic       clk;
    logic       rst;
    logic       start;
    logic       valid_out;
    logic [3:0] alu_result;

    // Instantiate the Device Under Test (DUT)
    top_datapath dut (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .valid_out  (valid_out),
        .alu_result (alu_result)
    );

    // Clock Generation (100 MHz -> 10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5 nanoseconds
    end

    // Monitor Block: Print status whenever key signals change
    initial begin
        $monitor("[TIME: %0t ns] rst=%b | start=%b | valid_out=%b | alu_result=%0d", 
                 $time, rst, start, valid_out, alu_result);
    end

    // Main Stimulus and Self-Checking Process
    initial begin
        // 1. Initialize and Reset
        $display("\n==================================================");
        $display("--- PHASE 2: AUTOMATED DV TESTBENCH STARTING ---");
        $display("==================================================\n");
        
        rst   = 1;
        start = 0;
        
        // Wait for 2 clock cycles in reset to stabilize system
        repeat(2) @(posedge clk);
        
        // Release Reset
        @(posedge clk);
        rst = 0;
        $display("[SYSTEM] Reset released. System IDLE.");
        
        // 2. Pulse the Start Signal
        @(posedge clk);
        start = 1;
        $display("[SYSTEM] Start signal pulsed. FSM sequence triggered.");
        
        @(posedge clk);
        start = 0; // De-assert start immediately so it only runs once
        
        // 3. Automated Wait: Let the FSM cycle through its states
        // This is a DV construct; the testbench pauses here until the hardware signals it's done
        wait(valid_out == 1'b1);
        
        // 4. The Self-Checking Assertion
        $display("\n[DV CHECK] valid_out asserted by FSM. Checking result...");
        
        // We expect: Counter increments to 1, routes to ALU, adds hardcoded 5 = 6.
        if (alu_result == 4'd6) begin
            $display("[PASS] Expected Result: 6 | Actual Result: %0d", alu_result);
            $display("       ALU successfully computed (Counter[1] + Hardcoded B[5])");
        end else begin
            $display("[FAIL] Expected Result: 6 | Actual Result: %0d", alu_result);
            $display("       Architecture error detected in datapath!");
        end
        
        $display("\n==================================================");
        $display("--- TEST COMPLETE ---");
        $display("==================================================\n");
        
        // Stop simulation gracefully
        $finish;
    end

endmodule