

module ALU_tb();
    // Inputs are 'reg' because we drive them with values
    reg [63:0] A;
    reg [63:0] B;
    reg [3:0] ALUControl;

    // Outputs are 'wire' because we are just observing them
    wire [63:0] Result;
    wire Zero;

    // 1. Instantiate the Unit Under Test (UUT)
    // This connects your testbench signals to your ALU module
    ALU dut (
        .A(A), 
        .B(B), 
        .ALUControl(ALUControl), 
        .Result(Result), 
        .Zero(Zero)
    );

    // 2. The Test Procedure
  initial begin
  
        $monitor("Time=%0t | A=%d | B=%d | Control=%b | Result=%d | Zero=%b", $time, A, B, ALUControl, Result, Zero);
        // --- Test 1: AND (0000) ---
        A = 64'hAAAA_AAAA_AAAA_AAAA; B = 64'hFFFF_FFFF_0000_0000; ALUControl = 4'b0000;
        #10; // Result should be AAAA_AAAA_0000_0000

        // --- Test 2: OR (0001) ---
        A = 64'hAAAA_AAAA_AAAA_AAAA; B = 64'h5555_5555_5555_5555; ALUControl = 4'b0001;
        #10; // Result should be FFFF_FFFF_FFFF_FFFF

        // --- Test 3: ADD (0010) ---
        A = 64'd100; B = 64'd50; ALUControl = 4'b0010;
        #10; // Result should be 150

        // --- Test 4: XOR (0100) ---
        A = 64'h1234_5678_1234_5678; B = 64'h1234_5678_1234_5678; ALUControl = 4'b0100;
        #10; // Result should be 0, Zero flag should be 1

        // --- Test 5: SUB (0110) ---
        A = 64'd100; B = 64'd50; ALUControl = 4'b0110;
        #10; // Result should be 50

        // --- Test 6: SLL (1000) ---
        A = 64'h1; B = 64'd4; ALUControl = 4'b1000;
        #10; // Result should be 16 (hex 10)

        // --- Test 7: SRL (1001) ---
        A = 64'h80; B = 64'd4; ALUControl = 4'b1001;
        #10; // Result should be 8 (hex 8)

        // --- Test 8: Default/Invalid Code ---
        A = 64'd33; B = 64'd33; ALUControl = 4'b1111;
        #10; // Result should be 0 (default case)

        $display("Full Operation Test Complete");
        $finish;
    end
endmodule