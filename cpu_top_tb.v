`timescale 1ns/1ps
module cpu_top_tb;
    reg clk = 0;
    reg rst = 1;

    // Instantiate the CPU
    cpu_top cpu(.clk(clk), .rst(rst));

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        #10 rst = 0;

        // Run simulation for 200 ns
        #200 $finish;
    end

    initial begin
        $monitor("Time=%0t PC=%0d", $time, cpu.PC);
    end
endmodule
