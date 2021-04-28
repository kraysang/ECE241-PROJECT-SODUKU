# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog sodo.v
vlog drawbox.v
#vlog draww.v
#vlog vga_adapter.v
#vlog vga_pll.v
#vlog vga_address_translator.v
#vlog vga_controller.v
#vlog displayy.v
vlog starttop.v
vlog startbot.v
vlog draw_board.v
vlog wintop.v
vlog winbot.v
vlog num1.v
vlog num2.v
vlog num3.v
vlog num4.v
vlog num5.v
vlog num6.v
vlog num7.v
vlog num8.v
vlog num9.v
#vlog blk.v
vlog drawNum.v
vlog incorrect1.v
vlog incorrect2.v
vlog incorrect3.v
vlog incorrect4.v
vlog incorrect5.v
vlog incorrect6.v
vlog incorrect7.v
vlog incorrect8.v
vlog incorrect9.v
vlog row17.v
vlog col19.v
vlog btop.v
vlog bbot.v
vlog keyboard.v
vlog PS2_Controller.v
vlog Altera_UP_PS2_Command_Out.v
vlog Altera_UP_PS2_Data_In.v

#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver finaltest


#log all signals and add some signals to waveform window
log {/*}

# add wave {/*} would add all items in top level simulation module
#add wave {/*}
add wave {/*}

#for clock_20?

force {CLOCK_50} 0 0ns, 1 5ns -r 10ns


force {SW[0]} 0
run 1000000ns


#force {key_space} 0
force {SW[0]} 1
run 1000000ns

force {key_num1} 1
run 1000ns

force {key_num1} 0
run 1000000ns

force {key_left} 1
run 1000ns

force {key_left} 0
run 1000000ns

force {key_up} 1
run 100ns

force {key_up} 0
run 1000000ns

force {key_num1} 1
run 1000ns

force {key_num1} 0
run 100000ns

force {key_delete} 1
run 1000ns

force {key_delete} 0
run 100000ns

force {key_num4} 1
run 1000ns

force {key_num4} 0
run 100000ns
