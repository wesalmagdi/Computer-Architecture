module MEM_WB (
  input wire clk, rst,
  input wire [1:0] WB_in,

  input wire [63:0] MEM_ReadData, MEM_ALURes,

  output reg [1:0] WB_out,
  output reg [63:0] WB_ReadData, WB_ALURes_out
);
  always @(posedge clk) begin
    if (rst) begin
      WB_out <= 2'b0;
      WB_ReadData <= 64'b0;
      WB_ALURes_out <= 64'b0;
    end else begin
      WB_out <= WB_in;
      WB_ReadData <= MEM_ReadData;
      WB_ALURes_out <= MEM_ALURes;
    end
   end
endmodule