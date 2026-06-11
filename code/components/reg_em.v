module reg_exe_mem(
input clk,

input [31:0] ALUResultE,
output [31:0] ALUResultM,

input [31:0] WriteDataE,
output [31:0] WriteDataM,

input [4:0] RdE,
output [4:0] RdM,

input [31:0] PCPlus4E,
output [31:0] PCPlus4M
);

always @(posedge clk) begin
	ALUResultM<=ALUResultE;
	WriteDataM<=WriteDataE;
	RdM<=RdE;
	PCPlus4M<=PCPlus4E;
end

endmodule 