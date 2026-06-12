module hazard_unit(
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] RdM,
    input [4:0] RdW,
    input RegWriteM,
    input RegWriteW,
    output [1:0] ForwardAE,
    output [1:0] ForwardBE
);

    always @(*) begin
        if(((Rs1E==RdM) & RegWriteM)&(Rs1E!=0))
            ForwardAE = 2'b10;
        else if(((Rs1E==RdW) & RegWriteW)&(Rs1E!=0))
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
    end

    always @(*) begin
        if(((Rs2E==RdM) & RegWriteM)&(Rs2E!=0))
            ForwardBE = 2'b10;
        else if(((Rs2E==RdW) & RegWriteW)&(Rs2E!=0))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end
endmodule