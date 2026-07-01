// File: control_fsm.sv
// Module: control_fsm
// Description: Moore FSM Control Unit for integrated ALU/Counter Datapath

module control_fsm (
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    output logic       cnt_en,
    output logic [2:0] alu_op,
    output logic       valid_out
);

    // Modern SystemVerilog enumerated type for state encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        COUNT   = 2'b01,
        COMPUTE = 2'b10,
        DONE    = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Sequential State Register Block (Synchronous Reset)
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational Next-State Logic Block
    always_comb begin
        // Default assignment to prevent latch inference
        next_state = current_state; 

        case (current_state)
            IDLE: begin
                if (start) begin
                    next_state = COUNT;
                end else begin
                    next_state = IDLE;
                end
            end
            
            COUNT: begin
                next_state = COMPUTE;
            end
            
            COMPUTE: begin
                next_state = DONE;
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Combinational Output Logic Block (Moore Outputs depend only on current state)
    always_comb begin
        // Set safe default values to guarantee no latches are synthesized
        cnt_en    = 1'b0;
        alu_op    = 3'b111; // Default to an idle/undefined opcode state
        valid_out = 1'b0;

        case (current_state)
            IDLE: begin
                // All outputs remain low/inactive
            end
            
            COUNT: begin
                cnt_en = 1'b1; // Turn on the counter for this clock cycle
            end
            
            COMPUTE: begin
                alu_op = 3'b000; // Force the ALU to execute an ADD operation
            end
            
            DONE: begin
                valid_out = 1'b1; // Announce to the outside world that data is valid
            end
            
            default: begin
                cnt_en    = 1'b0;
                alu_op    = 3'b111;
                valid_out = 1'b0;
            end
        endcase
    end

endmodule
