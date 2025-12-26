module CUpALUControl (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemToReg,
    output reg Branch,
    output reg Jump,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case(opcode)
        //rtype
            7'b0000000: begin 
                RegWrite = 1; 
                case(funct3)
                    3'b000: ALUControl = (funct7==7'b0100000) ? 4'b0011 : 4'b0010; // sub=3/add=2
                    3'b111: ALUControl = 4'b0000; // and=0
                    3'b110: ALUControl = 4'b0001; // or=1
                    3'b100: ALUControl = 4'b0100; // xor=4
                    3'b001: ALUControl = 4'b0101; // sll=5
                    3'b101: ALUControl = (funct7==7'b0100000) ? 4'b0110 : 4'b0111; // sra/srl
                    default: ALUControl = 4'b1111;
                endcase
            end
        //itype
            7'b0000001: begin
                RegWrite = 1;
                ALUSrc   = 1;
                case(funct3)
                    3'b000: ALUControl = 4'b0010; // addi=2
                    3'b111: ALUControl = 4'b0000; // andi=0
                    3'b110: ALUControl = 4'b0001; // ori=1
                    3'b100: ALUControl = 4'b0100; // xori=4
                    3'b001: ALUControl = 4'b0101; // slli=5
                    3'b101: ALUControl = (funct7==7'b0100000) ? 4'b0110 : 4'b0111; // srai/srli
                    default: ALUControl = 4'b1111;
                endcase
            end
            //lw
            7'b0000010: begin
                RegWrite = 1;
                MemRead = 1;
                ALUSrc = 1;
                MemToReg = 1;
                ALUControl = 4'b0010; //add(address calc)
            end

            //sw
            7'b0000011: begin
                MemWrite = 1;
                ALUSrc = 1;
                ALUControl = 4'b0010; //add(Address calc brdo)
            end

            //beq/bne
            7'b0000100: begin
                Branch = 1;
                ALUControl = 4'b0011; //sub(comp)
            end

            //jal
            7'b0000101: begin
                RegWrite=1;
                Jump=1;
            end

            //jalr
            7'b0000110: begin
                RegWrite = 1;
                ALUSrc = 1; 
                Jump = 1;
                ALUControl = 4'b0010; //add (pc+imm)
            end
            default: begin
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                ALUSrc = 0;
                MemToReg = 0;
                Branch = 0;
                Jump = 0;
                ALUControl = 4'b1111; //nop
            end
        endcase
    end
endmodule


/*
funct3/funct7 mapping -> alucontrol:

r-type:
000/0000000:::add->0010
000/0100000:::sub->0011
111/------:::and->0000
110/------:::or->0001
100/------:::xor->0100
001/------:::sll->0101
101/0000000:::srl->0111
101/0100000:::sra->0110

i-type:
000/------:::addi->0010
111/------:::andi->0000
110/------:::ori->0001
100/------:::xori->0100
001/------:::slli->0101
101/0000000:::srli->0111
101/0100000:::srai->0110

memory:
---/------:::lw/ld->0010 (add address)
---/------:::sw/sd->0010 (add address)

branch:
---/------:::beq/bne->0011 (sub)
jump:
---/------:::jal->alucontrol not used
---/------:::jalr->0010 (pc+imm add)
*/
