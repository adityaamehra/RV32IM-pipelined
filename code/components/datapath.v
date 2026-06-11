
// datapath.v
// author - Adityaa Mehra
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [2:0]   ImmSrc,
    input [3:0]   ALUControl,
    output        Zero,
	 output			less,
	 output			lessu,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext, PCPlus4, PCTarget;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult;
reg [31:0] actualdata;
reg[31:0] uinstdata;

// next PC logic
reset_ff #(32) pcreg(clk, reset, PCNext, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);

// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero,less,lessu);

always @(*) begin
	case(Instr[6:0])
	7'b0010111: begin
	uinstdata=SrcB+PC;
	end
	7'b0110111: begin
	uinstdata=SrcB;
	end
	default: begin
	uinstdata=0;
	end
	endcase
end

always @(*) begin
if(Instr[6:0]==7'b0000011) begin
	case(Instr[14:12])
		3'b000: begin
			actualdata={{24{ReadData[7]}},ReadData[7:0]};
		end
		3'b001: begin
			actualdata={{16{ReadData[15]}},ReadData[15:0]};
		end
		3'b010: begin
			actualdata=ReadData;
		end
		3'b100: begin
			actualdata={{24{1'b0}},ReadData[7:0]};
		end
		3'b101: begin
			actualdata={{16{1'b0}},ReadData[15:0]};
		end
		default: begin
			actualdata=0;
		end
	endcase
	end
	else begin
		actualdata=0;
	end
end

mux4 #(32)     resultmux(ALUResult, actualdata, PCPlus4,uinstdata, ResultSrc, Result);

assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule

