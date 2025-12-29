module tb_cpu();
    reg clk;
    reg rst;

    cpu_top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        // Start Reset
        clk = 0;
        rst = 1;
        #20 rst = 0; // Release Reset after 20ns
        
        // Wait 250ns for the program to finish executing all instructions
        #250;

        // Print the results to the Console;
        $display("x0       = %d", uut.RF.regs[0]);
        $display("x30      = %d", uut.RF.regs[30]);
        $display("x5       = %d", uut.RF.regs[5]);
        $display("x6       = %d", uut.RF.regs[6]);
        $display("x4       = %d", uut.RF.regs[4]);
        $display("x16      = %d", uut.RF.regs[16]);
        // mem[112] is index 14 because 112 / 8 bytes = 14
        $display("mem[112] = %d", uut.DM.mem[14]); 
        $stop;
    end
endmodule