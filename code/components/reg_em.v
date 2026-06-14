module reg_exe_mem(
input clk,
input reset,

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
output reg MemWriteM,

input [31:0] instrE,
output reg [31:0] instrM
);

always @(posedge clk) begin
	if(reset) begin
		ALUResultM<=0;
		WriteDataM<=0;
		RdM<=0;
		PCPlus4M<=0;
		RegWriteM<=0;
		ResultSrcM<=0;
		MemWriteM<=0;
		instrM<=0;
	end else begin
		ALUResultM<=ALUResultE;
		WriteDataM<=WriteDataE;
		RdM<=RdE;
		PCPlus4M<=PCPlus4E;
		RegWriteM<=RegWriteE;
		ResultSrcM<=ResultSrcE;
		MemWriteM<=MemWriteE;
		instrM<=instrE;
	end
end

endmodule 