transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example {C:/Users/qnt/Desktop/rng-vga-example/rng.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/snake_register.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/skeleton_proc.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/regfile.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/multdiv.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/latch_xm.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/latch_pc.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/latch_mw.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/latch_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/latch_dx.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/dflipflop.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example {C:/Users/qnt/Desktop/rng-vga-example/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example {C:/Users/qnt/Desktop/rng-vga-example/dmem.v}

vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/rng-vga-example/processor {C:/Users/qnt/Desktop/rng-vga-example/processor/proc_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  proc_tb

add wave *
view structure
view signals
run -all
