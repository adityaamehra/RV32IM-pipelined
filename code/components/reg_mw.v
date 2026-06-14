module reg_mem_wb(
input clk,
input reset,

input [31:0] ReadDataM,
output reg [31:0] ReadDataW,

input [31:0] ALUResultM,
output reg [31:0] ALUResultW,

input [4:0] RdM,
output reg [4:0] RdW,

input [31:0] PCPlus4M,
output reg [31:0] PCPlus4W,

input RegWriteM,
output reg RegWriteW,

input [1:0] ResultSrcM,
output reg [1:0] ResultSrcW,

input [31:0] InstrM
);

always @(posedge clk) begin
	if(reset) begin
		ReadDataW<=0;
		ALUResultW<=0;
		RdW<=0;
		PCPlus4W<=0;
		RegWriteW<=0;
		ResultSrcW<=0;
	end
	else begin
		ReadDataW<=ReadDataM;
		case(InstrM[6:0])
			7'b0000011: begin
				case(InstrM[14:12])
					3'b000: begin
						ReadDataW<={{24{ReadDataM[7]}},ReadDataM[7:0]};
					end
					3'b001: begin
						ReadDataW<={{16{ReadDataM[15]}},ReadDataM[15:0]};
					end
					3'b010: begin
						ReadDataW<=ReadDataM;
					end
					3'b100: begin
						ReadDataW<={{24{1'b0}},ReadDataM[7:0]};
					end
					3'b101: begin
						ReadDataW<={{16{1'b0}},ReadDataM[15:0]};
					end
				endcase
			end
			default: begin
				ReadDataW<=0;
			end
		endcase
		ALUResultW<=ALUResultM;
		RdW<=RdM;
		PCPlus4W<=PCPlus4M;
		RegWriteW<=RegWriteM;
		ResultSrcW<=ResultSrcM;
	end
end

endmodule
