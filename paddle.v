 module paddle 
	#(
		parameter MAX_X = 640,
		parameter MAX_Y = 480,
		parameter PADDLE_Y_LOW = 470,
		parameter PADDLE_Y_WIDTH = 3,
		parameter PADDLE_VELOCITY = 5,
		parameter PADDLE_LENGTH = 64,
		parameter PADDLE_COLOR_r = 5'b00110,
		parameter PADDLE_COLOR_g = 6'b000110,
		parameter PADDLE_COLOR_b = 5'b00110
	)
	(
		output paddle_on,
		output [4:0] paddle_rgb_r,paddle_rgb_b,
		output [5:0] paddle_rgb_g,
		output [10:0] paddle_left,paddle_right,
		input ref_tick,clk,left,right,reset,
		input [10:0] pix_x,pix_y
	);
	
	//localparam PADDLE_VELOCITY = 10;
	//localparam PADDLE_LENGTH = 72;
	
	//localparam PADDLE_X_LOW = 600;
	localparam PADDLE_Y_HIG = PADDLE_Y_LOW + PADDLE_Y_WIDTH;
	
	localparam PADDLE_X_LOW = 200;
	localparam PADDLE_X_HIG = PADDLE_X_LOW + PADDLE_LENGTH -  1;
	
	
	wire [10:0] paddle_x_low,paddle_x_hig;
	reg [10:0] paddle_x_reg,paddle_x_next;
	
	always @(posedge clk,posedge reset)
	if(reset)
		paddle_x_reg <= 0;
	else
		paddle_x_reg <= paddle_x_next;
		
	assign paddle_x_low = paddle_x_reg;
	assign paddle_x_hig = paddle_x_reg + PADDLE_LENGTH - 1;
	
	always @*
	begin
		paddle_x_next = paddle_x_reg;
		if(ref_tick)
			if(right & (paddle_x_hig <= MAX_X - PADDLE_VELOCITY - 1))
				paddle_x_next = paddle_x_reg + PADDLE_VELOCITY;
			else if(left & (paddle_x_low >= PADDLE_VELOCITY))
				paddle_x_next = paddle_x_reg - PADDLE_VELOCITY;
	end
	
	assign paddle_on = (pix_x >= paddle_x_low) && (pix_x <= paddle_x_hig) &&
					(pix_y >= PADDLE_Y_LOW) && (pix_y <= PADDLE_Y_HIG);
					
	assign paddle_rgb_r = PADDLE_COLOR_r;
	assign paddle_rgb_g = PADDLE_COLOR_g;
	assign paddle_rgb_b = PADDLE_COLOR_b;
	assign paddle_left = paddle_x_low;
	assign paddle_right = paddle_x_hig;
endmodule
