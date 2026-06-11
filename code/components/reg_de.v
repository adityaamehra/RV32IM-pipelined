module reg_dec_exe(
input clk,

input [31:0] RD1D,
output [31:0] RD1E,

input [31:0] RD2D,
output [31:0] RD2E,

input [31:0] PCD,
output [31:0] PCE,

input [4:0] RdD,
output [4:0] RdE,

input [31:0] ImmExtD,
output [31:0] ImmExtE,

input [31:0] PCPlus4D,
output [31:0] PCPlus4E

// Now inputting the control signals for the EXE
input RegWriteD,
output RegWriteE,

input [1:0] ResultSrcD,
output [1:0] ResultSrcE,

input MemWriteD,
output MemWriteE,

input PCSrcD,
output PCSrcE,

input ALUSrcD,
output ALUSrcE,

input JumpD,
output JumpE,

input [3:0] ALUControlD,
output [3:0] ALUControlE
);


always @(posedge clk) begin
    RD1E<=RD1D;
    RD2E<=RD2D;
    PCE<=PCD;
    RdE<=RdD;
    ImmExtE<=ImmExtD;
    PCPlus4E<=PCPlus4D;
    RegWriteE<=RegWriteD;
    ResultSrcE<=ResultSrcD;
    MemWriteE<=MemWriteD;
    PCSrcE<=PCSrcD;
    ALUSrcE<=ALUSrcD;
    JumpE<=JumpD;
    ALUControlE<=ALUControlD;
end
endmodule