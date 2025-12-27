module instr_mem (
    input  [63:0] addr,
    output [31:0] instr
);
    reg [31:0] mem [0:255];

    initial begin
        // Example program 
        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00a00113; // addi x2, x0, 10
        mem[2] = 32'h002081b3; // add x3, x1, x2
        mem[3] = 32'h00302023; // sw x3, 0(x0)
        mem[4] = 32'h00002203; // lw x4, 0(x0)
    end

    assign instr = mem[addr[9:2]]; // word-aligned
endmodule
