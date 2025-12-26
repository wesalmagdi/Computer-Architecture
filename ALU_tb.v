`timescale 1ns / 1ps

module ALU_tb();
    reg [63:0] A;
    reg [63:0] B;
    reg [3:0] ALUControl;
    wire [63:0] Result;
    wire Zero;

    ALU test_alu (
        A,
        B,
        ALUControl,
        Result,
        Zero
    );

    initial begin
        $display("Starting ALU Comprehensive Test...");
        $display("-------------------------------------------------------------------------");

        A = 64'hAAAA_AAAA_AAAA_AAAA; B = 64'hFFFF_FFFF_0000_0000; ALUControl = 4'b0000;
        #10; 
        $display("Time=%0t | Op: AND | A=%h | B=%h | Result=%h | Zero=%b", $time, A, B, Result, Zero);

        A = 64'hAAAA_AAAA_AAAA_AAAA; B = 64'h5555_5555_5555_5555; ALUControl = 4'b0001;
        #10; 
        $display("Time=%0t | Op: OR  | A=%h | B=%h | Result=%h | Zero=%b", $time, A, B, Result, Zero);

        A = 64'd100; B = 64'd50; ALUControl = 4'b0010;
        #10; 
        $display("Time=%0t | Op: ADD | A=%d | B=%d | Result=%d | Zero=%b", $time, A, B, Result, Zero);

        A = 64'h1234_5678_1234_5678; B = 64'h1234_5678_1234_5678; ALUControl = 4'b0100;
        #10; 
        $display("Time=%0t | Op: XOR | A=%h | B=%h | Result=%h | Zero=%b", $time, A, B, Result, Zero);

        A = 64'd100; B = 64'd50; ALUControl = 4'b0110;
        #10; 
        $display("Time=%0t | Op: SUB | A=%d | B=%d | Result=%d | Zero=%b", $time, A, B, Result, Zero);

        A = 64'h1; B = 64'd4; ALUControl = 4'b1000;
        #10; 
        $display("Time=%0t | Op: SLL | A=%h | B=%d | Result=%h | Zero=%b", $time, A, B, Result, Zero);

        A = 64'h80; B = 64'd4; ALUControl = 4'b1001;
        #10; 
        $display("Time=%0t | Op: SRL | A=%h | B=%d | Result=%h | Zero=%b", $time, A, B, Result, Zero);

        A = 64'h8000_0000_0000_0000; B = 64'd1; ALUControl = 4'b1010;
        #10; 
        $display("Time=%0t | Op: SRA | A=%h | B=%d | Result=%h | Zero=%b", $time, A, B, Result, Zero);

        A = 64'd33; B = 64'd33; ALUControl = 4'b1111;
        #10; 
        $display("Time=%0t | Op: DEF | A=%d | B=%d | Result=%d | Zero=%b", $time, A, B, Result, Zero);

        $display("-------------------------------------------------------------------------");
        $display("Full Operation Test Complete");
        $finish;
    end
endmodule