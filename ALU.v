module ALU(
    input [63:0] A,          // First operand
    input [63:0] B,          // Second operand
    input [3:0] ALUControl,  // Control signal (Operation Select)
    output reg [63:0] Result, // ALU result
    output Zero              // High if Result is zero (for branch)
    );

    // The Zero flag is essential for the 'beq' instruction logic
    assign Zero = (Result == 64'b0);

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;        // AND
            4'b0001: Result = A | B;        // OR
            4'b0010: Result = A + B;        // ADD (for add, addi, ld, sd)
            4'b0110: Result = A - B;        // SUB (for sub, beq)
            4'b0100: Result = A ^ B;        // XOR
            4'b1000: Result = A << B[5:0];  // SLL (Shift Left Logical)
            4'b1001: Result = A >> B[5:0];  // SRL (Shift Right Logical)
            default: Result = 64'b0;        // Default case to avoid latches
        endcase
    end

endmodule