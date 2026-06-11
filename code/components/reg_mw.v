module reg_mem_wb(
input clk,

input [31:0] ReadDataM,
output [31:0] ReadDataW,

input [31:0] ALUResultM,
output [31:0] ALUResultW,

input [4:0] RdM,
output [4:0] RdW,

input [31:0] PCPLus4M,
output [31:0] PCPlus4W,

input RegWriteM,
output RegWriteW,

input [1:0] ResultSrcM,
output [1:0] ResultSrcW
);

always @(posedge clk) begin
	ReadDataW<=ReadDataM;
	ALUResultW<=ALUResultM;
	RdW<=RdM;
	PCPlus4W<=PCPlus4M;
	RegWriteW<=RegWriteM;
	ResultSrcW<=ResultSrcM;
end

endmodule
