module reg_mem_wb(
input clk,

input [31:0] ReadDataM,
output reg [31:0] ReadDataW,

input [31:0] ALUResultM,
output reg [31:0] ALUResultW,

input [4:0] RdM,
output reg [4:0] RdW,

input [31:0] PCPlus4M,
output reg [31:0] PCPlus4W,

input RegWriteM,
output reg RegWriteW,

input [1:0] ResultSrcM,
output reg [1:0] ResultSrcW
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
