
// alu.v - ALU module
// author - Adityaa Mehra

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero,                   // zero flag
	 output 		 less,
	 output 		 lessu
);

always @(a, b, alu_ctrl) begin
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
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;
assign less = alu_out?1'b1 : 1'b0;
assign lessu = alu_out?1'b1 : 1'b0;

endmodule

