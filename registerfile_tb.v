module tb_registerfile;
    reg clk;
    reg we;
    reg [4:0] rs1, rs2, rd;
    reg [63:0] wd;
    wire [63:0] rd1, rd2;

    // Instantiate Register File
    RegisterFile rf(
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("===== Register File Test =====");

        // Write to x1
        we = 1; rd = 1; wd = 64'hDEADBEEFCAFEBABE;
        #10 we = 0;
        rs1 = 1; rs2 = 0;
        #1 $display("x1 = %h, x0 = %h", rd1, rd2); // x1 = DEADBEEFCAFEBABE, x0 = 0

        // Attempt write to x0 (should remain 0)
        we = 1; rd = 0; wd = 64'hFFFFFFFFFFFFFFFF;
        #10 we = 0;
        rs1 = 0; rs2 = 1;
        #1 $display("x0 = %h, x1 = %h", rd1, rd2); // x0 = 0, x1 = DEADBEEFCAFEBABE

        // Additional test: write to x5, read x5 and x1
        we = 1; rd = 5; wd = 64'h123456789ABCDEF0;
        #10 we = 0;
        rs1 = 5; rs2 = 1;
        #1 $display("x5 = %h, x1 = %h", rd1, rd2); // x5 = 123456789ABCDEF0, x1 unchanged

        $finish;
    end
endmodule
