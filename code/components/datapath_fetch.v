module fetch_datapath (
input clk,
input reset,
input enable,

input PCSrcE,
input [31:0] PCTargetE,

output [31:0] PCF,
output [31:0] PCPlus4F
);

wire [31:0] PCF_dash;
mux2 #(32) pcmuxF(PCPlus4F,PCTargetE,PCSrcE,PCF_dash);

reset_ff #(32) pcregF(clk,reset,enable,PCF_dash,PCF);

adder pcadd4F(PCF,32'd4,PCPlus4F);
endmodule 