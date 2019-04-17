transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {skeleton.vo}

vlog -vlog01compat -work work +incdir+C:/Users/qnt/Desktop/vga-example/processor {C:/Users/qnt/Desktop/vga-example/processor/proc_tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  proc_tb

add wave *
view structure
view signals
run -all
