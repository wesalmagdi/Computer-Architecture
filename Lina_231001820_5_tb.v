`timescale 1ns/1ps

module cpu_top_tb;

    // Clock and reset signals
    reg clk;
    reg rst;

    // Instantiate the CPU
    cpu_top CPU (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;
        #20;        // hold reset for 20 ns
        rst = 0;

        // Run simulation for 200 ns
        #200;

        // Finish simulation
        $finish;
    end

endmodule

