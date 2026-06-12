transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code {/home/adityaamehra/Desktop/rv32i-pipleined/code/t1c_riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code {/home/adityaamehra/Desktop/rv32i-pipleined/code/riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code {/home/adityaamehra/Desktop/rv32i-pipleined/code/data_mem.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/reset_ff.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/reg_file.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/mux4.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/mux2.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/main_decoder.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/imm_extend.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/datapath.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/controller.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/alu_decoder.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/alu.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/adder.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/reg_fd.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/reg_de.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/reg_em.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/reg_mw.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/datapath_fetch.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/datapath_decode.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code/components {/home/adityaamehra/Desktop/rv32i-pipleined/code/components/datapath_execute.v}
vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/code {/home/adityaamehra/Desktop/rv32i-pipleined/code/instr_mem.v}

vlog -vlog01compat -work work +incdir+/home/adityaamehra/Desktop/rv32i-pipleined/.test {/home/adityaamehra/Desktop/rv32i-pipleined/.test/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
