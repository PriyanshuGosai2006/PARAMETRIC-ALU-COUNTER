// File: top_datapath.sv
// Module: top_datapath
// Description: Structural top-level wrapper integrating FSM, Counter, and ALU.

module top_datapath (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    output logic       valid_out,
    output logic [3:0] alu_result
);

    // ---------------------------------------------------------
    // INTERNAL WIRES (The traces on your silicon PCB)
    // ---------------------------------------------------------
    logic       net_cnt_en;
    logic [2:0] net_alu_op;
    logic [3:0] net_count_val;

    // ---------------------------------------------------------
    // COMPONENT 1: The Control Unit (The Brain)
    // ---------------------------------------------------------
    control_fsm u_control_unit (
        .clk       (clk),
        .rst       (rst),
        .start     (start),
        .cnt_en    (net_cnt_en),
        .alu_op    (net_alu_op),
        .valid_out (valid_out)
    );

    // ---------------------------------------------------------
    // COMPONENT 2: Phase 1 Counter (The Data Source)
    // ---------------------------------------------------------
    counter_4bit u_counter (
        .clk       (clk),
        .rst_n     (~rst),             // INVERTED: Top level active-high to counter active-low
        .en        (net_cnt_en),       // Driven by FSM
        .count     (net_count_val)     // Feeds into the ALU
    );

    // ---------------------------------------------------------
    // COMPONENT 3: Phase 1 ALU (The Math Engine)
    // ---------------------------------------------------------
    alu #( .WIDTH(4) ) u_alu (         // OVERRIDE: Force 8-bit default to 4-bit datapath
        .a         (net_count_val),    // Input A gets the changing counter value
        .b         (4'd5),             // Input B is hardcoded to decimal 5
        .opcode    (net_alu_op),       // Driven by FSM
        .result    (alu_result),       // Routes out to the top level
        .zero      ()                  // UNCONNECTED: Suppress synthesis warnings
    );

endmodule
