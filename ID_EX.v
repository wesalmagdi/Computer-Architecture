module ID_EX (
    input wire clk, rst,
  
    input wire [1:0] WB_in, M_in, EX_in,
  
    input wire [63:0] ID_PC, ID_ReadData1, ID_ReadData2, ID_Imm,
    
    output reg [1:0] WB_out, M_out, EX_out,
  
    output reg [63:0] EX_PC, EX_ReadData1, EX_ReadData2, EX_Imm
);
    always @(posedge clk) begin
      if (rst) begin
        M_out <= 6'b0;
        EX_out <= 6'b0;
        WB_out <= 6'b0;
        EX_PC <= 64'b0;
        EX_ReadData1 <= 64'b0;
        EX_ReadData2 <= 64'b0;
        EX_Imm <= 64'b0;
      end else begin
        WB_out <= WB_in;
        M_out  <= M_in;
        EX_out <= EX_in;
        EX_PC <= ID_PC;
        EX_ReadData1 <= ID_ReadData1;
        EX_ReadData2 <= ID_ReadData2;
        EX_Imm <= ID_Imm;
      end
    end
endmodule