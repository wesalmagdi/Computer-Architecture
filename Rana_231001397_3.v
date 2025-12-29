module RegisterFile(
    input wire clk,
    input wire we,                   // write enable
    input wire [4:0] rs1, rs2, rd,  // register addresses
    input wire [63:0] wd,            // write data
    output wire [63:0] rd1, rd2      // read data
);

    reg [63:0] regs [31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 64'b0;
    end

    // Asynchronous read
    assign rd1 = (rs1 == 0) ? 64'd0 : regs[rs1];
    assign rd2 = (rs2 == 0) ? 64'd0 : regs[rs2];

    // Synchronous write
    always @(posedge clk) begin
        if (we && rd != 0)
            regs[rd] <= wd;
    end

endmodule
