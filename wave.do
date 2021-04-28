# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog sodo.v

#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver control


#log all signals and add some signals to waveform window
log {/*}

# add wave {/*} would add all items in top level simulation module
#add wave {/*}
add wave {/*}

#for clock_20?
force {clk_slow} 0 0ns, 1 20ns -r 50ns
force {clk_fast} 0 0ns, 1 5ns -r 10ns

force {resetn} 0
force {key_up} 0
force {key_down} 0
force {key_left} 0
force {key_right} 0
force {key_space} 0
force {key_delete} 0
force {key_num1} 0
force {key_num2} 0
run 200ns


force {board_occu[323:0]} 0
force {resetn} 1
run 200ns


force {key_space} 1
run 200ns

force {key_space} 0
run 200ns

force {key_left} 1
run 200ns

force {key_left} 0
force {key_right} 1
run 200ns

force {key_left} 0
force {key_right} 0
run 200ns

force {key_num1} 1
run 200ns

force {key_num1} 0
run 200ns