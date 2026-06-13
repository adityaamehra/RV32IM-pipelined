module reg_fet_dec (
input clk,
input reset,
input enable,
input flush,

input [31:0] instrF,
output reg [31:0] instrD,

input [31:0] PCF,
output reg [31:0] PCD,

input [31:0] PCPlus4F,
output reg [31:0] PCPlus4D
);

always @(posedge clk) begin
    if(flush | reset) begin
        instrD<=0;
        PCD<=0;
        PCPlus4D<=0;
    end
    else begin
        if(enable) begin
            instrD<=instrF;
            PCD<=PCF;
            PCPlus4D<=PCPlus4F;
        end
    end
end

endmodule