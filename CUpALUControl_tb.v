module CUpALUControl_tb;

    reg [63:0] A;
    reg [63:0] B;
    reg [3:0] ALUctl;

    wire [63:0] ALUOut;
    wire Zero;

    CUpALUControl cu_alu(
        ALUctl,
        A,
        B,
        ALUOut,
        Zero
    );

    initial begin
        $display("--------------------------------------testbench ----------------------------");

        ALUctl = 4'b0000; //and
        A=64'hFFFF_FFFF_FFFF_FFFF, B=64'hFFFF_FFFF_FFFF_FFFF;
        #1;
        $display("AND: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0001; //or
        A=64'hF0F0_F0F0_F0F0_F0F0, B=64'h0F0F_0F0F_0F0F_0F0F;
        #1;
        $display("OR: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0010; //add
        A=64'h0000_0000_0000_0005, B=64'h0000_0000_0000_0003;
        #1;
        $display("ADD: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0011; //sub
        A=64'h0000_0000_0000_0005, B=64'h0000_0000_0000_0003;
        #1;
        $display("SUB: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0100; //xor
        A=64'hFFFF_0000_FFFF_0000, B=64'h0F0F_0F0F_0F0F_0F0F;
        #1;
        $display("XOR: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0101; //sll
        A=64'h0000_0000_0000_0001, B=64'h0000_0000_0000_0003; 
        #1;
        $display("SLL: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0111; //srl
        A=64'h0000_0000_0000_0080, B=64'h0000_0000_0000_0003;
        #1;
        $display("SRL: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        ALUctl = 4'b0110; //sra
        A=64'hFFFF_FFFF_FFFF_FFF0, B=64'h0000_0000_0000_0002;
        #1;
        $display("SRA: A=%h B=%h ALUOut=%h Zero=%b", A, B, ALUOut, Zero);

        $finish;
    end

endmodule
