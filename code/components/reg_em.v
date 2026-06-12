module reg_exe_mem(
input clk,

input [31:0] ALUResultE,
output reg [31:0] ALUResultM,

input [31:0] WriteDataE,
output reg [31:0] WriteDataM,

input [4:0] RdE,
output reg [4:0] RdM,

input [31:0] PCPlus4E,
output reg [31:0] PCPlus4M,

input RegWriteE,
output reg RegWriteM,

input [1:0] ResultSrcE,
output reg [1:0] ResultSrcM,

input MemWriteE,
output reg MemWriteM
);

always @(posedge clk) begin
	ALUResultM<=ALUResultE;
	WriteDataM<=WriteDataE;
	RdM<=RdE;
	PCPlus4M<=PCPlus4E;
	RegWriteM<=RegWriteE;
	ResultSrcM<=ResultSrcE;
	MemWriteM<=MemWriteE;
end

endmodule 