module execute_datapath(
input clk,
input reset,

input [31:0] instrE,
input [31:0] RD1E, RD2E, ImmExtE,
input [31:0] PCE,
input ALUSrcE,
input [3:0] ALUControlE,
input [31:0] ResultW,
input [1:0] ForwardAE, ForwardBE,
input [31:0] ALUResultM,

output Zero,
output [31:0] ALUResult,
output [31:0] WriteDataE,
output [31:0] PCTargetE
);

reg [31:0] SrcAE;

always @(*) begin
    case(instrE[6:0])
        7'b0010111: SrcAE = PCE; // auipc
        7'b0110111: SrcAE = 0; // lui
        default: SrcAE = RD1E;
    endcase
end

mux2 #(32) srcbmuxE(RD2E,ImmExtE,ALUSrcE,SrcBE);

always @(*) begin
    case(ForwardAE)
        2'b00: SrcAE = SrcAE;
        2'b01: SrcAE = ResultW;
        2'b10: SrcAE = ALUResultM;
        default: SrcAE = SrcAE;
    endcase
end
always @(*) begin
    case(ForwardBE)
        2'b00: SrcBE = SrcBE;
        2'b01: SrcBE = ResultW;
        2'b10: SrcBE = ALUResultM;
        default: SrcBE = SrcBE;
    endcase
end

alu alu(SrcAE,SrcBE,ALUControlE,ALUResult,Zero);

adder pcaddE((instrE[6:0]==7'b1100111)?RD1E:PCE,ImmExtE,PCTargetE);
assign WriteDataE = RD2E;
endmodule 