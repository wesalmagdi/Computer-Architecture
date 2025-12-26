module pc_branch_unit (
    input  wire        clk,
    input  wire        reset,
    input  wire        branch,        // Branch control signal
    input  wire        zero,          // ALU Zero flag
    input  wire [31:0] pc_current,    // Current PC
    input  wire [31:0] imm_ext,       // Sign-extended immediate
    output reg  [31:0] pc_next        // Updated PC
);

    // PC + 4
    wire [31:0] pc_plus4;
    assign pc_plus4 = pc_current + 32'd4;

    // Branch target: PC + (signext(offset) << 1)
    // Change <<1 to <<2 if using MIPS-style addressing
    wire [31:0] branch_target;
    assign branch_target = pc_plus4 + (imm_ext << 1);

    // Branch decision logic
    wire take_branch;
    assign take_branch = branch & zero;

    // PC register update
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_next <= 32'd0;
        else if (take_branch)
            pc_next <= branch_target;
        else
            pc_next <= pc_plus4;
    end
endmodule
