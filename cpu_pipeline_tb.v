`timescale 1ns/1ps

module cpu_pipeline_tb;

    reg clk;
    reg rst;

    // Instantiate the pipeline CPU
    cpu_pipeline CPU (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Reset and simulation control
    initial begin
        rst = 1;
        #20;
        rst = 0;

        // Run simulation for a limited time
        #2000;

        $display("Simulation finished.");
        $finish;
    end

endmodule
