module data_mem (
    input clk,
    input MemRead,
    input MemWrite,
    input [63:0] addr,
    input [63:0] write_data,
    output reg [63:0] read_data
);
    reg [63:0] mem [0:255];

    always @(posedge clk) begin
        if (MemWrite)
            mem[addr[9:3]] <= write_data; // word-addressed
    end

    always @(*) begin
        if (MemRead)
            read_data = mem[addr[9:3]];
        else
            read_data = 64'b0;
    end
endmodule
