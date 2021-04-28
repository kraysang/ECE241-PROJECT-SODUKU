module drawNums(clk, enable, xCount, yCount, address, done);
//18x18
//num1 to num9
	input clk, enable;
	output 	reg [5:0]xCount;
	output 	reg [5:0]yCount;
	output reg [8:0]address;
	output reg done;
	
	initial begin
	xCount = 0;
	yCount = 0;
	address = 2;
	end	
	
	always @ (posedge clk)
	begin
	if (enable) begin
		if (xCount < 6'd17)
		         xCount <= xCount +1;
				
		else if (xCount==6'd17) begin
			if (yCount<6'd17) begin
				xCount<=0;
				yCount<=yCount+1;
			end
			else if (yCount==6'd17) done<=1; 
 			end 
		address <= address+9'b1;
		end
	    else begin 
		done <= 0; 
		xCount = 0;
		yCount = 0;
		address <= 2;
		end
	end
endmodule 
