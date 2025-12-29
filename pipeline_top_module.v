module pipeline_top(
    input clk,
    input rst
);
    // 1. FETCH STAGE (IF)
    wire [63:0] PC_next;
    reg  [63:0] PC_reg;
    wire [31:0] IF_instr;

    always @(posedge clk or posedge rst) begin
        if (rst) PC_reg <= 64'd0;
        else     PC_reg <= PC_next;
    end

    instr_mem IM (.addr(PC_reg), .instr(IF_instr));

    // --- IF/ID Pipeline Register ---
    wire [31:0] ID_instr;
    wire [63:0] ID_PC;
    IF_ID pipe_IF_ID (
        .clk(clk), .rst(rst),
        .IF_instr(IF_instr), .IF_PC(PC_reg),
        .ID_instr(ID_instr), .ID_PC(ID_PC)
    );

    // 2. DECODE STAGE (ID)
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [3:0] ALUControl;
    wire [63:0] ID_ReadData1, ID_ReadData2, ID_Imm;

    CUpALUControl CU (
        .opcode(ID_instr[6:0]), .funct3(ID_instr[14:12]), .funct7(ID_instr[31:25]),
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), .MemToReg(MemToReg), .Branch(Branch),
        .Jump(Jump), .ALUControl(ALUControl)
    );

    RegisterFile RF (
        .clk(clk), .we(WB_RegWrite), 
        .rs1(ID_instr[19:15]), .rs2(ID_instr[24:20]), 
        .rd(WB_rd), 
        .wd(regfile_write_data), .rd1(ID_ReadData1), .rd2(ID_ReadData2)
    );

    ImmGen IMM (.instr(ID_instr), .imm(ID_Imm));

    // --- ID/EX Pipeline Register ---
    wire [1:0] EX_WB_ctrl, EX_M_ctrl, EX_E_ctrl;
    wire [63:0] EX_PC, EX_ReadData1, EX_ReadData2, EX_Imm;
    wire [3:0] EX_ALUControl; // Added to carry ALU opcode
    wire [4:0] EX_rd;

    ID_EX pipe_ID_EX (
        .clk(clk), .rst(rst),
        .WB_in({MemToReg, RegWrite}), .M_in({Branch, MemRead}), .EX_in({ALUSrc, 1'b0}), 
        .ID_PC(ID_PC), .ID_ReadData1(ID_ReadData1), .ID_ReadData2(ID_ReadData2), .ID_Imm(ID_Imm),
        .WB_out(EX_WB_ctrl), .M_out(EX_M_ctrl), .EX_out(EX_E_ctrl),
        .EX_PC(EX_PC), .EX_ReadData1(EX_ReadData1), .EX_ReadData2(EX_ReadData2), .EX_Imm(EX_Imm)
    );
    
    // Manual carry for signals not in your provided ID_EX.v template
    reg [3:0] EX_ALUControl_reg; reg [4:0] EX_rd_reg; reg EX_MemWrite_reg;
    always @(posedge clk) begin
        EX_ALUControl_reg <= ALUControl; 
        EX_rd_reg <= ID_instr[11:7];
        EX_MemWrite_reg <= MemWrite;
    end

    // 3. EXECUTE STAGE (EX)
    wire [63:0] EX_ALU_B = EX_E_ctrl[1] ? EX_Imm : EX_ReadData2; 
    wire [63:0] EX_ALURes;
    wire EX_Zero;

    ALU ALU_inst (
        .A(EX_ReadData1), .B(EX_ALU_B), .ALUControl(EX_ALUControl_reg),
        .Result(EX_ALURes), .Zero(EX_Zero)
    );

    wire [63:0] EX_BranchTarget = EX_PC + (EX_Imm << 1);

    // --- EX/MEM Pipeline Register ---
    wire [1:0] MEM_WB_ctrl, MEM_M_ctrl;
    wire [63:0] MEM_BranchTarget, MEM_ALURes, MEM_ReadData2;
    wire MEM_Zero, MEM_MemWrite;
    wire [4:0] MEM_rd;

    EX_MEM pipe_EX_MEM (
        .clk(clk), .rst(rst),
        .WB_in(EX_WB_ctrl), .M_in(EX_M_ctrl),
        .EX_BranchTarget(EX_BranchTarget), .EX_ALURes(EX_ALURes), .EX_ReadData2(EX_ReadData2),
        .EX_Zero(EX_Zero),
        .WB_out(MEM_WB_ctrl), .M_out(MEM_M_ctrl),
        .MEM_BranchTarget(MEM_BranchTarget), .MEM_ALURes(MEM_ALURes), .MEM_ReadData2(MEM_ReadData2),
        .MEM_Zero(MEM_Zero)
    );

    // Carry MemWrite and rd separately
    reg MEM_MemWrite_reg; reg [4:0] MEM_rd_reg;
    always @(posedge clk) begin 
        MEM_MemWrite_reg <= EX_MemWrite_reg; 
        MEM_rd_reg <= EX_rd_reg;
    end

    // 4. MEMORY STAGE (MEM)
    wire [63:0] MEM_ReadData;
    data_mem DM (
        .clk(clk), .MemWrite(MEM_MemWrite_reg), .MemRead(MEM_M_ctrl[0]),
        .addr(MEM_ALURes), .write_data(MEM_ReadData2), .read_data(MEM_ReadData)
    );

    // Branch Logic 
    assign take_branch = MEM_M_ctrl[1] & MEM_Zero; 
    assign PC_next = take_branch ? MEM_BranchTarget : (PC_reg + 64'd4);

    // --- MEM/WB Pipeline Register ---
    wire [1:0] WB_ctrl;
    wire [63:0] WB_ReadData, WB_ALURes_out;
    MEM_WB pipe_MEM_WB (
        .clk(clk), .rst(rst),
        .WB_in(MEM_WB_ctrl), .MEM_ReadData(MEM_ReadData), .MEM_ALURes(MEM_ALURes),
        .WB_out(WB_ctrl), .WB_ReadData(WB_ReadData), .WB_ALURes_out(WB_ALURes_out)
    );

    reg [4:0] WB_rd;
    always @(posedge clk) WB_rd <= MEM_rd_reg;

    // 5. WRITE BACK STAGE (WB)
    wire WB_RegWrite = WB_ctrl[0];
    wire WB_MemToReg = WB_ctrl[1];
    assign regfile_write_data = WB_MemToReg ? WB_ReadData : WB_ALURes_out; [cite: 102]

endmodule