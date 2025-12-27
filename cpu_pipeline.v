module cpu_pipeline(
    input clk,
    input rst
);

    // ---------------- IF STAGE ----------------
    reg [63:0] IF_PC;
    wire [31:0] IF_instr;

    instr_mem IM(.addr(IF_PC), .instr(IF_instr));

    wire [63:0] IF_PC_next = IF_PC + 4;

    // IF/ID Pipeline Register
    reg [63:0] ID_PC;
    reg [31:0] ID_instr;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_PC <= 0;
            ID_instr <= 0;
        end else begin
            ID_PC <= IF_PC;
            ID_instr <= IF_instr;
        end
    end

    // ---------------- ID STAGE ----------------
    wire [6:0] opcode = ID_instr[6:0];
    wire [2:0] funct3 = ID_instr[14:12];
    wire [6:0] funct7 = ID_instr[31:25];

    // Control signals
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [3:0] ALUControl;

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

    // Register file
    wire [63:0] ID_reg_rdata1, ID_reg_rdata2;
    RegisterFile RF(
        .clk(clk),
        .we(RegWrite),
        .rs1(ID_instr[19:15]),
        .rs2(ID_instr[24:20]),
        .rd(ID_instr[11:7]),
        .wd(64'd0), // WB stage will write data later
        .rd1(ID_reg_rdata1),
        .rd2(ID_reg_rdata2)
    );

    // Immediate
    wire [63:0] ID_imm;
    ImmGen IMM(
        .instr(ID_instr),
        .imm(ID_imm)
    );

    // ---------------- ID/EX PIPE ----------------
    reg [63:0] EX_reg_rdata1, EX_reg_rdata2, EX_imm, EX_PC;
    reg [3:0] EX_ALUControl;
    reg EX_ALUSrc, EX_RegWrite, EX_MemRead, EX_MemWrite, EX_MemToReg, EX_Branch, EX_Jump;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EX_reg_rdata1 <= 0;
            EX_reg_rdata2 <= 0;
            EX_imm <= 0;
            EX_PC <= 0;
            EX_ALUControl <= 0;
            EX_ALUSrc <= 0;
            EX_RegWrite <= 0;
            EX_MemRead <= 0;
            EX_MemWrite <= 0;
            EX_MemToReg <= 0;
            EX_Branch <= 0;
            EX_Jump <= 0;
        end else begin
            EX_reg_rdata1 <= ID_reg_rdata1;
            EX_reg_rdata2 <= ID_reg_rdata2;
            EX_imm <= ID_imm;
            EX_PC <= ID_PC;
            EX_ALUControl <= ALUControl;
            EX_ALUSrc <= ALUSrc;
            EX_RegWrite <= RegWrite;
            EX_MemRead <= MemRead;
            EX_MemWrite <= MemWrite;
            EX_MemToReg <= MemToReg;
            EX_Branch <= Branch;
            EX_Jump <= Jump;
        end
    end

    // ---------------- EX STAGE ----------------
    wire [63:0] EX_alu_in2 = EX_ALUSrc ? EX_imm : EX_reg_rdata2;
    wire [63:0] EX_alu_result;
    wire EX_alu_zero;

    ALU EX_ALU(
        .A(EX_reg_rdata1),
        .B(EX_alu_in2),
        .ALUControl(EX_ALUControl),
        .Result(EX_alu_result),
        .Zero(EX_alu_zero)
    );

    // ---------------- EX/MEM PIPE ----------------
    reg [63:0] MEM_alu_result, MEM_reg_rdata2;
    reg MEM_RegWrite, MEM_MemRead, MEM_MemWrite, MEM_MemToReg, MEM_Branch, MEM_Jump;
    reg [63:0] MEM_PC;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_alu_result <= 0;
            MEM_reg_rdata2 <= 0;
            MEM_RegWrite <= 0;
            MEM_MemRead <= 0;
            MEM_MemWrite <= 0;
            MEM_MemToReg <= 0;
            MEM_Branch <= 0;
            MEM_Jump <= 0;
            MEM_PC <= 0;
        end else begin
            MEM_alu_result <= EX_alu_result;
            MEM_reg_rdata2 <= EX_reg_rdata2;
            MEM_RegWrite <= EX_RegWrite;
            MEM_MemRead <= EX_MemRead;
            MEM_MemWrite <= EX_MemWrite;
            MEM_MemToReg <= EX_MemToReg;
            MEM_Branch <= EX_Branch;
            MEM_Jump <= EX_Jump;
            MEM_PC <= EX_PC;
        end
    end

    // ---------------- MEM STAGE ----------------
    wire [63:0] MEM_mem_rdata;
    data_mem MEM_DM(
        .clk(clk),
        .MemWrite(MEM_MemWrite),
        .MemRead(MEM_MemRead),
        .addr(MEM_alu_result),
        .write_data(MEM_reg_rdata2),
        .read_data(MEM_mem_rdata)
    );

    // ---------------- MEM/WB PIPE ----------------
    reg [63:0] WB_alu_result, WB_mem_rdata;
    reg WB_RegWrite, WB_MemToReg;
    reg [4:0] WB_rd;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_alu_result <= 0;
            WB_mem_rdata <= 0;
            WB_RegWrite <= 0;
            WB_MemToReg <= 0;
            WB_rd <= 0;
        end else begin
            WB_alu_result <= MEM_alu_result;
            WB_mem_rdata <= MEM_mem_rdata;
            WB_RegWrite <= MEM_RegWrite;
            WB_MemToReg <= MEM_MemToReg;
            WB_rd <= ID_instr[11:7]; // naive WB destination
        end
    end

    // ---------------- WRITE BACK ----------------
    wire [63:0] WB_write_data = WB_MemToReg ? WB_mem_rdata : WB_alu_result;
    // Here you would connect WB_write_data to RegisterFile
    // This is simplified; full forwarding not implemented

    // ---------------- PC UPDATE ----------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            IF_PC <= 0;
        else
            IF_PC <= IF_PC_next; // naive PC update, ignoring branches for simplicity
    end

endmodule
