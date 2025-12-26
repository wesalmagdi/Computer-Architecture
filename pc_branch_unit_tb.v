// Code your testbench here
module pc_branch_unit_tb;

    reg clk;
    reg reset;
    reg branch;
    reg zero;
    reg [31:0] pc_current;
    reg [31:0] imm_ext;
    wire [31:0] pc_next;

    pc_branch_unit dut (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .zero(zero),
        .pc_current(pc_current),
        .imm_ext(imm_ext),
        .pc_next(pc_next)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        branch = 0;
        zero = 0;
        pc_current = 32'd0;
        imm_ext = 32'd0;

        // Release reset
        #10 reset = 0;

      // Case 1: Sequential execusion
        pc_current = pc_next;
        branch = 0;
        zero = 0;

        #10;
        $display("No Branch: PC = %d", pc_next);

        // Case 2: Branch instruction, taken 
        pc_current = pc_next;
        branch = 1;
        zero = 1;
        imm_ext = 32'd4;  // offset

        #10;
        $display("Branch Taken: PC = %d", pc_next);

        // Case 3: Branch instruction, NOT taken
        pc_current = pc_next;
        branch = 1;
        zero = 0;

        #10;
      $display("Branch not taken: PC = %d", pc_next);

        #20;
        $stop;
    end
endmodule
