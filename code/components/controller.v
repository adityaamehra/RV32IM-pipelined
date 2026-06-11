
// controller.v - controller for RISC-V CPU
// author - Adityaa Mehra

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero,
	 input 		  less,
	 input 		  lessu,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output reg   PCSrc, 
	 output 		  ALUSrc,
    output       RegWrite, Jump,
    output [2:0] ImmSrc,
    output [3:0] ALUControl
);

wire [2:0] ALUOp;
wire       Branch;
main_decoder    md (op,funct3, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

// for jump and branch
always @(*) begin
	case(op)
		7'b1100011: begin // B-Type instrutions
			case(funct3)
				3'b000: begin
					PCSrc=Branch & Zero;
				end
				3'b001: begin
					PCSrc=Branch & ~Zero;
				end
				3'b100: begin
					PCSrc=Branch & less;
				end
				3'b101: begin
					PCSrc=Branch & ~less;
				end
				3'b110: begin
					PCSrc=Branch & lessu;
				end
				3'b111: begin
					PCSrc=Branch & ~lessu;
				end
				default: begin
					PCSrc=0;
				end
			endcase
		end
		7'b1100111: begin
		end
		7'b1101111: begin // jal
			PCSrc=Jump;
		end
		default: begin
			PCSrc=0;
		end
	endcase
end

endmodule

