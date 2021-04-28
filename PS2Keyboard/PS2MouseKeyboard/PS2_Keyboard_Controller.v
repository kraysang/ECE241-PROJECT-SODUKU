
module keyboard_tracker #(parameter PULSE_OR_HOLD = 0) (
    input clock,
	 input reset,
	 
	 inout PS2_CLK,
	 inout PS2_DAT,
	 
	 output w, a, s, d,
	 output left, right, up, down,
	 output space, enter
	 );
	 
	 // A flag indicating when the keyboard has sent a new byte.
	 wire byte_received;
	 // The most recent byte received from the keyboard.
	 wire [7:0] newest_byte;
	 	 
	 localparam // States indicating the type of code the controller expects
	            // to receive next.
	            MAKE            = 2'b00,
	            BREAK           = 2'b01,
					SECONDARY_MAKE  = 2'b10,
					SECONDARY_BREAK = 2'b11,
					
					// Make/break codes for all keys that are handled by this
					// controller. Two keys may have the same make/break codes
					// if one of them is a secondary code.
					// TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS	
					W_CODE = 8'h1d,
					A_CODE = 8'h1c,
					S_CODE = 8'h1b,
					D_CODE = 8'h23,
					LEFT_CODE  = 8'h6b,
					RIGHT_CODE = 8'h74,
					UP_CODE    = 8'h75,
					DOWN_CODE  = 8'h72,
					SPACE_CODE = 8'h29,
					ENTER_CODE = 8'h5a;
					
    reg [1:0] curr_state;
	 
	 // Press signals are high when their corresponding key is being pressed,
	 // and low otherwise. They directly represent the keyboard's state.
	 // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS	 
    reg w_press, a_press, s_press, d_press;
	 reg left_press, right_press, up_press, down_press;
	 reg space_press, enter_press;
	 
	 // Lock signals prevent a key press signal from going high for more than one
	 // clock tick when pulse mode is enabled. A key becomes 'locked' as soon as
	 // it is pressed down.
	 // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
	 reg w_lock, a_lock, s_lock, d_lock;
	 reg left_lock, right_lock, up_lock, down_lock;
	 reg space_lock, enter_lock;
	 
	 // Output is equal to the key press wires in mode 0 (hold), and is similar in
	 // mode 1 (pulse) except the signal is lowered when the key's lock goes high.
	 // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
    assign w = w_press && ~(w_lock && PULSE_OR_HOLD);
    assign a = a_press && ~(a_lock && PULSE_OR_HOLD);
    assign s = s_press && ~(s_lock && PULSE_OR_HOLD);
    assign d = d_press && ~(d_lock && PULSE_OR_HOLD);

    assign left  = left_press && ~(left_lock && PULSE_OR_HOLD);
    assign right = right_press && ~(right_lock && PULSE_OR_HOLD);
    assign up    = up_press && ~(up_lock && PULSE_OR_HOLD);
    assign down  = down_press && ~(down_lock && PULSE_OR_HOLD);

    assign space = space_press && ~(space_lock && PULSE_OR_HOLD);
    assign enter = enter_press && ~(enter_lock && PULSE_OR_HOLD);
	 
	 // Core PS/2 driver.
	 PS2_Controller #(.INITIALIZE_MOUSE(0)) core_driver(
	     .CLOCK_50(clock),
		  .reset(~reset),
		  .PS2_CLK(PS2_CLK),
		  .PS2_DAT(PS2_DAT),
		  .received_data(newest_byte),
		  .received_data_en(byte_received)
		  );
		  
    always @(posedge clock) begin
	     // Make is default state. State transitions are handled
        // at the bottom of the case statement below.
		  curr_state <= MAKE;
		  
		  // Lock signals rise the clock tick after the key press signal rises,
		  // and fall one clock tick after the key press signal falls. This way,
		  // only the first clock cycle has the press signal high while the
		  // lock signal is low.
		  // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
		  w_lock <= w_press;
		  a_lock <= a_press;
		  s_lock <= s_press;
		  d_lock <= d_press;
		  
		  left_lock <= left_press;
		  right_lock <= right_press;
		  up_lock <= up_press;
		  down_lock <= down_press;
		  
		  space_lock <= space_press;
		  enter_lock <= enter_press;
		  
	     if (~reset) begin
		      curr_state <= MAKE;
				
				// TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
				w_press <= 1'b0;
				a_press <= 1'b0;
				s_press <= 1'b0;
				d_press <= 1'b0;
				left_press  <= 1'b0;
				right_press <= 1'b0;
				up_press    <= 1'b0;
				down_press  <= 1'b0;
				space_press <= 1'b0;
				enter_press <= 1'b0;
				
				w_lock <= 1'b0;
				a_lock <= 1'b0;
				s_lock <= 1'b0;
				d_lock <= 1'b0;
				left_lock  <= 1'b0;
				right_lock <= 1'b0;
				up_lock    <= 1'b0;
				down_lock  <= 1'b0;
				space_lock <= 1'b0;
				enter_lock <= 1'b0;
        end
		  else if (byte_received) begin
		      // Respond to the newest byte received from the keyboard,
				// by either making or breaking the specified key, or changing
				// state according to special bytes.
				case (newest_byte)
				    // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
		          W_CODE: w_press <= curr_state == MAKE;
					 A_CODE: a_press <= curr_state == MAKE;
					 S_CODE: s_press <= curr_state == MAKE;
					 D_CODE: d_press <= curr_state == MAKE;
					 
					 LEFT_CODE:  left_press  <= curr_state == MAKE;
					 RIGHT_CODE: right_press <= curr_state == MAKE;
					 UP_CODE:    up_press    <= curr_state == MAKE;
					 DOWN_CODE:  down_press  <= curr_state == MAKE;
					 
					 SPACE_CODE: space_press <= curr_state == MAKE;
					 ENTER_CODE: enter_press <= curr_state == MAKE;

					 // State transition logic.
					 // An F0 signal indicates a key is being released. An E0 signal
					 // means that a secondary signal is being used, which will be
					 // followed by a regular set of make/break signals.
					 8'he0: curr_state <= SECONDARY_MAKE;
					 8'hf0: curr_state <= curr_state == MAKE ? BREAK : SECONDARY_BREAK;
		      endcase
        end
        else begin
		      // Default case if no byte is received.
		      curr_state <= curr_state;
		  end
    end
endmodule


/**
 * ########
 * TESTING
 * ########
 *
 * The modules below will test the functionality of the keyboard controller
 * in this file. Each of the two modules tests one mode of the keyboard, which is
 * specified in the module name. The ten default keys supported by the controller
 * are all displayed on LEDR. Behaviours of the LEDs are described in the test
 * modules' documentation headers.
 *
 * Keys are mapped to the LEDs as follows:
 *
 * Left, right, up, down arrows = LEDR[0 - 3]
 * WASD      = LEDR[4 - 7]
 * Space bar = LEDR[8]
 * Enter     = LEDR[9]
 *
 * Pressing KEY[0] causes the system to reset.
 *
 * If none of the lights turn on when any of those keys are pressed, it is
 * possible that the core PS/2 driver does not work on your board. In that
 * case you should find another keyboard controller that works for your board.
 * For any other problems, it is probably the case that registers are being
 * updated at the wrong clock ticks. For that case, it may be worth
 * disconnecting the controller from its core driver and manually setting the
 * bytes received from the keyboard in a Modelsim simulation. Another option
 * is to add several outputs to the keyboard_tracker module which are assigned
 * to the few most recently received bytes from the keyboard. These bytes can
 * be displayed on hex displays (hex decoder module not provided) to see what
 * codes are arriving from the keyboard.
 *
 * To test extra keys that you have added to the controller, simply change the
 * output ports on the keyboard controller module instantiated inside to
 * include your new keys. How these keys are displayed on the LEDs is up to you,
 * and you may remove and reassign any outputs on the LEDs for keys that are
 * not used by your project.
 *
 *
 * BUG REMINDER:
 * The core driver does not behave normally when at least two of the arrow keys
 * are held at the same time as another arrow key is pressed. This includes
 * instances when three or more arrow keys are pressed simultaneously.
 * Which keys are registered as being pressed in such an event may be undefined.
 */

/**
 * Tester module for mode 0 (hold) mode. LED's on the board should turn on whenever
 * the corresponding key is pressed, and turn off when the key is released.
 */ 
module keyboard_interface_test_mode0(
    input CLOCK_50,
	 input [3:0] KEY,
	 
	 inout PS2_CLK,
	 inout PS2_DAT,
	 
	 output [9:0] LEDR
	 );
	 
	 keyboard_tracker #(.PULSE_OR_HOLD(0)) tester(
	     .clock(CLOCK_50),
		  .reset(KEY[0]),
		  .PS2_CLK(PS2_CLK),
		  .PS2_DAT(PS2_DAT),
		  .w(LEDR[4]),
		  .a(LEDR[5]),
		  .s(LEDR[6]),
		  .d(LEDR[7]),
		  .left(LEDR[0]),
		  .right(LEDR[1]),
		  .up(LEDR[2]),
		  .down(LEDR[3]),
		  .space(LEDR[8]),
		  .enter(LEDR[9])
		  );
endmodule


/**
 * Tester module for mode 1 (pulse). LEDs on the board should flip once as soon
 * as the corresponding key is pressed down. Holding a key should not continue
 * to change the output, nor should the output change on key release.
 */ 
module keyboard_interface_test_mode1(
    input CLOCK_50,
	 input [3:0] KEY,
	 
	 inout PS2_CLK,
	 inout PS2_DAT,
	 
	 output [9:0] LEDR
	 );
	 
	 // Wires representing direct output from the keyboard controller.
	 wire w_pulse,
	      a_pulse,
			s_pulse,
			d_pulse,
			left_pulse,
			right_pulse,
			up_pulse,
			down_pulse,
			space_pulse,
			enter_pulse;
			
    // Registers holding the values displayed on the LEDs.
    reg  w_tot,
	      a_tot,
			s_tot,
			d_tot,
			left_tot,
			right_tot,
			up_tot,
			down_tot,
			space_tot,
			enter_tot;

    assign LEDR[4] = w_tot;
	 assign LEDR[5] = a_tot;
	 assign LEDR[6] = s_tot;
	 assign LEDR[7] = d_tot;
	 assign LEDR[0] = left_tot;
	 assign LEDR[1] = right_tot;
	 assign LEDR[2] = up_tot;
	 assign LEDR[3] = down_tot;
	 assign LEDR[8] = space_tot;
	 assign LEDR[9] = enter_tot;
	 
	 keyboard_tracker #(.PULSE_OR_HOLD(1)) tester_mode1(
	     .clock(CLOCK_50),
		  .reset(KEY[0]),
		  .PS2_CLK(PS2_CLK),
		  .PS2_DAT(PS2_DAT),
		  .w(w_pulse),
		  .a(a_pulse),
		  .s(s_pulse),
		  .d(d_pulse),
		  .left(left_pulse),
		  .right(right_pulse),
		  .up(up_pulse),
		  .down(down_pulse),
		  .space(space_pulse),
		  .enter(enter_pulse)
		  );

    always @(posedge CLOCK_50) begin
	     if (~KEY[0]) begin
		      // Reset signal
		      w_tot <= 1'b0;
				a_tot <= 1'b0;
				s_tot <= 1'b0;
				d_tot <= 1'b0;
				
				left_tot  <= 1'b0;
				right_tot <= 1'b0;
				up_tot    <= 1'b0;
				down_tot  <= 1'b0;
				
				space_tot <= 1'b0;
				enter_tot <= 1'b0;
		  end
		  else begin
		      // State display wires (xxx_tot) flip values when their
				// corresponding key is pressed.
	         w_tot <= w_tot + w_pulse;
		      a_tot <= a_tot + a_pulse;
		      s_tot <= s_tot + s_pulse;
		      d_tot <= d_tot + d_pulse;
				
		      left_tot <= left_tot + left_pulse;
		      right_tot <= right_tot + right_pulse;
		      up_tot <= up_tot + up_pulse;
		      down_tot <= down_tot + down_pulse;
				
		      space_tot <= space_tot + space_pulse;
		      enter_tot <= enter_tot + enter_pulse;
		  end
    end
endmodule