module EX_MEM (
  input wire clk, rst,
  
  input wire [1:0] WB_in, M_in,
  
  input wire [63:0] EX_BranchTarget, EX_ALURes, EX_ReadData2,
  
  input wire EX_Zero,
    
  output reg [1:0] WB_out, M_out,
  output reg [63:0] MEM_BranchTarget, MEM_ALURes, MEM_ReadData2,
  output reg MEM_Zero
);
  always @(posedge clk) begin
    if (rst) begin
      WB_out <= 4'b0;
      M_out <= 4'b0;
      MEM_BranchTarget <= 64'b0;
      MEM_ALURes <= 64'b0;
      MEM_ReadData2 <= 64'b0; 
      MEM_Zero <= 1'b0;
    end else begin
      WB_out <= WB_in;
      M_out  <= M_in;
      MEM_BranchTarget <= EX_BranchTarget;
      MEM_ALURes <= EX_ALURes;
      MEM_ReadData2 <= EX_ReadData2;
      MEM_Zero <= EX_Zero;
    end
   end
endmodule