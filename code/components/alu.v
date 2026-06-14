
// alu.v - ALU module
// author - Adityaa Mehra

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
	input [2:0] funct3, // this is for differenciating for the M-extension
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                   // zero flag
);

always @(*) begin
    case (alu_ctrl)
        4'b0000:  alu_out = a + b;       // ADD
        4'b0001:  alu_out = a + ~b + 1;  // SUB
        4'b0010:  alu_out = a & b;       // AND
        4'b0011:  alu_out = a | b;       // OR
        4'b0101:  begin                   // SLT
            alu_out = $signed(a) < $signed(b);
        end
		4'b1000: begin // SLL
			alu_out=a<<b[4:0];
		end
		4'b1001: begin // SLTU
			alu_out=a<b;
		end
		4'b1010: begin // XOR
			alu_out=a^b;
		end
		4'b1011: begin // SRL
			alu_out=a>>b[4:0];
		end
		4'b1100: begin // SRA
			alu_out=$signed(a)>>>b[4:0];
		end
		4'b0100: begin // MUL,MULH,MULHU,MULHSU
			case(funct3)
				3'b000: begin // MUL
					alu_out=(a*b);
				end
				3'b001: begin // MULH
					alu_out=($signed({{32{a[31]}},a})*$signed({{32{b[31]}},b}))>>32;
				end
				3'b010: begin // MULHSU
					alu_out=($signed({{32{a[31]}},a})*$signed({{32{1'b0}},b}))>>32;
				end
				3'b011: begin // MULHU
					alu_out=(({{32{1'b0}},a})*({{32{1'b0}},b}))>>32;
				end
			endcase
		end
		4'b1110: begin // DIV,DIVU
			case(funct3)
				3'b100: begin // DIV
					alu_out=$signed(a)/$signed(b);
				end
				3'b101: begin // DIVU
					alu_out=a/b;
				end
			endcase
		end
		4'b1111: begin
			case(funct3)
				3'b110: begin // REM
					alu_out=$signed(a)%$signed(b);
				end
				3'b111:begin // REMU
					alu_out=a%b;
				end
			endcase
		end 
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

