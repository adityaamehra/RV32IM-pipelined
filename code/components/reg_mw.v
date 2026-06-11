module reg_mem_wb(
input clk,

input [31:0] ReadDataM,
output [31:0] ReadDataW,

input [31:0] ALUResultM,
output [31:0] ALUResultW,

input [4:0] RdM,
output [4:0] RdW,

input [31:0] PCPLus4M,
output [31:0] PCPlus4W
};

always @(posedge clk) begin
	ReadDataW<=ReadDataM;
	ALUResultW<=ALUResultM;
	RdW<=RdM;
	PCPlus4W<=PCPlus4M;
end

endmodule
