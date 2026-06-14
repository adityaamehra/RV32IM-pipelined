# RV32IM-pipelined

A 5-stage pipelined RISC-V processor implementing the **RV32I** base integer ISA plus the **M** (multiply/divide) extension, written in Verilog and targeted at an Intel/Altera **Cyclone IV E (EP4CE30F23C6)** FPGA via Quartus Prime.

The design follows the classic Harris & Harris (`SARV32I`-style) single-cycle datapath, restructured into a 5-stage pipeline (**IF → ID → EX → MEM → WB**) with full hazard handling: data forwarding, load-use stalling, and branch/jump flushing.

## Features

- **Full RV32I base ISA**: all R-, I-, S-, B-, U-, and J-type instructions (arithmetic/logic, shifts, loads/stores, branches, `jal`/`jalr`, `lui`/`auipc`).
- **RV32M extension**: `mul`, `mulh`, `mulhsu`, `mulhu`, `div`, `divu`, `rem`, `remu`.
- **5-stage pipeline**: Fetch, Decode, Execute, Memory, Writeback, with dedicated pipeline registers between each stage.
- **Hazard unit**:
  - Data forwarding from the MEM and WB stages into EX (`ForwardAE` / `ForwardBE`).
  - Load-use hazard detection with a single-cycle stall + bubble.
  - Branch/jump misprediction handled by flushing the Decode and Execute stages.
- **External memory access port** on the top module for pre-loading data memory from a testbench (used by the bubble-sort benchmark).
- Quartus Prime project ready for synthesis/fitting onto a Cyclone IV E device, plus ModelSim simulation artifacts.

## Repository structure

```
RV32IM-pipelined/
├── code/
│   ├── t1c_riscv_cpu.v          # Top-level module (instantiates CPU + memories)
│   ├── riscv_cpu.v               # CPU wrapper (instantiates the datapath)
│   ├── instr_mem.v               # Instruction memory (512 x 32-bit, $readmemh loaded)
│   ├── data_mem.v                 # Data memory (64 x 32-bit)
│   ├── rv32i_test.s               # Hand-written RV32I/M assembly test program
│   ├── rv32i_test.hex             # Assembled hex for rv32i_test.s
│   ├── rv32i_book.hex             # Hex program from the Harris & Harris textbook example
│   ├── bubble_sort.hex            # Bubble-sort benchmark program
│   └── components/
│       ├── datapath.v             # Top-level pipelined datapath (wires all stages together)
│       ├── datapath_fetch.v       # IF stage: PC mux, PC register, PC+4 adder
│       ├── reg_fd.v                # IF/ID pipeline register
│       ├── datapath_decode.v      # ID stage: register file + immediate generator
│       ├── reg_de.v                # ID/EX pipeline register
│       ├── datapath_execute.v     # EX stage: forwarding muxes, ALU, branch/jump target adder
│       ├── reg_em.v                # EX/MEM pipeline register
│       ├── reg_mw.v                # MEM/WB pipeline register (also handles load size/sign extension)
│       ├── hazard_unit.v           # Forwarding, stalling and flushing logic
│       ├── controller.v            # Top-level control unit
│       ├── main_decoder.v          # Opcode -> control signal decoder
│       ├── alu_decoder.v           # funct3/funct7 -> ALU control decoder (incl. RV32M)
│       ├── alu.v                   # ALU (RV32I ops + MUL/MULH/MULHU/MULHSU/DIV/DIVU/REM/REMU)
│       ├── imm_extend.v            # Immediate sign/zero extension for I/S/B/U/J formats
│       ├── reg_file.v              # 32 x 32-bit register file (x0 hardwired to 0)
│       ├── adder.v                 # Generic 32-bit adder
│       ├── mux2.v / mux3.v / mux4.v # Parameterized multiplexers
│       └── reset_ff.v              # Resettable, enable-gated register
├── .test/
│   ├── tb.v                        # ISA testbench: checks 76 register writebacks against rv32i_test.s
│   └── tb_bubblesort.v             # Bubble-sort benchmark testbench
├── simulation/modelsim/            # Quartus-generated ModelSim simulation files
├── db/, incremental_db/, output_files/  # Quartus compilation artifacts (auto-generated)
├── t1c_riscv_cpu.qpf               # Quartus project file
├── t1c_riscv_cpu.qsf               # Quartus settings (device, file list, top-level entity)
└── t1c_riscv_cpu.qws               # Quartus workspace file
```

## Architecture

![architecture](https://github.com/adityaamehra/RV32IM-pipelined/blob/main/arch.png)

| Stage | Module(s) | Responsibility |
|---|---|---|
| **IF** (Fetch) | `fetch_datapath` (`datapath_fetch.v`), `instr_mem.v` | Selects next PC (sequential, branch/jump target, or stall), fetches instruction |
| **ID** (Decode) | `decode_datapath` (`datapath_decode.v`), `controller.v`, `main_decoder.v`, `alu_decoder.v`, `imm_extend.v`, `reg_file.v` | Reads register file, sign/zero-extends immediates, decodes control signals |
| **EX** (Execute) | `execute_datapath` (`datapath_execute.v`), `alu.v` | Applies forwarding, runs the ALU (incl. RV32M ops), computes branch/jump target |
| **MEM** (Memory) | `data_mem.v` | Performs load/store accesses to data memory |
| **WB** (Writeback) | `reg_mw.v`, `mux4` (`ResultMux`) | Sign/zero-extends loaded data, selects final result (ALU / memory / PC+4) to write back to the register file |

Pipeline registers (`reg_fd`, `reg_de`, `reg_em`, `reg_mw`) carry both data and control signals between stages, and support flush (clear) and stall (hold) behavior driven by the `hazard_unit`.

### Hazard handling

- **Forwarding** — `hazard_unit.v` compares `Rs1E`/`Rs2E` against `RdM`/`RdW` and sets `ForwardAE`/`ForwardBE` so the EX stage can bypass results from the MEM or WB stage instead of waiting for the register file.
- **Load-use stall** — if an instruction in ID needs the result of a `load` currently in EX, `lwStall` stalls the **IF** and **ID** stages for one cycle and inserts a bubble (flush) into EX.
- **Control hazards** — branch and jump outcomes are resolved in EX. When `PCSrcE` is asserted, the **ID** and **EX** stages are flushed (`FlushD`, `FlushE_final`) and fetch redirects to `PCTargetE`.

## ALU control encoding (`alu_decoder.v` → `alu.v`)

| `ALUControl` | Operation |
|---|---|
| `0000` | ADD / ADDI / AUIPC / LUI base |
| `0001` | SUB |
| `0010` | AND / ANDI |
| `0011` | OR / ORI |
| `0100` | MUL / MULH / MULHSU / MULHU (selected by `funct3`) |
| `0101` | SLT / SLTI |
| `1000` | SLL / SLLI |
| `1001` | SLTU / SLTIU |
| `1010` | XOR / XORI |
| `1011` | SRL / SRLI |
| `1100` | SRA / SRAI |
| `1110` | DIV / DIVU (selected by `funct3`) |
| `1111` | REM / REMU (selected by `funct3`) |

M-extension operations are recognized via `funct7 == 7'b0000001` on R-type instructions; `funct3` then selects the specific multiply/divide/remainder variant.
