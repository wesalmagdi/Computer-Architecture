module cpu_top(
    input clk,
    input rst
);
    // --- PC Signals ---
    wire [63:0] PC; 
    wire [63:0] PC_next;
    reg  [63:0] PC_reg;

    assign PC = PC_reg;

    // --- Task 4: PC & Branch Unit ---
    pc_branch_unit PC_U (
        .clk(clk),
        .reset(rst),
        .branch(Branch),
        .zero(alu_zero),
        .pc_current(PC),
        .imm_ext(imm),
        .pc_next(PC_next)
    );

    // PC Register Update
    always @(posedge clk or posedge rst) begin
        if (rst) 
            PC_reg <= 64'd0;
        else     
            PC_reg <= PC_next;
    end

    // --- Instruction Memory ---
    wire [31:0] instr;
    instr_mem IM (
        .addr(PC), 
        .instr(instr)
    );

    // --- Control Unit (Task 2) ---
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [3:0] ALUControl;
    CUpALUControl CU (
        .opcode(instr[6:0]), 
        .funct3(instr[14:12]), 
        .funct7(instr[31:25]),
        .RegWrite(RegWrite), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), 
        .MemToReg(MemToReg), 
        .Branch(Branch),
        .Jump(Jump), 
        .ALUControl(ALUControl)
    );

    // --- Register File (Task 3A) ---
    wire [63:0] reg_rdata1, reg_rdata2;
    wire [63:0] mem_rdata; // Declared here for clarity
    wire [63:0] regfile_write_data = MemToReg ? mem_rdata : alu_result;
    
    RegisterFile RF (
        .clk(clk), 
        .we(RegWrite),
        .rs1(instr[19:15]), 
        .rs2(instr[24:20]), 
        .rd(instr[11:7]),
        .wd(regfile_write_data), 
        .rd1(reg_rdata1), 
        .rd2(reg_rdata2)
    );

    // --- Immediate Generator (Task 3B) ---
    wire [63:0] imm;
    ImmGen IMM (
        .instr(instr), 
        .imm(imm)
    );

    // --- ALU (Task 1) ---
    wire [63:0] alu_in2 = ALUSrc ? imm : reg_rdata2;
    wire [63:0] alu_result;
    wire alu_zero;
    ALU ALU_inst (
        .A(reg_rdata1), 
        .B(alu_in2), 
        .ALUControl(ALUControl),
        .Result(alu_result), 
        .Zero(alu_zero)
    );

    // --- Data Memory (Task 5B) ---
    data_mem DM (
        .clk(clk), 
        .MemWrite(MemWrite), 
        .MemRead(MemRead),
        .addr(alu_result), 
        .write_data(reg_rdata2), 
        .read_data(mem_rdata)
    );

endmodule