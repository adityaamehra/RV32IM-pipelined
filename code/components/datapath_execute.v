module execute_datapath(
input clk,
input reset,

input [31:0] RD1E, RD2E, ImmExtE,
input [31:0] PCE,
input ALUSrcE,
input [3:0] ALUControlE,

output Zero,
output less,
output lessu,
output [31:0] ALUResult,
output [31:0] WriteDataE,
output [31:0] PCTargetE
);

alu alu(RD1E,SrcBE,ALUControlE,ALUResult,Zero,less,lessu);
mux2 #(32) srcbmuxE(RD2E,ImmExtE,ALUSrcE,SrcBE);

adder pcaddE(PCE,ImmExtE,PCTargetE);
assign WriteDataE = RD2E;
endmodule 