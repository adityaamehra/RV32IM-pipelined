
// datapath.v
// author - Adityaa Mehra
module datapath (
    input         clk, reset,
    output [31:0] PCF,
    input  [31:0] InstrF,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] ResultW,
    output MemWriteM
);

wire [31:0] instrD,instrE;
reg PCSrcE;

// HAZARD UNIT
hazard_unit hu(Rs1E,Rs2E,RdM,RdW,RegWriteM,RegWriteW,ForwardAE,ForwardBE);


// Fetch stage datapath including the intermediate register
fetch_datapath fd(clk,reset,PCSrcE,PCTargetE,PCF,PCPlus4F);
reg_fet_dec rfd(clk,PCSrcE,InstrF,instrD,PCF,PCD,PCPlus4F,PCPlus4D);

// Decode stage of the pipeline

controller ctrl(instrD[6:0],instrD[14:12],instrD[30],ResultSrcD,MemWriteD,ALUSrcD,RegWriteD,JumpD,ImmSrcD,ALUControlD,BranchD);

decode_datapath dd(clk,reset,instrD,ResultW,RdW,RegWriteW,ImmSrcD,RdD,RD1D,RD2D,ImmExtD,Rs1D,Rs2D);
reg_dec_exe rde(clk,PCSrcE,RD1D,RD1E,RD2D,RD2E,PCD,PCE,RdD,RdE,ImmExtD,ImmExtE,PCPlus4D,PCPlus4E,RegWriteD,RegWriteE,ResultSrcD,ResultSrcE,MemWriteD,MemWriteE,ALUSrcD,ALUSrcE,JumpD,JumpE,ALUControlD,ALUControlE,BranchD,BranchE,instrD,instrE,Rs1D,Rs1E,Rs2D,Rs2E);

// Execute stage of the pipeline
execute_datapath ed(clk,reset,instrE,RD1E,RD2E,ImmExtE,PCE,ALUSrcE,ALUControlE,ResultW,ForwardAE,ForwardBE,ALUResultM,ZeroE,ALUResultE,WriteDataE,PCTargetE);
reg_exe_mem rem(clk,ALUResultE,ALUResultM,WriteDataE,WriteDataM,RdE,RdM,PCPlus4E,PCPlus4M,RegWriteE,RegWriteM,ResultSrcE,ResultSrcM,MemWriteE,MemWriteM);

// For jumping and branching
always @(*) begin
	case(instrE[6:0])
		7'b1100011: begin // B-Type instrutions
			case(instrE[14:12])
				3'b000: begin
					PCSrcE=BranchE & ZeroE;
				end
				3'b001: begin
					PCSrcE=BranchE & ~ZeroE;
				end
				3'b100: begin
					PCSrcE=BranchE & ~ZeroE;
				end
				3'b101: begin
					PCSrcE=BranchE & ZeroE;
				end
				3'b110: begin
					PCSrcE=BranchE & ~ZeroE;
				end
				3'b111: begin
					PCSrcE=BranchE & ZeroE;
				end
				default: begin
					PCSrcE=0;
				end
			endcase
		end
		7'b1100111: begin // jalr
			PCSrcE = JumpE;
		end
		7'b1101111: begin // jal
			PCSrcE=JumpE;
		end
		default: begin
			PCSrcE=0;
		end
	endcase
end

// Memory stage of the pipeline
assign Mem_WrAddr = ALUResultM;
assign Mem_WrData = WriteDataM;
reg_mem_wb rmw(clk,ReadData,ReadDataW,ALUResultM,ALUResultW,RdM,RdW,PCPlus4M,PCPlus4W,RegWriteM,RegWriteW,ResultSrcM,ResultSrcW);

// Writeback stage of the pipeline
mux4 #(32) ResultMux(ALUResultW,ReadDataW,PCPlus4W,32'b0,ResultSrcW,ResultW);
endmodule

