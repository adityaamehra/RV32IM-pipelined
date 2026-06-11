module reg_exe_mem(
input clk,

input [31:0] ALUResultE,
output [31:0] ALUResultM,

input [31:0] WriteDataE,
output [31:0] WriteDataM,

input [4:0] RdE,
output [4:0] RdM,

input [31:0] PCPlus4E,
output [31:0] PCPlus4M,

input RegWriteE,
output RegWriteM,

input [1:0] ResultSrcE,
output [1:0] ResultSrcM,

input MemWriteE,
output MemWriteM
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