module CUpALUControl_tb;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [3:0] ALUControl;

    CUpALUControl cu_alu(
        opcode,
        funct3,
        funct7,
        RegWrite,
        MemRead,
        MemWrite,
        ALUSrc,
        MemToReg,
        Branch,
        Jump,
        ALUControl
    );

    initial begin
        $display("--------------------------------------------------------------------------------");
        $display("Instr  | Opcode  | f3 | f7      | RW MR MW AS M2R Br Jp | ALUctl");
        $display("--------------------------------------------------------------------------------");

        //rtype instructions
        opcode = 7'b0110011; 
        funct3 = 3'b000; funct7 = 7'b0000000; #10; $display("add    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b000; funct7 = 7'b0100000; #10; $display("subtract    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b111; funct7 = 7'b0000000; #10; $display("and    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b110; funct7 = 7'b0000000; #10; $display("or     | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b100; funct7 = 7'b0000000; #10; $display("xor    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b001; funct7 = 7'b0000000; #10; $display("sll    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b101; funct7 = 7'b0000000; #10; $display("srl    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b101; funct7 = 7'b0100000; #10; $display("sra    | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);

        //itype instructions
        opcode = 7'b0010011; 
        funct3 = 3'b000; #10; $display("addi   | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b111; #10; $display("andi   | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b110; #10; $display("ori    | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b100; #10; $display("xori   | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b001; funct7 = 7'b0000000; #10; $display("slli   | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b101; funct7 = 7'b0000000; #10; $display("srli   | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        funct3 = 3'b101; funct7 = 7'b0100000; #10; $display("srai   | %b | %b| %b | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, funct7, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);

        //load and store instructions
        opcode = 7'b0000011; funct3 = 3'b010; #10; $display("lw     | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        opcode = 7'b0100011; funct3 = 3'b010; #10; $display("sw     | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);

        //branch and jump instructions
        opcode = 7'b1100011; funct3 = 3'b000; #10; $display("beq    | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        opcode = 7'b1100011; funct3 = 3'b001; #10; $display("bne    | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        opcode = 7'b1101111; #10; $display("jal    | %b | ---| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);
        opcode = 7'b1100111; funct3 = 3'b000; #10; $display("jalr   | %b | %b| ------- | %b  %b  %b  %b   %b   %b  %b | %b", opcode, funct3, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUControl);

        $finish;
    end
endmodule