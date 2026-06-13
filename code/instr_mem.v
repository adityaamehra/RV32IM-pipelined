
// instr_mem.v - instruction memory
// author - Adityaa Mehra

module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// array of 64 32-bit words or instructions
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

integer i;
initial begin
    for (i = 0; i < MEM_SIZE; i = i + 1) begin
        instr_ram[i] = 32'h00000013; // NOP
    end
    $readmemh("rv32i_test.hex", instr_ram);
end

// word-aligned memory access
// combinational read logic
assign instr = instr_ram[instr_addr[31:2]];

endmodule

