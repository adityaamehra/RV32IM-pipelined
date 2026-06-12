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
output [31:0] ImmExtD
);

reg_file       rf (clk, RegWrite, InstrD[19:15], InstrD[24:20],RdW, ResultW, RD1D, RD2D);


imm_extend     ext (Instr[31:7], ImmSrcD, ImmExtD);

assign RdD[4:0]=InstrD[11:7];
endmodule 