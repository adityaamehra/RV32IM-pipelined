module decode_datapath(
input clk,
input reset,

input [31:0] InstrD,
input [31:0] ResultW,
input [4:0] RdW,
input RegWriteW,
input [2:0] ImmSrcD,

output [4:0] RdD,
output [31:0] RD1D,
output [31:0] RD2D,
output [31:0] ImmExtD,
output [4:0] Rs1D,
output [4:0] Rs2D
);

reg_file       rf (clk, RegWriteW, InstrD[19:15], InstrD[24:20],RdW, ResultW, RD1D, RD2D);


imm_extend     ext (InstrD[31:7], ImmSrcD, ImmExtD);

assign RdD[4:0]=InstrD[11:7];
assign Rs1D[4:0]=InstrD[19:15];
assign Rs2D[4:0]=InstrD[24:20];
endmodule 