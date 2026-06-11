
// datapath.v
// author - Adityaa Mehra
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrcD,
    input         PCSrcD, ALUSrcD,
    input         RegWriteD,
    input [2:0]   ImmSrcD,
    input [3:0]   ALUControlD,
    output        Zero,
	output		  less,
	output		  lessu,
    output [31:0] PCF,
    input  [31:0] InstrF,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] ResultW
);

// Fetch stage datapath including the intermediate register

fetch_datapath(clk,reset,PCSrcE,PCTargetE,PCF,PCPlus4F);
reg_fet_dec(clk,InstrF,instrD,PCF,PCD,PCPLus4F,PCPlus4D);

// Decode stage of the pipeline

decode_datapath(clk,reset,instrD,ResultW,RdW,RegWriteW,ImmSrcD,RdD,RD1D,RD2D,ImmExtD);
reg_dec_exe(clk,RD1D,RD1E,RD2D,RD2E,PCD,PCE,RdD,RdE,ImmExtD,ImmExtE,PCPlus4D,PCPlus4E,RegWriteD,RegWriteE,ResultSrcD,ResultSrcE,MemWriteD,MemWriteE,PCSrcD,PCSrcE,ALUSrcD,ALUSrcE,JumpD,JumpE,ALUControlD,ALUControlE);

// Execute stage of the pipeline
execute_datapath(clk,reset,RD1E,RD2E,ImmExtE,PCE,ALUSrcE,ALUControlE,Zero,less,lessu,ALUResultE,WriteDataE,PCTargetE);
reg_exe_mem(clk,ALUResultE,ALUResultM,WriteDataE,WriteDataM,RdE,RdM,PCPlus4E,PCPlus4M,RegWriteE,RegWriteM,ResultSrcE,ResultSrcM,MemWriteE,MemWriteM);

// Memory stage of the pipeline
assign MemWrite = MemWriteM;
assign Mem_WrAddr = ALUResultM;
assign Mem_WrData = WriteDataM;
reg_mem_wb(clk,ReadData,ReadDataW,ALUResultM,ALUResultW,RdM,RdW,PCPlus4M,PCPlus4W,RegWriteM,RegWriteW,ResultSrcM,ResultSrcW);

// Writeback stage of the pipeline
mux4 #(32) ResultMux(ALUResultW,ReadDataW,PCPlus4W,32'b0,ResultSrcW,ResultW);
endmodule

