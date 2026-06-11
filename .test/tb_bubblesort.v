// tb_bubblesort.v
// Bubble Sort Benchmark Testbench for riscv32I-single-cycle
// Author  : Adityaa Mehra
// Purpose : Pre-loads an 8-element array into data memory,
//           runs the bubble sort program, and verifies the
//           sorted output element by element.
//
// BEFORE RUNNING:
//   1. Save the Venus hex output as  code/bubble_sort.hex
//   2. In code/instr_mem.v temporarily change:
//         $readmemh("rv32i_test.hex",  instr_ram);
//      to:
//         $readmemh("bubble_sort.hex", instr_ram);
//   3. Add this file to your Quartus project and set it
//      as the simulation top-level in ModelSim.
//   4. After testing, revert instr_mem.v to rv32i_test.hex.

`timescale 1ns/1ns

module tb_bubblesort;

    // ── Inputs ────────────────────────────────────────────────────
    reg         clk;
    reg         reset;
    reg         Ext_MemWrite;
    reg  [31:0] Ext_WriteData;
    reg  [31:0] Ext_DataAdr;

    // ── Outputs ───────────────────────────────────────────────────
    wire [31:0] WriteData, DataAdr, ReadData;
    wire        MemWrite;
    wire [31:0] PC, Result;

    // ── DUT ───────────────────────────────────────────────────────
    t1c_riscv_cpu uut (
        clk,
        reset,
        Ext_MemWrite,
        Ext_WriteData,
        Ext_DataAdr,
        MemWrite,
        WriteData,
        DataAdr,
        ReadData,
        PC,
        Result
    );

    // ── 10 ns clock (100 MHz) ─────────────────────────────────────
    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    // ── Expected sorted output ────────────────────────────────────
    // Input  : {64, 25, 12, 88, 37, 50,  3, 99}  (unsorted)
    // Output : { 3, 12, 25, 37, 50, 64, 88, 99}  (ascending)
    reg [31:0] expected [0:7];
    initial begin
        expected[0] = 32'd3;
        expected[1] = 32'd12;
        expected[2] = 32'd25;
        expected[3] = 32'd37;
        expected[4] = 32'd50;
        expected[5] = 32'd64;
        expected[6] = 32'd88;
        expected[7] = 32'd99;
    end

    // ── Cycle counter ─────────────────────────────────────────────
    integer cycle_count = 0;
    always @(posedge clk) begin
        if (!reset) cycle_count = cycle_count + 1;
    end

    // ── Sort completion detector ──────────────────────────────────
    // PC = 0x40 is the final  jal x0, done  (halt instruction)
    integer sort_done_cycle = -1;
    always @(negedge clk) begin
        if (!reset && PC === 32'h40 && sort_done_cycle === -1)
            sort_done_cycle = cycle_count;
    end

    // ── Live swap monitor ─────────────────────────────────────────
    always @(negedge clk) begin
        if (MemWrite && !reset)
            $display("  [cycle %0d] MEM WRITE -> addr=%0d  data=%0d",
                     cycle_count, DataAdr, WriteData);
    end

    // ── Main test flow ────────────────────────────────────────────
    integer pass_count = 0;
    integer i;

    initial begin

        // ----------------------------------------------------------
        // PHASE 1 : Hold reset, pre-load data memory via Ext port
        // ----------------------------------------------------------
        reset         = 1;
        Ext_MemWrite  = 0;
        Ext_DataAdr   = 32'd0;
        Ext_WriteData = 32'd0;

        @(posedge clk); #1;

        Ext_MemWrite = 1;

        Ext_DataAdr = 32'd0;  Ext_WriteData = 32'd64; @(posedge clk); #1;
        Ext_DataAdr = 32'd4;  Ext_WriteData = 32'd25; @(posedge clk); #1;
        Ext_DataAdr = 32'd8;  Ext_WriteData = 32'd12; @(posedge clk); #1;
        Ext_DataAdr = 32'd12; Ext_WriteData = 32'd88; @(posedge clk); #1;
        Ext_DataAdr = 32'd16; Ext_WriteData = 32'd37; @(posedge clk); #1;
        Ext_DataAdr = 32'd20; Ext_WriteData = 32'd50; @(posedge clk); #1;
        Ext_DataAdr = 32'd24; Ext_WriteData = 32'd3;  @(posedge clk); #1;
        Ext_DataAdr = 32'd28; Ext_WriteData = 32'd99; @(posedge clk); #1;

        Ext_MemWrite = 0;

        $display("");
        $display("=== Pre-load verification (before sort) ===");
        $display("  data_ram[0] = %3d  (expect  64)", uut.datamem.data_ram[0]);
        $display("  data_ram[1] = %3d  (expect  25)", uut.datamem.data_ram[1]);
        $display("  data_ram[2] = %3d  (expect  12)", uut.datamem.data_ram[2]);
        $display("  data_ram[3] = %3d  (expect  88)", uut.datamem.data_ram[3]);
        $display("  data_ram[4] = %3d  (expect  37)", uut.datamem.data_ram[4]);
        $display("  data_ram[5] = %3d  (expect  50)", uut.datamem.data_ram[5]);
        $display("  data_ram[6] = %3d  (expect   3)", uut.datamem.data_ram[6]);
        $display("  data_ram[7] = %3d  (expect  99)", uut.datamem.data_ram[7]);

        // ----------------------------------------------------------
        // PHASE 2 : Release reset — CPU starts executing bubble sort
        // ----------------------------------------------------------
        @(posedge clk); #1;
        reset = 0;

        $display("");
        $display("=== CPU running bubble sort... ===");

        // Wait until PC latches at 0x40 (halt) OR 1000 cycle timeout
        wait(sort_done_cycle !== -1 || cycle_count >= 1000);

        // A few extra cycles so the final write settles
        repeat(5) @(posedge clk);

        // ----------------------------------------------------------
        // PHASE 3 : Read back and verify sorted output
        // ----------------------------------------------------------
        $display("");
        $display("+-------+----------+----------+--------+");
        $display("| Index | Expected |   Got    | Status |");
        $display("+-------+----------+----------+--------+");

        for (i = 0; i < 8; i = i + 1) begin
            if (uut.datamem.data_ram[i] === expected[i]) begin
                $display("|  [%0d]  |    %3d   |    %3d   |  PASS  |",
                         i, expected[i], uut.datamem.data_ram[i]);
                pass_count = pass_count + 1;
            end else begin
                $display("|  [%0d]  |    %3d   |    %3d   |  FAIL  |",
                         i, expected[i], uut.datamem.data_ram[i]);
            end
        end

        $display("+-------+----------+----------+--------+");
        $display("");

        if (pass_count == 8) begin
            $display("######################################");
            $display("#  BUBBLE SORT : PASS  (%0d/8)       #", pass_count);
            $display("#  Completed in ~%0d cycles          #", sort_done_cycle);
            $display("######################################");
        end else begin
            $display("######################################");
            $display("#  BUBBLE SORT : FAIL  (%0d/8)       #", pass_count);
            $display("#  sort_done_cycle = %0d             #", sort_done_cycle);
            $display("#  Check hierarchy path & hex file   #");
            $display("######################################");
        end

        $display("");
        $stop;
    end

endmodule