module instr_mem (
    input  [63:0] addr,
    output [31:0] instr
);
    reg [31:0] mem [0:255];

    initial begin
        mem[0]  = 32'h00700013; // addi x0, x0, 7
        mem[1]  = 32'h0F200A13; // addi x20, x0, 242
        mem[2]  = 32'h00400393; // addi x7, x0, 4
        mem[3]  = 32'h007A0533; // add x10, x20, x7
        mem[4]  = 32'h01456E33; // or x28, x10, x20
        mem[5]  = 32'h007E1F33; // sll x30, x28, x7
        mem[6]  = 32'h41EF0333; // sub x6, x30, x30
        mem[7]  = 32'h07e03823; // sd x30, 112(x0)
        mem[8]  = 32'h07003283; // ld x5, 112(x0)
        mem[9]  = 32'h001F0813; // addi x16, x30, 1
        mem[10] = 32'h01028663; // beq x5, x16, L1 
        mem[11] = 32'h001f0213; // addi x4, x30, 1
        mem[12] = 32'h00000463; // beq x0, x0, END
        mem[13] = 32'h01f00213; // L1: addi x4, x0, 3
        mem[14] = 32'h00000013; // END: addi x0, x0, 0
    end

    assign instr = mem[addr[9:2]]; 
endmodule