module tb_immgen;
    reg [31:0] instr;
    wire [63:0] imm;

    // Instantiate Immediate Generator
    ImmGen ig(
        .instr(instr),
        .imm(imm)
    );

    initial begin
        $display("===== Immediate Generator Test =====");

        // I-type: addi x1, x0, -4
        instr = 32'b111111111100_00000_000_00001_0010011;
        #1 $display("I-type addi imm = %h", imm); // Expected: FFFFFFFFFFFFFFFC

        // I-type: andi x2, x3, 7
        instr = 32'b000000000111_00011_111_00010_0010011;
        #1 $display("I-type andi imm = %h", imm); // Expected: 7

        // S-type: sd x3, 8(x0)
        instr = 32'b0000000_00011_00000_011_01000_0100011;
        #1 $display("S-type sd imm = %h", imm); // Expected: 8

        // B-type: beq x1, x2, 16
        instr = 32'b0000000_00010_00001_000_10000_1100011;
        #1 $display("B-type beq imm = %h", imm); // Expected: 10

        // Shift immediate: slli x4, x5, 3
        instr = 32'b0000000_00011_00101_001_00100_0010011;
        #1 $display("Shift slli imm = %h", imm); // Expected: 3

        $finish;
    end
endmodule
