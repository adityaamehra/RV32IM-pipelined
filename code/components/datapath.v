module datapath(
    input clk,reset,
    output[31:0]PCF,
    input[31:0]InstrF,
    output[31:0]Mem_WrAddr,Mem_WrData,
    input[31:0]ReadData,
    output[31:0]ResultW,
    output MemWriteM
);

wire[31:0] instrD,instrE,instrM;
wire[1:0] ResultSrcE;
reg PCSrcE;
wire FlushE_final,FlushD;
wire[31:0] PCPlus4F;
wire[31:0] PCTargetE;
wire[31:0] PCD,PCPlus4D;
wire RegWriteD,MemWriteD,ALUSrcD,JumpD,BranchD;
wire[1:0] ResultSrcD;
wire[2:0] ImmSrcD;
wire[3:0] ALUControlD;
wire[4:0] RdD,Rs1D,Rs2D;
wire[31:0] RD1D,RD2D,ImmExtD;
wire RegWriteE,MemWriteE,ALUSrcE,JumpE,BranchE;
wire[3:0] ALUControlE;
wire[4:0] RdE,Rs1E,Rs2E;
wire[31:0] RD1E,RD2E,PCE,ImmExtE,PCPlus4E;
wire[1:0] ForwardAE,ForwardBE;
wire lwStall,StallF,StallD,FlushE;
wire ZeroE;
wire[31:0] ALUResultE,WriteDataE;
wire RegWriteM;
wire[1:0] ResultSrcM;
wire[4:0] RdM;
wire[31:0] ALUResultM,WriteDataM,PCPlus4M;
wire RegWriteW;
wire[1:0] ResultSrcW;
wire[4:0] RdW;
wire[31:0] ALUResultW,ReadDataW,PCPlus4W;

hazard_unit hu(Rs1E,Rs2E,Rs1D,Rs2D,RdE,RdM,RdW,RegWriteM,RegWriteW,ForwardAE,ForwardBE,ResultSrcE[0],lwStall,StallF,StallD,FlushE);
assign FlushE_final=FlushE|PCSrcE;
assign FlushD=PCSrcE;

fetch_datapath fd(clk,reset,~StallF,PCSrcE,PCTargetE,PCF,PCPlus4F);
reg_fet_dec rfd(clk,reset,~StallD,FlushD,InstrF,instrD,PCF,PCD,PCPlus4F,PCPlus4D);

controller ctrl(instrD[6:0],instrD[14:12],instrD[30],instrD[31:25],ResultSrcD,MemWriteD,ALUSrcD,RegWriteD,JumpD,ImmSrcD,ALUControlD,BranchD);
decode_datapath dd(clk,reset,instrD,ResultW,RdW,RegWriteW,ImmSrcD,RdD,RD1D,RD2D,ImmExtD,Rs1D,Rs2D);
reg_dec_exe rde(clk,reset,FlushE_final,RD1D,RD1E,RD2D,RD2E,PCD,PCE,RdD,RdE,ImmExtD,ImmExtE,PCPlus4D,PCPlus4E,RegWriteD,RegWriteE,ResultSrcD,ResultSrcE,MemWriteD,MemWriteE,ALUSrcD,ALUSrcE,JumpD,JumpE,ALUControlD,ALUControlE,BranchD,BranchE,instrD,instrE,Rs1D,Rs1E,Rs2D,Rs2E);

execute_datapath ed(clk,reset,instrE,RD1E,RD2E,ImmExtE,PCE,ALUSrcE,ALUControlE,ResultW,ForwardAE,ForwardBE,ALUResultM,ZeroE,ALUResultE,WriteDataE,PCTargetE);
reg_exe_mem rem(clk,reset,ALUResultE,ALUResultM,WriteDataE,WriteDataM,RdE,RdM,PCPlus4E,PCPlus4M,RegWriteE,RegWriteM,ResultSrcE,ResultSrcM,MemWriteE,MemWriteM,instrE,instrM);

always@(*)begin
    case(instrE[6:0])
        7'b1100011:begin
        case(instrE[14:12])
            3'b000:PCSrcE=BranchE&ZeroE;
            3'b001:PCSrcE=BranchE&~ZeroE;
            3'b100:PCSrcE=BranchE&~ZeroE;
            3'b101:PCSrcE=BranchE&ZeroE;
            3'b110:PCSrcE=BranchE&~ZeroE;
            3'b111:PCSrcE=BranchE&ZeroE;
            default:PCSrcE=0;
        endcase
        end
        7'b1100111:PCSrcE=JumpE;
        7'b1101111:PCSrcE=JumpE;
        default:PCSrcE=0;
    endcase
end

assign Mem_WrAddr=ALUResultM;
assign Mem_WrData=WriteDataM;

reg_mem_wb rmw(clk,reset,ReadData,ReadDataW,ALUResultM,ALUResultW,RdM,RdW,PCPlus4M,PCPlus4W,RegWriteM,RegWriteW,ResultSrcM,ResultSrcW,instrM);
mux4#(32)ResultMux(ALUResultW,ReadDataW,PCPlus4W,32'b0,ResultSrcW,ResultW);

endmodule