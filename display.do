# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
vlog sodo.v
vlog starttop.v
vlog startbot.v
vlog draw_board.v
vlog wintop.v
vlog starttop.v
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
vlog blk.v
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
vlog drawbox.v
vlog btop.v
vlog bbot.v




#load simulation using mux as the top level simulation module
vsim -L altera_mf_ver display_num

#log all signals and add some signals to waveform window
log {/*}

# add wave {/*} would add all items in top level simulation module
add wave {/*}


#for clock_50
force {clk} 0 0ns, 1 1ns -r 2ns


force {input_num} 0
force {start_page} 0
force {over_page} 0
force {board_top_plot} 1
force {cursor_x} 10'd106
force {cursor_y} 9'd118
force {cursor_xold} 10'd106
force {cursor_yold} 9'd118
force {data_write} 0
force {num_delete} 0
force {cursor} 1
force {earse} 0
force {wrong} 0
run 180000ns
