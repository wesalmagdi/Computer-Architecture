module IF_ID (
  input wire clk,rst,
  input wire [31:0] IF_instr,
  input wire [63:0] IF_PC,
  output reg [31:0] ID_instr
  output reg [63:0] ID_PC
);
  always @(posedge clk) begin 
    if(rst) begin
      ID_instr <= 32'b0;
      ID_PC <= 64'b0;
    end
    else begin
      ID_instr<=IF_instr;
      ID_PC <=IF_PC;
    end
  end
endmodule