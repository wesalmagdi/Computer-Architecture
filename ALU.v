module ALU(
    input [63:0] A,
    input [63:0] B,
    input [3:0] ALUControl,
    output reg [63:0] Result,
    output Zero
    );

    assign Zero = (Result == 64'b0);

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;
            4'b0001: Result = A | B;
            4'b0010: Result = A + B;
            4'b0011: Result = A - B;           
            4'b0100: Result = A ^ B;
            4'b0101: Result = A << B[5:0];    
            4'b0111: Result = A >> B[5:0];     
            4'b0110: Result = $signed(A) >>> B[5:0]; 
            default: Result = 64'b0;
        endcase
    end
endmodule