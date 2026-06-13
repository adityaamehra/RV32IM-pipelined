`timescale 1ns/1ps

module tb;

    reg         clk;
    reg         reset;
    reg         Ext_MemWrite;
    reg  [31:0] Ext_WriteData;
    reg  [31:0] Ext_DataAdr;

    wire        MemWrite;
    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire [31:0] ReadData;
    wire [31:0] PC;
    wire [31:0] Result;

    t1c_riscv_cpu uut (
        .clk(clk),
        .reset(reset),
        .Ext_MemWrite(Ext_MemWrite),
        .Ext_WriteData(Ext_WriteData),
        .Ext_DataAdr(Ext_DataAdr),
        .MemWrite(MemWrite),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .ReadData(ReadData),
        .PC(PC),
        .Result(Result)
    );

    integer total_checks = 0;
    integer pass_count   = 0;
    integer fail_count   = 0;
    integer MAX_CHECKS   = 31;

    // Data structures for verification
    reg [39:0] expected_trace [0:30];
    reg [8*20:1] instr_name   [0:30]; // Array of 20-character strings

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Hardwired expected trace: [39:32] Target Register, [31:0] Expected Data
        // Hardwired assembly mnemonics for strict logging correlation
        
        expected_trace[0]  = 40'h01_00000001; instr_name[0]  = "ADDI x1, x0, 1";
        expected_trace[1]  = 40'h02_00000002; instr_name[1]  = "ADDI x2, x0, 2";
        expected_trace[2]  = 40'h03_00000001; instr_name[2]  = "SLTI x3, x1, 2";
        expected_trace[3]  = 40'h04_00000001; instr_name[3]  = "SLTIU x4, x1, -1";
        expected_trace[4]  = 40'h05_00000002; instr_name[4]  = "XORI x5, x1, 3";
        expected_trace[5]  = 40'h06_00000003; instr_name[5]  = "ORI x6, x1, 2";
        expected_trace[6]  = 40'h07_00000002; instr_name[6]  = "ANDI x7, x5, 2";
        expected_trace[7]  = 40'h08_00000004; instr_name[7]  = "SLLI x8, x1, 2";
        expected_trace[8]  = 40'h09_00000002; instr_name[8]  = "SRLI x9, x8, 1";
        expected_trace[9]  = 40'h0A_FFFFFFFC; instr_name[9]  = "ADDI x10, x0, -4";
        expected_trace[10] = 40'h0B_FFFFFFFE; instr_name[10] = "SRAI x11, x10, 1";
        expected_trace[11] = 40'h0C_00001000; instr_name[11] = "LUI x12, 0x1000";
        expected_trace[12] = 40'h0D_00000030; instr_name[12] = "AUIPC x13, 0";
        expected_trace[13] = 40'h0E_00000003; instr_name[13] = "ADD x14, x1, x2";
        expected_trace[14] = 40'h0F_00000001; instr_name[14] = "SUB x15, x2, x1";
        expected_trace[15] = 40'h10_00000004; instr_name[15] = "SLL x16, x1, x2";
        expected_trace[16] = 40'h11_00000001; instr_name[16] = "SLT x17, x1, x2";
        expected_trace[17] = 40'h12_00000001; instr_name[17] = "SLTU x18, x1, x10";
        expected_trace[18] = 40'h13_00000003; instr_name[18] = "XOR x19, x1, x2";
        expected_trace[19] = 40'h14_00000002; instr_name[19] = "SRL x20, x8, x1";
        expected_trace[20] = 40'h15_FFFFFFFE; instr_name[20] = "SRA x21, x10, x1";
        expected_trace[21] = 40'h16_00000003; instr_name[21] = "OR x22, x1, x2";
        expected_trace[22] = 40'h17_00000002; instr_name[22] = "AND x23, x5, x2";
        expected_trace[23] = 40'h18_FFFFFFFC; instr_name[23] = "LW x24, 0(x0)";
        expected_trace[24] = 40'h19_00000001; instr_name[24] = "LH x25, 0(x0)";
        expected_trace[25] = 40'h1A_00000001; instr_name[25] = "LHU x26, 0(x0)";
        expected_trace[26] = 40'h1B_00000002; instr_name[26] = "LB x27, 0(x0)";
        expected_trace[27] = 40'h1C_00000002; instr_name[27] = "LBU x28, 0(x0)";
        expected_trace[28] = 40'h1E_000000B0; instr_name[28] = "JAL x30, +128";
        expected_trace[29] = 40'h1F_000000C4; instr_name[29] = "ADDI x31, x0, 196";
        expected_trace[30] = 40'h1C_000000BC; instr_name[30] = "JALR x28, x31, 0";

        Ext_MemWrite  = 0;
        Ext_WriteData = 32'b0;
        Ext_DataAdr   = 32'b0;

        reset = 1;
        #22; 
        reset = 0;

        #2000;
        
        $display("\n============================================================");
        $display("FINAL ISA TEST SUMMARY");
        $display("TOTAL INSTRUCTIONS EVALUATED: %0d / %0d", total_checks, MAX_CHECKS);
        $display("PASSED: %0d", pass_count);
        $display("FAILED: %0d", fail_count);
        $display("============================================================\n");
        $finish;
    end

    // Signal Extractions
    wire [31:0] pc_f         = uut.rvcpu.dp.PCF;
    wire [31:0] instr_d      = uut.rvcpu.dp.instrD;
    wire [31:0] alu_result_e = uut.rvcpu.dp.ALUResultE;
    wire        wb_reg_write = uut.rvcpu.dp.RegWriteW;
    wire [4:0]  wb_rd        = uut.rvcpu.dp.RdW;
    wire [31:0] wb_result    = uut.rvcpu.dp.ResultW;

    // Cycle-by-Cycle Pipeline Telemetry
    always @(posedge clk) begin
        if (!reset) begin
            $display("--- CYCLE @ %0t ns ---", $time);
            $display("  [IF] PC: %08h", pc_f);
            $display("  [ID] Instr: %08h", instr_d);
            $display("  [EX] ALU Out: %08h", alu_result_e);
            $display("  [WB] RegWrite: %b | Rd: x%0d | Result: %08h", wb_reg_write, wb_rd, wb_result);
        end
    end

    // Explicit Instruction Evaluation 
    always @(negedge clk) begin
        if (!reset && wb_reg_write && wb_rd != 5'b0) begin
            if (total_checks >= MAX_CHECKS) begin
                $display("  -> [IGNORED EXTRANEOUS WRITE] x%0d = %08h (Evaluation complete)", wb_rd, wb_result);
            end 
            else if (wb_rd === expected_trace[total_checks][36:32] && wb_result === expected_trace[total_checks][31:0]) begin
                $display("\n=> [PASS] %s", instr_name[total_checks]);
                $display("          Expected: x%0d = %08h | Got: x%0d = %08h\n", 
                         expected_trace[total_checks][36:32], expected_trace[total_checks][31:0],
                         wb_rd, wb_result);
                pass_count = pass_count + 1;
                total_checks = total_checks + 1;
            end 
            else if (total_checks > 0 && wb_rd === expected_trace[total_checks-1][36:32] && wb_result === expected_trace[total_checks-1][31:0]) begin
                $display("  -> [STALL TOLERANCE] Duplicate write to x%0d ignored.", wb_rd);
            end 
            else begin
                $display("\n=> [FAIL] %s", instr_name[total_checks]);
                $display("          Expected: x%0d = %08h | Got: x%0d = %08h\n", 
                         expected_trace[total_checks][36:32], expected_trace[total_checks][31:0],
                         wb_rd, wb_result);
                fail_count = fail_count + 1;
                total_checks = total_checks + 1;
            end
        end
    end

endmodule