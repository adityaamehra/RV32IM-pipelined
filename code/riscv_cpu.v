
// riscv_cpu.v - single-cycle RISC-V CPU Processor
// author - Adityaa Mehra

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);
datapath    dp  (clk, reset, PC, Instr, Mem_WrAddr, Mem_WrData, ReadData, Result, MemWrite);

endmodule

