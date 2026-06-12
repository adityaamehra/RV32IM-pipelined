
// main_decoder.v - logic for main decoder
// author - Adityaa Mehra

module main_decoder (
    input  [6:0] op,
	 input  [2:0] funct3,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump,
    output [2:0] ImmSrc,
    output [2:0] ALUOp
);

reg [12:0] controls;

always @(*) begin
    case (op)
        //RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
        7'b0000011: controls = 13'b1_000_1_0_01_0_000_0; // lw
        7'b0100011: controls = 13'b0_001_1_1_00_0_000_0; // sw
        7'b0110011: controls = 13'b1_xxx_0_0_00_0_111_0; // R–type
        7'b1100011: begin
				case(funct3)
					3'b000:controls = 13'b0_010_0_0_00_1_001_0; // beq
					3'b001:controls = 13'b0_010_0_0_00_1_001_0; // bne
					3'b100:controls = 13'b0_010_0_0_00_1_010_0; // blt
					3'b101:controls = 13'b0_010_0_0_00_1_010_0; // bge
					3'b110:controls = 13'b0_010_0_0_00_1_011_0; // blt
					3'b111:controls = 13'b0_010_0_0_00_1_011_0; // blt
				endcase
		  end
        7'b0010011: controls = 13'b1_000_1_0_00_0_111_0; // I–type ALU
		7'b1100111: controls = 13'b1_000_1_0_10_0_000_1; // jalr
        7'b1101111: controls = 13'b1_011_0_0_10_0_000_1; // jal
		  
		  7'b0010111: begin // auipc
		  controls = 13'b1_111_1_0_00_0_000_0;
		  end
		  
		  7'b0110111: begin // lui
		  controls = 13'b1_111_1_0_00_0_000_0;
		  end
		  
        default:    controls = 13'bx_xxx_x_x_xx_x_xxx_x; // ???
    endcase
end

assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = controls;

endmodule

