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
reg  [31:0] SrcAE_pre;
wire [31:0] SrcBE_pre;

reg  [31:0] SrcAE;
reg  [31:0] SrcBE;
always @(*) begin
    case(instrE[6:0])
        7'b0010111: SrcAE_pre = PCE;   // auipc
        7'b0110111: SrcAE_pre = 32'b0; // lui
        default:    SrcAE_pre = RD1E;
    endcase
end
mux2 #(32) srcbmuxE(RD2E, ImmExtE, ALUSrcE, SrcBE_pre);

// 3. SrcA Forwarding Multiplexer
always @(*) begin
    case(ForwardAE)
        2'b00:   SrcAE = SrcAE_pre;
        2'b01:   SrcAE = ResultW;
        2'b10:   SrcAE = ALUResultM;
        default: SrcAE = SrcAE_pre;
    endcase
end

// 4. SrcB Forwarding Multiplexer
always @(*) begin
    case(ForwardBE)
        2'b00:   SrcBE = SrcBE_pre;
        2'b01:   SrcBE = ResultW;
        2'b10:   SrcBE = ALUResultM;
        default: SrcBE = SrcBE_pre;
    endcase
end

// 5. Execution Units
alu alu_inst(SrcAE, SrcBE, ALUControlE, ALUResult, Zero);
adder pcaddE(((instrE[6:0] == 7'b1100111) ? RD1E : PCE), ImmExtE, PCTargetE);
// 6. Write Data Routing
assign WriteDataE = RD2E;

endmodule