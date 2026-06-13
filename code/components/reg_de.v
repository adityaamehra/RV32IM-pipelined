module reg_dec_exe(
input clk,
input reset,
input flush,

input [31:0] RD1D,
output reg [31:0] RD1E,

input [31:0] RD2D,
output reg [31:0] RD2E,

input [31:0] PCD,
output reg [31:0] PCE,

input [4:0] RdD,
output reg [4:0] RdE,

input [31:0] ImmExtD,
output reg [31:0] ImmExtE,

input [31:0] PCPlus4D,
output reg [31:0] PCPlus4E,

// Now inputting the control signals for the EXE
input RegWriteD,
output reg RegWriteE,

input [1:0] ResultSrcD,
output reg [1:0] ResultSrcE,

input MemWriteD,
output reg MemWriteE,

input ALUSrcD,
output reg ALUSrcE,

input JumpD,
output reg JumpE,

input [3:0] ALUControlD,
output reg [3:0] ALUControlE,

input BranchD,
output reg BranchE,

input [31:0] instrD,
output reg [31:0] instrE,

input [4:0] Rs1D,
output reg [4:0] Rs1E,

input [4:0] Rs2D,
output reg [4:0] Rs2E
);


always @(posedge clk) begin
    if(flush | reset) begin
        RD1E<=0;
        RD2E<=0;
        PCE<=0;
        RdE<=0;
        ImmExtE<=0;
        PCPlus4E<=0;
        RegWriteE<=0;
        ResultSrcE<=0;
        MemWriteE<=0;
        ALUSrcE<=0;
        JumpE<=0;
        ALUControlE<=0;
        BranchE<=0;
        instrE<=0;
        Rs1E<=0;
        Rs2E<=0;
    end
    else begin
            RD1E<=RD1D;
            RD2E<=RD2D;
            PCE<=PCD;
            RdE<=RdD;
            ImmExtE<=ImmExtD;
            PCPlus4E<=PCPlus4D;
            RegWriteE<=RegWriteD;
            ResultSrcE<=ResultSrcD;
            MemWriteE<=MemWriteD;
            ALUSrcE<=ALUSrcD;
            JumpE<=JumpD;
            ALUControlE<=ALUControlD;
            BranchE<=BranchD;
            instrE<=instrD;
            Rs1E<=Rs1D;
            Rs2E<=Rs2D;
    end
end
endmodule