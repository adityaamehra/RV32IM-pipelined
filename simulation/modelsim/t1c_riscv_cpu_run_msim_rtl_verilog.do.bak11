transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/t1c_riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/data_mem.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/reset_ff.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/reg_file.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/mux4.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/mux2.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/main_decoder.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/imm_extend.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/datapath.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/controller.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/alu_decoder.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/alu.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/components/adder.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/code {/home/adityaamehra/Desktop/riscv32I-single-cycle/code/instr_mem.v}

vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/riscv32I-single-cycle/.test {/home/adityaamehra/Desktop/riscv32I-single-cycle/.test/tb_bubblesort.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_bubblesort

add wave *
view structure
view signals
run -all
