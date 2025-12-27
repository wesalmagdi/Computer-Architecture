`timescale 1ns/1ps
module cpu_top_tb();
    reg clk;
    reg rst;

    // instantiate CPU
    cpu_top CPU(.clk(clk), .rst(rst));

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0; // release reset
        #200 $finish;
    end

    always #5 clk = ~clk; // 10ns period
endmodule
