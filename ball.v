module ball
	#(
		parameter BALL_VEL_P = 1,
		parameter BALL_VEL_N = -1,
		parameter BALL_SIZE = 8,
		parameter MIN_X = 0,
		parameter MIN_Y = 0,
		parameter MAX_X = 640,
		parameter MAX_Y = 480,
		parameter LOWER_LIMIT_X = 5,
		parameter UPPER_LIMIT_X = 635,
		parameter LOWER_LIMIT_Y = 5,
		parameter UPPER_LIMIT_Y = 479,
		parameter BALL_COLOR_r = 5'b11111,
		parameter BALL_COLOR_g = 6'b111111,
		parameter BALL_COLOR_b = 5'b11111,
		parameter PADDLE_SIZE = 64,
		parameter PADDLE_WIDTH = 5,
		//parameter LEFT_PADDLE_X_LOW = 6,
		parameter PADDLE_Y_LOW  = 470,
		
		parameter BRICK1_LEFT = 150,
		parameter BRICK1_RIGHT = 180,
		parameter BRICK1_UP = 100,
		parameter BRICK1_DOWN = 120,
		
		
		parameter BRICK2_LEFT = 350,
		parameter BRICK2_RIGHT = 380,
		parameter BRICK2_UP = 100,
		parameter BRICK2_DOWN = 120,
		
		parameter BRICK3_LEFT = 250,
		parameter BRICK3_RIGHT = 280,
		parameter BRICK3_UP = 100,
		parameter BRICK3_DOWN = 120,
		
		parameter BRICK4_LEFT = 450,
		parameter BRICK4_RIGHT = 480,
		parameter BRICK4_UP = 100,
		parameter BRICK4_DOWN = 120,
		
		parameter BRICK5_LEFT = 100,
		parameter BRICK5_RIGHT = 130,
		parameter BRICK5_UP = 140,
		parameter BRICK5_DOWN = 160,
		
		parameter BRICK6_LEFT = 200,
		parameter BRICK6_RIGHT = 230,
		parameter BRICK6_UP = 140,
		parameter BRICK6_DOWN = 160,
		
		parameter BRICK7_LEFT = 300,
		parameter BRICK7_RIGHT = 330,
		parameter BRICK7_UP = 140,
		parameter BRICK7_DOWN = 160,
		
		parameter BRICK8_LEFT = 400,
		parameter BRICK8_RIGHT = 430,
		parameter BRICK8_UP = 140,
		parameter BRICK8_DOWN = 160,
		
		parameter BRICK9_LEFT = 500,
		parameter BRICK9_RIGHT = 530,
		parameter BRICK9_UP = 140,
		parameter BRICK9_DOWN = 160,
		
		parameter BRICK11_LEFT = 150,
		parameter BRICK11_RIGHT = 180,
		parameter BRICK11_UP = 180,
		parameter BRICK11_DOWN = 200,
		
		
		parameter BRICK12_LEFT = 350,
		parameter BRICK12_RIGHT = 380,
		parameter BRICK12_UP = 180,
		parameter BRICK12_DOWN = 200,
		
		parameter BRICK13_LEFT = 250,
		parameter BRICK13_RIGHT = 280,
		parameter BRICK13_UP = 180,
		parameter BRICK13_DOWN = 200,
		
		parameter BRICK14_LEFT = 450,
		parameter BRICK14_RIGHT = 480,
		parameter BRICK14_UP = 180,
		parameter BRICK14_DOWN = 200
		
		)
	(
		output wall_hit, paddle_hit , 
		output brick1_vis , brick2_vis, brick3_vis, brick4_vis , brick5_vis , brick6_vis, brick7_vis, brick8_vis , brick9_vis, brick11_vis , brick12_vis, brick13_vis, brick14_vis,
		//output brick1_hit , brick2_hit, brick3_hit, brick4_hit , brick5_hit , brick6_hit, brick7_hit, brick8_hit , brick9_hit, brick11_hit , brick12_hit, brick13_hit, brick14_hit,
		output bound_hit,//left_bound_hit,
		output ball_on, 
		//output reg alt_colour,
		output [4:0] ball_rgb_r,ball_rgb_b,
		output [5:0] ball_rgb_g,
		input clk,reset,ref_tick,
		input [10:0] paddle_left,paddle_right,//left_paddle_top,left_paddle_bottem,
		input [10:0]pix_x,pix_y
	);
	
	
	//localparam LEFT_PADDLE_X_HIG = LEFT_PADDLE_X_LOW + PADDLE_WIDTH;
	localparam PADDLE_Y_HIG = PADDLE_Y_LOW + PADDLE_WIDTH;
	
	//ball velociy registors
	reg [10:0] x_vel_reg, y_vel_reg;
	reg [10:0] x_vel_next, y_vel_next;
	reg brick1_reg_vis , brick2_reg_vis , brick3_reg_vis , brick4_reg_vis , brick5_reg_vis , brick6_reg_vis , brick7_reg_vis , brick8_reg_vis, brick9_reg_vis , brick11_reg_vis , brick12_reg_vis , brick13_reg_vis , brick14_reg_vis;
	
	wire brick1_hit_u , brick1_hit_d , brick1_hit_r , brick1_hit_l;
	wire brick2_hit_u , brick2_hit_d , brick2_hit_r , brick2_hit_l;
	wire brick3_hit_u , brick3_hit_d , brick3_hit_r , brick3_hit_l;
	wire brick4_hit_u , brick4_hit_d , brick4_hit_r , brick4_hit_l;
	wire brick5_hit_u , brick5_hit_d , brick5_hit_r , brick5_hit_l;
	wire brick6_hit_u , brick6_hit_d , brick6_hit_r , brick6_hit_l;
	wire brick7_hit_u , brick7_hit_d , brick7_hit_r , brick7_hit_l;
	wire brick8_hit_u , brick8_hit_d , brick8_hit_r , brick8_hit_l;
	wire brick9_hit_u , brick9_hit_d , brick9_hit_r , brick9_hit_l;
	wire brick11_hit_u , brick11_hit_d , brick11_hit_r , brick11_hit_l;
	wire brick12_hit_u , brick12_hit_d , brick12_hit_r , brick12_hit_l;
	wire brick13_hit_u , brick13_hit_d , brick13_hit_r , brick13_hit_l;
	wire brick14_hit_u , brick14_hit_d , brick14_hit_r , brick14_hit_l;
	
	//ball position registors
	reg [10:0] ball_x_reg, ball_y_reg;
	wire [10:0] ball_x_next, ball_y_next;
	
	//ball boundary signals
	wire [10:0] ball_x_low,ball_x_hig,ball_y_low,ball_y_hig;
	
	//brick boundary signals
	wire brick1_next_vis;
	wire brick2_next_vis;
	wire brick3_next_vis;
	wire brick4_next_vis;
	wire brick5_next_vis;
	wire brick6_next_vis;
	wire brick7_next_vis;
	wire brick8_next_vis;
	wire brick9_next_vis;
	wire brick11_next_vis;
	wire brick12_next_vis;
	wire brick13_next_vis;
	wire brick14_next_vis;
	
	 //wire paddle_hit;// right_paddle_hit;
	
	always @(posedge clk,posedge reset)
		if(reset)
		 begin
			x_vel_reg <= BALL_VEL_P;
			y_vel_reg <= BALL_VEL_P;
			ball_x_reg <= MAX_X/2;
			ball_y_reg <= MAX_Y/2;
			brick1_reg_vis <= 0;
			brick2_reg_vis <= 0;
			brick3_reg_vis <= 0;
			brick4_reg_vis <= 0;
			brick5_reg_vis <= 0;
			brick6_reg_vis <= 0;
			brick7_reg_vis <= 0;
			brick8_reg_vis <= 0;
			brick9_reg_vis <= 0;
			brick11_reg_vis <= 0;
			brick12_reg_vis <= 0;
			brick13_reg_vis <= 0;
			brick14_reg_vis <= 0;
		 end
		else
		 begin
			x_vel_reg <= x_vel_next;
			y_vel_reg <= y_vel_next;
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next; 
			brick1_reg_vis <= brick1_next_vis;
			brick2_reg_vis <= brick2_next_vis;
			brick3_reg_vis <= brick3_next_vis;
			brick4_reg_vis <= brick4_next_vis;
			brick5_reg_vis <= brick5_next_vis;
			brick6_reg_vis <= brick6_next_vis;
			brick7_reg_vis <= brick7_next_vis;
			brick8_reg_vis <= brick8_next_vis;
			brick9_reg_vis <= brick9_next_vis;
			brick11_reg_vis <= brick11_next_vis;
			brick12_reg_vis <= brick12_next_vis;
			brick13_reg_vis <= brick13_next_vis;
			brick14_reg_vis <= brick14_next_vis;
		 end
	
	//new ball position
	assign ball_x_next = (ref_tick) ? (bound_hit? MAX_X/2 : ball_x_reg + x_vel_reg): ball_x_reg;
	assign ball_y_next = (ref_tick) ? (bound_hit? MAX_Y/2 : ball_y_reg + y_vel_reg): ball_y_reg;
	
	//ball boundaries
	assign ball_x_low = ball_x_reg;
	assign ball_x_hig = ball_x_reg + BALL_SIZE - 1;
	assign ball_y_low = ball_y_reg;
	assign ball_y_hig = ball_y_reg + BALL_SIZE - 1;
	
	//ball velocity calcuations and collision detection
	always @*
	 begin
		x_vel_next = x_vel_reg;
		y_vel_next = y_vel_reg;
		if(ball_y_low < 5)//top
				y_vel_next = BALL_VEL_P;
		
		else if(ball_x_hig > (MAX_X-6)) // right
				x_vel_next = BALL_VEL_N;
 
		else if(ball_x_low < 5) //left
				x_vel_next = BALL_VEL_P;

		else if(paddle_hit)
				y_vel_next = BALL_VEL_N;
				
				//

		else if(brick1_hit_u && (~brick1_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick1_hit_d && (~brick1_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick1_hit_l && (~brick1_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick1_hit_r && (~brick1_vis))
				x_vel_next = BALL_VEL_P;
				
				////

		else if(brick2_hit_u && (~brick2_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick2_hit_d && (~brick2_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick2_hit_l && (~brick2_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick2_hit_r && (~brick2_vis))
				x_vel_next = BALL_VEL_P;
				
				/////
				
		else if(brick3_hit_u && (~brick3_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick3_hit_d && (~brick3_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick3_hit_l && (~brick3_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick3_hit_r && (~brick3_vis))
				x_vel_next = BALL_VEL_P;
				
				/////	

		else if(brick4_hit_u && (~brick4_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick4_hit_d && (~brick4_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick4_hit_l && (~brick4_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick4_hit_r && (~brick4_vis))
				x_vel_next = BALL_VEL_P;	

/////	

		else if(brick5_hit_u && (~brick5_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick5_hit_d && (~brick5_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick5_hit_l && (~brick5_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick5_hit_r && (~brick5_vis))
				x_vel_next = BALL_VEL_P;
				
				//////

      else if(brick6_hit_u && (~brick6_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick6_hit_d && (~brick6_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick6_hit_l && (~brick6_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick6_hit_r && (~brick6_vis))
				x_vel_next = BALL_VEL_P;

				//////

      else if(brick7_hit_u && (~brick7_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick7_hit_d && (~brick7_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick7_hit_l && (~brick7_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick7_hit_r && (~brick7_vis))
				x_vel_next = BALL_VEL_P;

//////

      else if(brick8_hit_u && (~brick8_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick8_hit_d && (~brick8_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick8_hit_l && (~brick8_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick8_hit_r && (~brick8_vis))
				x_vel_next = BALL_VEL_P;	


//////

      else if(brick9_hit_u && (~brick9_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick9_hit_d && (~brick9_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick9_hit_l && (~brick9_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick9_hit_r && (~brick9_vis))
				x_vel_next = BALL_VEL_P;	


//

		else if(brick11_hit_u && (~brick11_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick11_hit_d && (~brick11_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick11_hit_l && (~brick11_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick11_hit_r && (~brick11_vis))
				x_vel_next = BALL_VEL_P;
				
				////

		else if(brick12_hit_u && (~brick12_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick12_hit_d && (~brick12_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick12_hit_l && (~brick12_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick12_hit_r && (~brick12_vis))
				x_vel_next = BALL_VEL_P;
				
				/////
				
		else if(brick13_hit_u && (~brick13_vis))
				y_vel_next = BALL_VEL_N;	

		else if(brick13_hit_d && (~brick13_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick13_hit_l && (~brick13_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick13_hit_r && (~brick13_vis))
				x_vel_next = BALL_VEL_P;
				
				/////	

		else if(brick14_hit_u && (~brick14_vis))
				y_vel_next = BALL_VEL_N;	
				
		else if(brick14_hit_d && (~brick14_vis))
				y_vel_next = BALL_VEL_P;	
					
		else if(brick14_hit_l && (~brick14_vis))
				x_vel_next = BALL_VEL_N;	

		else if(brick14_hit_r && (~brick14_vis))
				x_vel_next = BALL_VEL_P;				
			
	 end 
	 
	 
	/* always @*
				if( ((ball_x_low <= 5) && (ball_x_hig >=5)) || ((ball_x_hig >= 635) && (ball_x_low <= 635)) || ((ball_y_low <= 5) && (ball_y_hig >=5)))
						alt_colour = 1;
						
				else		
						alt_colour = 0; */
		
	//output
	assign bound_hit = (ball_y_hig == UPPER_LIMIT_Y);
	//assign right_bound_hit = (ball_x_hig == UPPER_LIMIT_X);
	assign ball_on = ((pix_x <= ball_x_hig - 1) && (pix_x >= ball_x_low) && (pix_y <= ball_y_hig -1) && (pix_y >= ball_y_low));
	assign ball_rgb_r = BALL_COLOR_r;
	assign ball_rgb_g = BALL_COLOR_g;
	assign ball_rgb_b = BALL_COLOR_b;
	assign wall_hit = (ball_y_low < 1) || (ball_x_hig > MAX_X - 1) || (ball_x_low < 1);
	assign paddle_hit = (ball_x_hig > paddle_left) && (ball_x_low < paddle_right) && (ball_y_hig > PADDLE_Y_LOW) &&(PADDLE_Y_HIG > ball_y_hig);
	
	//brick1
	assign brick1_hit_u = (ball_x_hig > BRICK1_LEFT) && (ball_x_low < BRICK1_RIGHT) && (ball_y_hig > BRICK1_UP) && (ball_y_low < BRICK1_UP);
	assign brick1_hit_d = (ball_x_hig > BRICK1_LEFT) && (ball_x_low < BRICK1_RIGHT) && (ball_y_hig > BRICK1_DOWN) && (ball_y_low < BRICK1_DOWN);
	assign brick1_hit_l = (ball_x_hig > BRICK1_LEFT) && (ball_x_low < BRICK1_LEFT) && (ball_y_low > BRICK1_UP) && (ball_y_hig < BRICK1_DOWN);
	assign brick1_hit_r = (ball_x_hig > BRICK1_RIGHT) && (ball_x_low < BRICK1_RIGHT) && (ball_y_low > BRICK1_UP) && (ball_y_hig < BRICK1_DOWN);

	assign brick1_hit = (brick1_hit_u || brick1_hit_d || brick1_hit_l || brick1_hit_r);
	
	assign brick1_next_vis = (brick1_hit) ? 1 : brick1_reg_vis;																				
				
	//brick2
	assign brick2_hit_d = (ball_x_hig > BRICK2_LEFT) && (ball_x_low < BRICK2_RIGHT) && (ball_y_hig > BRICK2_DOWN) && (ball_y_low < BRICK2_DOWN);
	assign brick2_hit_u = (ball_x_hig > BRICK2_LEFT) && (ball_x_low < BRICK2_RIGHT) && (ball_y_hig > BRICK2_UP) && (ball_y_low < BRICK2_UP);
	assign brick2_hit_l = (ball_x_hig > BRICK2_LEFT) && (ball_x_low < BRICK2_LEFT) && (ball_y_low < BRICK2_DOWN) && (ball_y_hig > BRICK2_UP);
	assign brick2_hit_r = (ball_x_low < BRICK2_RIGHT) && (ball_x_hig > BRICK2_RIGHT) && (ball_y_low < BRICK2_DOWN) && (ball_y_hig > BRICK2_UP);

	assign brick2_hit = (brick2_hit_u || brick2_hit_l || brick2_hit_d || brick2_hit_r);
	
	assign brick2_next_vis = (brick2_hit) ? 1 : brick2_reg_vis;

	//brick3
	assign brick3_hit_d = (ball_x_hig > BRICK3_LEFT) && (ball_x_low < BRICK3_RIGHT) && (ball_y_hig > BRICK3_DOWN) && (ball_y_low < BRICK3_DOWN);
	assign brick3_hit_u = (ball_x_hig > BRICK3_LEFT) && (ball_x_low < BRICK3_RIGHT) && (ball_y_hig > BRICK3_UP) && (ball_y_low < BRICK3_UP);
	assign brick3_hit_l = (ball_x_hig > BRICK3_LEFT) &&(ball_x_low < BRICK3_LEFT) && (ball_y_low < BRICK3_DOWN) && (ball_y_hig > BRICK3_UP);
	assign brick3_hit_r = (ball_x_low < BRICK3_RIGHT) && (ball_x_hig > BRICK3_RIGHT) &&(ball_y_low < BRICK3_DOWN) && (ball_y_hig > BRICK3_UP);

	assign brick3_hit = (brick3_hit_u || brick3_hit_l || brick3_hit_d || brick3_hit_r );
	
	assign brick3_next_vis = (brick3_hit) ? 1 : brick3_reg_vis;
	
	//brick4
	assign brick4_hit_d = (ball_x_hig > BRICK4_LEFT) && (ball_x_low < BRICK4_RIGHT) && (ball_y_hig > BRICK4_DOWN) && (ball_y_low < BRICK4_DOWN);
	assign brick4_hit_u = (ball_x_hig > BRICK4_LEFT) && (ball_x_low < BRICK4_RIGHT) && (ball_y_hig > BRICK4_UP) && (ball_y_low < BRICK4_UP);
	assign brick4_hit_l = (ball_x_hig > BRICK4_LEFT) &&(ball_x_low < BRICK4_LEFT) && (ball_y_low < BRICK4_DOWN) && (ball_y_hig > BRICK4_UP);
	assign brick4_hit_r = (ball_x_low < BRICK4_RIGHT) && (ball_x_hig > BRICK4_RIGHT) &&(ball_y_low < BRICK4_DOWN) && (ball_y_hig > BRICK4_UP);

	assign brick4_hit = (brick4_hit_u || brick4_hit_l || brick4_hit_d || brick4_hit_r );
	
	assign brick4_next_vis = (brick4_hit) ? 1 : brick4_reg_vis;
	
	//brick5
	assign brick5_hit_d = (ball_x_hig > BRICK5_LEFT) && (ball_x_low < BRICK5_RIGHT) && (ball_y_hig > BRICK5_DOWN) && (ball_y_low < BRICK5_DOWN);
	assign brick5_hit_u = (ball_x_hig > BRICK5_LEFT) && (ball_x_low < BRICK5_RIGHT) && (ball_y_hig > BRICK5_UP) && (ball_y_low < BRICK5_UP);
	assign brick5_hit_l = (ball_x_hig > BRICK5_LEFT) &&(ball_x_low < BRICK5_LEFT) && (ball_y_low < BRICK5_DOWN) && (ball_y_hig > BRICK5_UP);
	assign brick5_hit_r = (ball_x_low < BRICK5_RIGHT) && (ball_x_hig > BRICK5_RIGHT) &&(ball_y_low < BRICK5_DOWN) && (ball_y_hig > BRICK5_UP);

	assign brick5_hit = (brick5_hit_u || brick5_hit_l || brick5_hit_d || brick5_hit_r );
	
	assign brick5_next_vis = (brick5_hit) ? 1 : brick5_reg_vis;
	
	//brick6
	assign brick6_hit_d = (ball_x_hig > BRICK6_LEFT) && (ball_x_low < BRICK6_RIGHT) && (ball_y_hig > BRICK6_DOWN) && (ball_y_low < BRICK6_DOWN);
	assign brick6_hit_u = (ball_x_hig > BRICK6_LEFT) && (ball_x_low < BRICK6_RIGHT) && (ball_y_hig > BRICK6_UP) && (ball_y_low < BRICK6_UP);
	assign brick6_hit_l = (ball_x_hig > BRICK6_LEFT) &&(ball_x_low < BRICK6_LEFT) && (ball_y_low < BRICK6_DOWN) && (ball_y_hig > BRICK6_UP);
	assign brick6_hit_r = (ball_x_low < BRICK6_RIGHT) && (ball_x_hig > BRICK6_RIGHT) &&(ball_y_low < BRICK6_DOWN) && (ball_y_hig > BRICK6_UP);

	assign brick6_hit = (brick6_hit_u || brick6_hit_l || brick6_hit_d || brick6_hit_r );
	
	assign brick6_next_vis = (brick6_hit) ? 1 : brick6_reg_vis;
	
	//brick7
	assign brick7_hit_d = (ball_x_hig > BRICK7_LEFT) && (ball_x_low < BRICK7_RIGHT) && (ball_y_hig > BRICK7_DOWN) && (ball_y_low < BRICK7_DOWN);
	assign brick7_hit_u = (ball_x_hig > BRICK7_LEFT) && (ball_x_low < BRICK7_RIGHT) && (ball_y_hig > BRICK7_UP) && (ball_y_low < BRICK7_UP);
	assign brick7_hit_l = (ball_x_hig > BRICK7_LEFT) &&(ball_x_low < BRICK7_LEFT) && (ball_y_low < BRICK7_DOWN) && (ball_y_hig > BRICK7_UP);
	assign brick7_hit_r = (ball_x_low < BRICK7_RIGHT) && (ball_x_hig > BRICK7_RIGHT) &&(ball_y_low < BRICK7_DOWN) && (ball_y_hig > BRICK7_UP);

	assign brick7_hit = (brick7_hit_u || brick7_hit_l || brick7_hit_d || brick7_hit_r );
	
	assign brick7_next_vis = (brick7_hit) ? 1 : brick7_reg_vis;
	
	//brick8
	assign brick8_hit_d = (ball_x_hig > BRICK8_LEFT) && (ball_x_low < BRICK8_RIGHT) && (ball_y_hig > BRICK8_DOWN) && (ball_y_low < BRICK8_DOWN);
	assign brick8_hit_u = (ball_x_hig > BRICK8_LEFT) && (ball_x_low < BRICK8_RIGHT) && (ball_y_hig > BRICK8_UP) && (ball_y_low < BRICK8_UP);
	assign brick8_hit_l = (ball_x_hig > BRICK8_LEFT) &&(ball_x_low < BRICK8_LEFT) && (ball_y_low < BRICK8_DOWN) && (ball_y_hig > BRICK8_UP);
	assign brick8_hit_r = (ball_x_low < BRICK8_RIGHT) && (ball_x_hig > BRICK8_RIGHT) &&(ball_y_low < BRICK8_DOWN) && (ball_y_hig > BRICK8_UP);

	assign brick8_hit = (brick8_hit_u || brick8_hit_l || brick8_hit_d || brick8_hit_r );
	assign brick8_next_vis = (brick8_hit) ? 1 : brick8_reg_vis;

	//brick9
	assign brick9_hit_d = (ball_x_hig > BRICK9_LEFT) && (ball_x_low < BRICK9_RIGHT) && (ball_y_hig > BRICK9_DOWN) && (ball_y_low < BRICK9_DOWN);
	assign brick9_hit_u = (ball_x_hig > BRICK9_LEFT) && (ball_x_low < BRICK9_RIGHT) && (ball_y_hig > BRICK9_UP) && (ball_y_low < BRICK9_UP);
	assign brick9_hit_l = (ball_x_hig > BRICK9_LEFT) &&(ball_x_low < BRICK9_LEFT) && (ball_y_low < BRICK9_DOWN) && (ball_y_hig > BRICK9_UP);
	assign brick9_hit_r = (ball_x_low < BRICK9_RIGHT) && (ball_x_hig > BRICK9_RIGHT) &&(ball_y_low < BRICK9_DOWN) && (ball_y_hig > BRICK9_UP);

	assign brick9_hit = (brick9_hit_u || brick9_hit_l || brick9_hit_d || brick9_hit_r );
	assign brick9_next_vis = (brick9_hit) ? 1 : brick9_reg_vis;
	
	
	//brick11
	assign brick11_hit_u = (ball_x_hig > BRICK11_LEFT) && (ball_x_low < BRICK11_RIGHT) && (ball_y_hig > BRICK11_UP) && (ball_y_low < BRICK11_UP);
	assign brick11_hit_d = (ball_x_hig > BRICK11_LEFT) && (ball_x_low < BRICK11_RIGHT) && (ball_y_hig > BRICK11_DOWN) && (ball_y_low < BRICK11_DOWN);
	assign brick11_hit_l = (ball_x_hig > BRICK11_LEFT) && (ball_x_low < BRICK11_LEFT) && (ball_y_low > BRICK11_UP) && (ball_y_hig < BRICK11_DOWN);
	assign brick11_hit_r = (ball_x_hig > BRICK11_RIGHT) && (ball_x_low < BRICK11_RIGHT) && (ball_y_low > BRICK11_UP) && (ball_y_hig < BRICK11_DOWN);

	assign brick11_hit = (brick11_hit_u || brick11_hit_d || brick11_hit_l || brick11_hit_r);
	
	assign brick11_next_vis = (brick11_hit) ? 1 : brick11_reg_vis;																				
				
	//brick2
	assign brick12_hit_d = (ball_x_hig > BRICK12_LEFT) && (ball_x_low < BRICK12_RIGHT) && (ball_y_hig > BRICK12_DOWN) && (ball_y_low < BRICK12_DOWN);
	assign brick12_hit_u = (ball_x_hig > BRICK12_LEFT) && (ball_x_low < BRICK12_RIGHT) && (ball_y_hig > BRICK12_UP) && (ball_y_low < BRICK12_UP);
	assign brick12_hit_l = (ball_x_hig > BRICK12_LEFT) && (ball_x_low < BRICK12_LEFT) && (ball_y_low < BRICK12_DOWN) && (ball_y_hig > BRICK12_UP);
	assign brick12_hit_r = (ball_x_low < BRICK12_RIGHT) && (ball_x_hig > BRICK12_RIGHT) && (ball_y_low < BRICK12_DOWN) && (ball_y_hig > BRICK12_UP);

	assign brick12_hit = (brick12_hit_u || brick12_hit_l || brick12_hit_d || brick12_hit_r);
	
	assign brick12_next_vis = (brick12_hit) ? 1 : brick12_reg_vis;

	//brick3
	assign brick13_hit_d = (ball_x_hig > BRICK13_LEFT) && (ball_x_low < BRICK13_RIGHT) && (ball_y_hig > BRICK13_DOWN) && (ball_y_low < BRICK13_DOWN);
	assign brick13_hit_u = (ball_x_hig > BRICK13_LEFT) && (ball_x_low < BRICK13_RIGHT) && (ball_y_hig > BRICK13_UP) && (ball_y_low < BRICK13_UP);
	assign brick13_hit_l = (ball_x_hig > BRICK13_LEFT) &&(ball_x_low < BRICK13_LEFT) && (ball_y_low < BRICK13_DOWN) && (ball_y_hig > BRICK13_UP);
	assign brick13_hit_r = (ball_x_low < BRICK13_RIGHT) && (ball_x_hig > BRICK13_RIGHT) &&(ball_y_low < BRICK13_DOWN) && (ball_y_hig > BRICK13_UP);

	assign brick13_hit = (brick13_hit_u || brick13_hit_l || brick13_hit_d || brick13_hit_r );
	
	assign brick13_next_vis = (brick13_hit) ? 1 : brick13_reg_vis;
	
	//brick14
	assign brick14_hit_d = (ball_x_hig > BRICK14_LEFT) && (ball_x_low < BRICK14_RIGHT) && (ball_y_hig > BRICK14_DOWN) && (ball_y_low < BRICK14_DOWN);
	assign brick14_hit_u = (ball_x_hig > BRICK14_LEFT) && (ball_x_low < BRICK14_RIGHT) && (ball_y_hig > BRICK14_UP) && (ball_y_low < BRICK14_UP);
	assign brick14_hit_l = (ball_x_hig > BRICK14_LEFT) &&(ball_x_low < BRICK14_LEFT) && (ball_y_low < BRICK14_DOWN) && (ball_y_hig > BRICK14_UP);
	assign brick14_hit_r = (ball_x_low < BRICK14_RIGHT) && (ball_x_hig > BRICK14_RIGHT) &&(ball_y_low < BRICK14_DOWN) && (ball_y_hig > BRICK14_UP);

	assign brick14_hit = (brick14_hit_u || brick14_hit_l || brick14_hit_d || brick14_hit_r );
	
	assign brick14_next_vis = (brick14_hit) ? 1 : brick14_reg_vis;

	

		assign brick1_vis = brick1_reg_vis;	
		assign brick2_vis = brick2_reg_vis;
		assign brick3_vis = brick3_reg_vis;
		assign brick4_vis = brick4_reg_vis;
		assign brick5_vis = brick5_reg_vis;
		assign brick6_vis = brick6_reg_vis;
		assign brick7_vis = brick7_reg_vis;
		assign brick8_vis = brick8_reg_vis;
		assign brick9_vis = brick9_reg_vis;
		assign brick11_vis = brick11_reg_vis;	
		assign brick12_vis = brick12_reg_vis;
		assign brick13_vis = brick13_reg_vis;
		assign brick14_vis = brick14_reg_vis;

endmodule 