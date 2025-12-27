module cpu_top(
    input clk,
    input rst
);
    // --- PC ---
    reg [63:0] PC;
    wire [63:0] PC_next;

    // --- Instruction Memory ---
    wire [31:0] instr;
    instr_mem IM(.addr(PC), .instr(instr));

    // --- Control ---
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [3:0] ALUControl;
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];

    CUpALUControl CU(
        .opcode(opcode), 
        .funct3(funct3), 
        .funct7(funct7),
        .RegWrite(RegWrite), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), 
        .MemToReg(MemToReg), 
        .Branch(Branch),
        .Jump(Jump), 
        .ALUControl(ALUControl)
    );

    // --- Register File ---
    wire [63:0] reg_rdata1, reg_rdata2;
    wire [63:0] regfile_write_data = MemToReg ? mem_rdata : alu_result;

    RegisterFile RF(
        .clk(clk),
        .we(RegWrite),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .wd(regfile_write_data),
        .rd1(reg_rdata1),
        .rd2(reg_rdata2)
    );

    // --- Immediate Generator ---
    wire [63:0] imm;
    ImmGen IMM(.instr(instr), .imm(imm));


    // --- ALU ---
    wire [63:0] alu_in2 = ALUSrc ? imm : reg_rdata2;
    wire [63:0] alu_result;
    wire alu_zero;

    ALU ALU_inst(
        .A(reg_rdata1), 
        .B(alu_in2), 
        .ALUControl(ALUControl),
        .Result(alu_result), 
        .Zero(alu_zero)
    );

    // --- Data Memory ---
    wire [63:0] mem_rdata;
    data_mem DM(
        .clk(clk), 
        .MemWrite(MemWrite), 
        .MemRead(MemRead),
        .addr(alu_result), 
        .write_data(reg_rdata2), 
        .read_data(mem_rdata)
    );

    // --- PC Logic ---
    wire [63:0] branch_target = PC + imm;
    assign PC_next = Jump ? (reg_rdata1 + imm) :
                     (Branch & alu_zero ? branch_target : PC + 4);

    always @(posedge clk or posedge rst) begin
        if (rst)
            PC <= 0;
        else
            PC <= PC_next;
    end
endmodule

