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
    integer MAX_CHECKS   = 76;

    // Data structures for verification (45-character strings for verbose logging)
    reg [39:0] expected_trace [0:75];
    reg [8*45:1] instr_name   [0:75]; 

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Hardwired expected trace: [39:32] Target Register, [31:0] Expected Data
        // Complete 76-entry verification suite generated from generator trace
        
        expected_trace[0]  = 40'h01_00000001; instr_name[0]  = "ADDI x1, x0, 1";
        expected_trace[1]  = 40'h02_00000002; instr_name[1]  = "ADDI x2, x0, 2";
        expected_trace[2]  = 40'h03_00000001; instr_name[2]  = "SLTI x3, x1, 2";
        expected_trace[3]  = 40'h04_00000001; instr_name[3]  = "SLTIU x4, x1, -1 (unsigned)";
        expected_trace[4]  = 40'h05_00000002; instr_name[4]  = "XORI x5, x1, 3  (1^3=2)";
        expected_trace[5]  = 40'h06_00000003; instr_name[5]  = "ORI x6, x1, 2   (1|2=3)";
        expected_trace[6]  = 40'h07_00000002; instr_name[6]  = "ANDI x7, x6, 2  (3&2=2)";
        expected_trace[7]  = 40'h08_00000008; instr_name[7]  = "SLLI x8, x1, 3  (1<<3=8)";
        expected_trace[8]  = 40'h09_00000004; instr_name[8]  = "SRLI x9, x8, 1  (8>>1=4)";
        expected_trace[9]  = 40'h0A_FFFFFFFC; instr_name[9]  = "ADDI x10,x0,-4";
        expected_trace[10] = 40'h0B_FFFFFFFE; instr_name[10] = "SRAI x11,x10,1  (-4>>1=-2)";
        expected_trace[11] = 40'h0C_00001000; instr_name[11] = "LUI x12, 1      (0x1000)";
        expected_trace[12] = 40'h0D_00000030; instr_name[12] = "AUIPC x13, 0    (PC=0x30)";
        expected_trace[13] = 40'h0E_00000003; instr_name[13] = "ADD x14, x1, x2   (1+2=3)";
        expected_trace[14] = 40'h0F_00000001; instr_name[14] = "SUB x15, x2, x1   (2-1=1)";
        expected_trace[15] = 40'h10_00000004; instr_name[15] = "SLL x16, x1, x2   (1<<2=4)";
        expected_trace[16] = 40'h11_00000001; instr_name[16] = "SLT x17, x1, x2   (1<2)";
        expected_trace[17] = 40'h12_00000001; instr_name[17] = "SLTU x18,x1,x10   (1<unsigned)";
        expected_trace[18] = 40'h13_00000003; instr_name[18] = "XOR x19, x1, x2   (1^2=3)";
        expected_trace[19] = 40'h14_00000004; instr_name[19] = "SRL x20, x8, x1   (8>>1=4)";
        expected_trace[20] = 40'h15_FFFFFFFE; instr_name[20] = "SRA x21,x10,x1    (-4>>1=-2)";
        expected_trace[21] = 40'h16_00000003; instr_name[21] = "OR x22, x1, x2    (1|2=3)";
        expected_trace[22] = 40'h17_00000002; instr_name[22] = "AND x23, x5, x2   (2&2=2)";
        expected_trace[23] = 40'h18_FFFFFFFC; instr_name[23] = "LW  x24, 0(x0)    (Mem[0]=0xFFFFFFFC)";
        expected_trace[24] = 40'h19_FFFFFFFC; instr_name[24] = "LH  x25, 4(x0)    (sign_ext 0xFFFC)";
        expected_trace[25] = 40'h1A_0000FFFC; instr_name[25] = "LHU x26, 4(x0)    (zero_ext 0xFFFC)";
        expected_trace[26] = 40'h1B_FFFFFFFC; instr_name[26] = "LB  x27, 8(x0)    (sign_ext 0xFC)";
        expected_trace[27] = 40'h1C_000000FC; instr_name[27] = "LBU x28, 8(x0)    (zero_ext 0xFC)";
        expected_trace[28] = 40'h01_00000006; instr_name[28] = "ADDI x1, x0, 6    (M-ext setup)";
        expected_trace[29] = 40'h02_00000007; instr_name[29] = "ADDI x2, x0, 7";
        expected_trace[30] = 40'h03_0000002A; instr_name[30] = "MUL x3, x1, x2    (6*7=42)";
        expected_trace[31] = 40'h04_FFFFFFFD; instr_name[31] = "ADDI x4, x0, -3";
        expected_trace[32] = 40'h05_FFFFFFEB; instr_name[32] = "MUL x5, x4, x2    (-3*7=-21)";
        expected_trace[33] = 40'h06_FFFFFFFF; instr_name[33] = "MULH x6, x4, x2   (high(-3*7))";
        expected_trace[34] = 40'h07_00000000; instr_name[34] = "MULHU x7,x1,x2    (high(6u*7u)=0)";
        expected_trace[35] = 40'h08_FFFFFFFF; instr_name[35] = "MULHSU x8,x4,x1   (high(s(-3)*u(6)))";
        expected_trace[36] = 40'h09_00000000; instr_name[36] = "DIV x9, x1, x2    (6/7=0)";
        expected_trace[37] = 40'h0A_00000001; instr_name[37] = "DIV x10,x2,x1     (7/6=1)";
        expected_trace[38] = 40'h0B_00000006; instr_name[38] = "REM x11,x1,x2     (6%7=6)";
        expected_trace[39] = 40'h0C_00000001; instr_name[39] = "REM x12,x2,x1     (7%6=1)";
        expected_trace[40] = 40'h0D_00000000; instr_name[40] = "DIVU x13,x1,x2    (6/7 unsigned=0)";
        expected_trace[41] = 40'h0E_00000006; instr_name[41] = "REMU x14,x1,x2    (6%7 unsigned=6)";
        expected_trace[42] = 40'h01_00000005; instr_name[42] = "ADDI x1, x0, 5    (BEQ setup)";
        expected_trace[43] = 40'h02_00000005; instr_name[43] = "ADDI x2, x0, 5";
        expected_trace[44] = 40'h03_00000001; instr_name[44] = "BEQ TAKEN: x3=1   (5==5)";
        expected_trace[45] = 40'h01_00000003; instr_name[45] = "ADDI x1, x0, 3    (BNE setup)";
        expected_trace[46] = 40'h02_00000007; instr_name[46] = "ADDI x2, x0, 7";
        expected_trace[47] = 40'h04_00000001; instr_name[47] = "BNE TAKEN: x4=1   (3!=7)";
        expected_trace[48] = 40'h05_00000001; instr_name[48] = "BLT TAKEN: x5=1   (3<7 signed)";
        expected_trace[49] = 40'h01_00000007; instr_name[49] = "ADDI x1, x0, 7    (BGE setup)";
        expected_trace[50] = 40'h06_00000001; instr_name[50] = "BGE TAKEN: x6=1   (7>=7 signed)";
        expected_trace[51] = 40'h01_00000001; instr_name[51] = "ADDI x1, x0, 1    (BLTU setup)";
        expected_trace[52] = 40'h02_00000002; instr_name[52] = "ADDI x2, x0, 2";
        expected_trace[53] = 40'h07_00000001; instr_name[53] = "BLTU TAKEN: x7=1  (1<2 unsigned)";
        expected_trace[54] = 40'h08_00000001; instr_name[54] = "BGEU TAKEN: x8=1  (2>=1 unsigned)";
        expected_trace[55] = 40'h01_00000003; instr_name[55] = "ADDI x1, x0, 3    (BEQ-NT setup)";
        expected_trace[56] = 40'h02_00000007; instr_name[56] = "ADDI x2, x0, 7";
        expected_trace[57] = 40'h09_00000001; instr_name[57] = "BEQ NOT-TAKEN: x9=1  (3!=7)";
        expected_trace[58] = 40'h01_00000005; instr_name[58] = "ADDI x1, x0, 5    (BNE-NT setup)";
        expected_trace[59] = 40'h02_00000005; instr_name[59] = "ADDI x2, x0, 5";
        expected_trace[60] = 40'h0A_00000001; instr_name[60] = "BNE NOT-TAKEN: x10=1 (5==5)";
        expected_trace[61] = 40'h01_00000007; instr_name[61] = "ADDI x1, x0, 7    (BLT-NT setup)";
        expected_trace[62] = 40'h02_00000003; instr_name[62] = "ADDI x2, x0, 3";
        expected_trace[63] = 40'h0B_00000001; instr_name[63] = "BLT NOT-TAKEN: x11=1 (7 not<3)";
        expected_trace[64] = 40'h01_FFFFFFFB; instr_name[64] = "ADDI x1, x0, -5   (BGE-NT setup)";
        expected_trace[65] = 40'h02_00000003; instr_name[65] = "ADDI x2, x0, 3";
        expected_trace[66] = 40'h0C_00000001; instr_name[66] = "BGE NOT-TAKEN: x12=1 (-5 not>=3)";
        expected_trace[67] = 40'h01_00000005; instr_name[67] = "ADDI x1, x0, 5    (BLTU-NT setup)";
        expected_trace[68] = 40'h02_00000002; instr_name[68] = "ADDI x2, x0, 2";
        expected_trace[69] = 40'h0D_00000001; instr_name[69] = "BLTU NOT-TAKEN: x13=1 (5 not<2u)";
        expected_trace[70] = 40'h0E_00000001; instr_name[70] = "BGEU NOT-TAKEN: x14=1 (2 not>=5u)";
        expected_trace[71] = 40'h0F_0000018C; instr_name[71] = "JAL x15 (link=0x0000018C)";
        expected_trace[72] = 40'h10_00000001; instr_name[72] = "JAL TAKEN: x16=1";
        expected_trace[73] = 40'h11_000001A0; instr_name[73] = "ADDI x17,x0,0x1A0 (JALR base)";
        expected_trace[74] = 40'h12_0000019C; instr_name[74] = "JALR x18 (link=0x0000019C)";
        expected_trace[75] = 40'h13_00000001; instr_name[75] = "JALR TAKEN: x19=1";

        Ext_MemWrite  = 0;
        Ext_WriteData = 32'b0;
        Ext_DataAdr   = 32'b0;

        reset = 1;
        #22; 
        reset = 0;

        // Scale duration based on instruction count & memory delays
        #5000;
        
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