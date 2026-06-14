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

// 1. Resolve Data Hazards (Forwarding)
reg [31:0] RD1E_fwd;
reg [31:0] RD2E_fwd;

always @(*) begin
    case(ForwardAE)
        2'b10:   RD1E_fwd = ALUResultM;
        2'b01:   RD1E_fwd = ResultW;
        default: RD1E_fwd = RD1E;
    endcase
end

always @(*) begin
    case(ForwardBE)
        2'b10:   RD2E_fwd = ALUResultM;
        2'b01:   RD2E_fwd = ResultW;
        default: RD2E_fwd = RD2E;
    endcase
end

// Store instructions require the forwarded Rs2 value
assign WriteDataE = RD2E_fwd;

// 2. Apply Opcode-Specific Overrides
reg  [31:0] SrcAE;
wire [31:0] SrcBE;

always @(*) begin
    case(instrE[6:0])
        7'b0010111: SrcAE = PCE;   // auipc
        7'b0110111: SrcAE = 32'b0; // lui
        default:    SrcAE = RD1E_fwd;
    endcase
end

// ALUSrc overrides forwarded register data with Immediate data
mux2 #(32) srcbmuxE(RD2E_fwd, ImmExtE, ALUSrcE, SrcBE);

// 3. Execution Units
alu alu_inst(SrcAE, SrcBE, ALUControlE,instrE[14:12],ALUResult, Zero);

// JALR must utilize the forwarded Rs1 value for address calculation
adder pcaddE(((instrE[6:0] == 7'b1100111) ? RD1E_fwd : PCE), ImmExtE, PCTargetE);

endmodule