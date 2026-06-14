module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [6:0]      funct7,
    input [2:0]      ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        3'b000: ALUControl = 4'b0000;              // addition
        3'b001: ALUControl = 4'b0001;              // subtraction
        3'b010: ALUControl = 4'b0101;              // less than signed
        3'b011: ALUControl = 4'b1001;              // less than unsigned
        default:
            case (funct3) // R-type or I-type ALU
                3'b000: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b0100; // mul
                    else if (funct7b5 & opb5) 
                        ALUControl = 4'b0001; // sub
                    else 
                        ALUControl = 4'b0000; // add, addi
                end
                3'b001: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b0100; // mulh
                    else
                        ALUControl = 4'b1000; // sll and slli
                end
                3'b010: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b0100; // mulhsu
                    else
                        ALUControl = 4'b0101; // slt, slti
                end
                3'b011: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b0100; // mulhu
                    else
                        ALUControl = 4'b1001; // sltu and sltiu
                end
                3'b100: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b1110; // div and divu
                    else
                        ALUControl = 4'b1010; // xor and xori
                end
                3'b101: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b1110; // div and divu
                    else if(funct7b5) 
                        ALUControl = 4'b1100; // sra and srai
                    else 
                        ALUControl = 4'b1011; // srl and srli
                end
                3'b110: begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b1111; // rem
                    else   
                        ALUControl = 4'b0011; // or, ori
                end
                3'b111:  begin
                    if(funct7 == 7'b0000001)
                        ALUControl = 4'b1111; // remu
                    else 
                        ALUControl = 4'b0010; // and, andi
                end
                default: ALUControl = 4'bxxxx; // ???
            endcase
    endcase
end

endmodule