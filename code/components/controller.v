
// controller.v - controller for RISC-V CPU
// author - Adityaa Mehra

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input [6:0]  funct7,
    output       [1:0] ResultSrc,
    output       MemWrite, 
	 output 		  ALUSrc,
    output       RegWrite, Jump,
    output [2:0] ImmSrc,
    output [3:0] ALUControl,
    output      Branch
);

wire [2:0] ALUOp;
main_decoder    md (op,funct3, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5,funct7, ALUOp, ALUControl);

endmodule

