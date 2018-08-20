module bricks
	#(
		
		parameter BRICK_LEFT = 100,
		parameter BRICK_RIGHT = 140,
		parameter BRICK_UP = 100,
		parameter BRICK_DOWN = 110,
		parameter BRICK_COLOR_r = 5'b00110,
		parameter BRICK_COLOR_g = 6'b100011,
		parameter BRICK_COLOR_b = 5'b10011
	)
	(
		output brick_on,
		output [4:0] brick_rgb_r,brick_rgb_b,
		output [5:0] brick_rgb_g,
		//input clk,reset,
		input [10:0] pix_x,pix_y,
		input brick_vis
	);
	

	
	assign brick_on = ((BRICK_LEFT <= pix_x) && (pix_x <=  BRICK_RIGHT) &&
					(pix_y >= BRICK_UP) && (pix_y <= BRICK_DOWN)) && (~brick_vis);
					
	assign brick_rgb_r = BRICK_COLOR_r;
	assign brick_rgb_g = BRICK_COLOR_g;
	assign brick_rgb_b = BRICK_COLOR_b;
	
endmodule
