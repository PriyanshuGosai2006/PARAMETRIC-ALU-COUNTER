module counter_4bit (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       en,
    output logic [3:0] count
);

    // always_ff is strictly for sequential logic (Flip-Flops).
    // It tells the synthesis tool to expect a clock and a flip-flop structure.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000; // Non-blocking assignment (<=) for sequential logic
        end else if (en) begin
            count <= count + 1'b1;
        end
    end

endmodule
