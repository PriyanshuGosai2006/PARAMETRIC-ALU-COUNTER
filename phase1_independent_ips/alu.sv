module alu #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       opcode,
    output logic [WIDTH-1:0] result,
    output logic             zero
);

    // always_comb is strictly for combinational logic.
    // It automatically infers the sensitivity list and flags an error if you accidentally create a latch.
    always_comb begin
        result = '0; // Default assignment to prevent inferred latches. Fill with all zeros.
        
        unique case (opcode) // 'unique' tells synthesis that conditions are mutually exclusive
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            default: result = '0;
        endcase
    end

    always_comb begin
        zero = (result == '0); // Blocking assignment (=) for combinational logic
    end

endmodule
