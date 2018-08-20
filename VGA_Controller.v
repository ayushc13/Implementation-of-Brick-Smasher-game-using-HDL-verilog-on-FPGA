module VGA_Controller
	(
		//output [7:0] debug_led,
		output [4:0] rgb_r,rgb_b,
		output [5:0]rgb_g,
		output hsync,vsync,
		output speaker1,
		output reg led,
		//input [2:0] sw,
		input CLOCK_50,r,left,right
		);
	
	//screen size
	localparam MAX_X = 640;
	localparam MAX_Y = 475;
	
	//paddle constants
	localparam PADDLE_WIDTH = 3,PADDLE_VELOCITY = 5,PADDLE_LENGTH = 64;
	
	//left paddle constants
	localparam LEFT_PADDLE_POS = 30;
	localparam LEFT_PADDLE_COLOR_r = 5'b00100;
	localparam LEFT_PADDLE_COLOR_g = 6'b100100;
	localparam LEFT_PADDLE_COLOR_b = 5'b00100;

	//right paddle position
	localparam RIGHT_PADDLE_POS = 30;
	localparam RIGHT_PADDLE_COLOR_r = 5'b00101;
	localparam RIGHT_PADDLE_COLOR_g = 6'b001001;
	localparam RIGHT_PADDLE_COLOR_b = 5'b11001;
	
	//wall constants 
	localparam L_TOP = 0;
	localparam M_TOP = 0;
	localparam R_TOP = 0;
	localparam L_BOTTEM = MAX_Y;
	localparam M_BOTTEM = 5;
	localparam R_BOTTEM = MAX_Y;
	
	localparam L_LEFT = 0;
	localparam L_RIGHT = 5;
	
	localparam M_LEFT = 0;
	localparam M_RIGHT = MAX_X;
	
	localparam R_LEFT = MAX_X - 5;
	localparam R_RIGHT = MAX_X;
	
	
	wire reset, pause;
	
	reg [4:0] rgb_reg_r,rgb_reg_b,rgb_next_r,rgb_next_b;
	reg [5:0]rgb_reg_g,rgb_next_g;
	wire [4:0] left_paddle_rgb_r,left_paddle_rgb_b,right_paddle_rgb_r,right_paddle_rgb_b;
	wire [5:0] right_paddle_rgb_g , left_paddle_rgb_g;
	wire [4:0]ball_rgb_r , ball_rgb_b;
	wire [5:0]ball_rgb_g;
	wire pixel_tick,video_on,ref_tick,left_paddle_on,right_paddle_on,ball_on;
	
	wire [10:0] pixel_x,pixel_y,/*left_paddle_top,left_paddle_bottem,*/paddle_left,paddle_rigt;
	
	
	vga_sync vsync_unit1 (
		.clk(CLOCK_50),
		.reset(reset),
		.h_sync(hsync),
		.v_sync(vsync),
		.video_on(video_on),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y),
		.p_tick(pixel_tick));
		
	paddle  #(
		.PADDLE_Y_LOW(470),
		.PADDLE_COLOR_r(5'b00000),
		.PADDLE_COLOR_g(6'b000000),
		.PADDLE_COLOR_b(5'b11111),
		.PADDLE_Y_WIDTH(5))		paddle_right (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.ref_tick(ref_tick),
		.clk(CLOCK_50),
		.left(left),
		.right(right),
		.reset(reset),
		.paddle_on(right_paddle_on),
		.paddle_rgb_r(right_paddle_rgb_r),
		.paddle_rgb_g(right_paddle_rgb_g),
		.paddle_rgb_b(right_paddle_rgb_b),
		.paddle_left(paddle_left),
		.paddle_right(paddle_rigt)
	);
	
	wire brick_on1 , brick_on2 , brick_on3 , brick_on4 ,brick_on5 , brick_on6 , brick_on7 , brick_on8 ;
	wire brick_on11 , brick_on12 , brick_on13 , brick_on14;
   wire brick1_hit , brick2_hit , brick3_hit , brick4_hit, brick5_hit, brick6_hit, brick7_hit, brick8_hit; 
	wire brick11_hit , brick12_hit , brick13_hit , brick14_hit;
	wire brick1_vis , brick2_vis , brick3_vis , brick4_vis , brick5_vis ,brick6_vis , brick7_vis , brick8_vis, brick9_vis;
	wire brick11_vis , brick12_vis , brick13_vis , brick14_vis;
	wire [4:0]brick_rgb_r1 , brick_rgb_r2 , brick_rgb_b1 , brick_rgb_b2 , brick_rgb_b3 , brick_rgb_r3, brick_rgb_b4 , brick_rgb_r4, brick_rgb_b5 , brick_rgb_r5, brick_rgb_b6 , brick_rgb_r6, brick_rgb_b7 , brick_rgb_r7, brick_rgb_b8 , brick_rgb_r8, brick_rgb_b9 , brick_rgb_r9;
	wire [4:0]brick_rgb_r11 , brick_rgb_r12 , brick_rgb_b11 , brick_rgb_b12 , brick_rgb_b13 , brick_rgb_r13, brick_rgb_b14 , brick_rgb_r14;
	wire [5:0]brick_rgb_g1 , brick_rgb_g2 , brick_rgb_g3, brick_rgb_g4 , brick_rgb_g5 , brick_rgb_g6 , brick_rgb_g7, brick_rgb_g8, brick_rgb_g9;
	wire [5:0]brick_rgb_g11 , brick_rgb_g12 , brick_rgb_g13, brick_rgb_g14;
	//wire alt_colour;
 wire [4:0]brick_total;
	
 	bricks #( 
		.BRICK_RIGHT(180),
		.BRICK_LEFT(150),
		.BRICK_UP(100),
		.BRICK_DOWN(120),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_1  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick1_vis),
		.brick_on(brick_on1),
		.brick_rgb_r(brick_rgb_r1),
		.brick_rgb_g(brick_rgb_g1),
		.brick_rgb_b(brick_rgb_b1)
	); 
	
	bricks #(
		.BRICK_RIGHT(380),
		.BRICK_LEFT(350),
		.BRICK_UP(100),
		.BRICK_DOWN(120),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b010100),
		.BRICK_COLOR_b(5'b10011)) brick_unit_2  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick2_vis),
		.brick_on(brick_on2),
		.brick_rgb_r(brick_rgb_r2),
		.brick_rgb_g(brick_rgb_g2),
		.brick_rgb_b(brick_rgb_b2)
	);
	
	
	bricks #(
		.BRICK_RIGHT(280),
		.BRICK_LEFT(250),
		.BRICK_UP(100),
		.BRICK_DOWN(120),
		.BRICK_COLOR_r(5'b00000),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_3  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick3_vis),
		.brick_on(brick_on3),
		.brick_rgb_r(brick_rgb_r3),
		.brick_rgb_g(brick_rgb_g3),
		.brick_rgb_b(brick_rgb_b3)
	);
	
	
	bricks #(
		.BRICK_RIGHT(480),
		.BRICK_LEFT(450),
		.BRICK_UP(100),
		.BRICK_DOWN(120),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b000000),
		.BRICK_COLOR_b(5'b00000)) brick_unit_4  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick4_vis),
		.brick_on(brick_on4),
		.brick_rgb_r(brick_rgb_r4),
		.brick_rgb_g(brick_rgb_g4),
		.brick_rgb_b(brick_rgb_b4)
	);
	
	
	bricks #(
		.BRICK_RIGHT(130),
		.BRICK_LEFT(100),
		.BRICK_UP(140),
		.BRICK_DOWN(160),
		.BRICK_COLOR_r(5'b00000),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_5  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick5_vis),
		.brick_on(brick_on5),
		.brick_rgb_r(brick_rgb_r5),
		.brick_rgb_g(brick_rgb_g5),
		.brick_rgb_b(brick_rgb_b5)
	);
	
	bricks #(
		.BRICK_RIGHT(230),
		.BRICK_LEFT(200),
		.BRICK_UP(140),
		.BRICK_DOWN(160),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b000000),
		.BRICK_COLOR_b(5'b00000)) brick_unit_6  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick6_vis),
		.brick_on(brick_on6),
		.brick_rgb_r(brick_rgb_r6),
		.brick_rgb_g(brick_rgb_g6),
		.brick_rgb_b(brick_rgb_b6)
	);
	
	bricks #(
		.BRICK_RIGHT(330),
		.BRICK_LEFT(300),
		.BRICK_UP(140),
		.BRICK_DOWN(160),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b010100),
		.BRICK_COLOR_b(5'b10011)) brick_unit_7  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick7_vis),
		.brick_on(brick_on7),
		.brick_rgb_r(brick_rgb_r7),
		.brick_rgb_g(brick_rgb_g7),
		.brick_rgb_b(brick_rgb_b7)
	);
	
	bricks #(
		.BRICK_RIGHT(430),
		.BRICK_LEFT(400),
		.BRICK_UP(140),
		.BRICK_DOWN(160),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_8 (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick8_vis),
		.brick_on(brick_on8),
		.brick_rgb_r(brick_rgb_r8),
		.brick_rgb_g(brick_rgb_g8),
		.brick_rgb_b(brick_rgb_b8)
	);
	
	
	bricks #(
		.BRICK_RIGHT(530),
		.BRICK_LEFT(500),
		.BRICK_UP(140),
		.BRICK_DOWN(160),
		.BRICK_COLOR_r(5'b00000),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_9 (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick9_vis),
		.brick_on(brick_on9),
		.brick_rgb_r(brick_rgb_r9),
		.brick_rgb_g(brick_rgb_g9),
		.brick_rgb_b(brick_rgb_b9)
	);
	
	
	
	bricks #( 
		.BRICK_RIGHT(180),
		.BRICK_LEFT(150),
		.BRICK_UP(180),
		.BRICK_DOWN(200),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_11  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick11_vis),
		.brick_on(brick_on11),
		.brick_rgb_r(brick_rgb_r11),
		.brick_rgb_g(brick_rgb_g11),
		.brick_rgb_b(brick_rgb_b11)
	); 
	
	bricks #(
		.BRICK_RIGHT(380),
		.BRICK_LEFT(350),
		.BRICK_UP(180),
		.BRICK_DOWN(200),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b010100),
		.BRICK_COLOR_b(5'b10011)) brick_unit_12  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick12_vis),
		.brick_on(brick_on12),
		.brick_rgb_r(brick_rgb_r12),
		.brick_rgb_g(brick_rgb_g12),
		.brick_rgb_b(brick_rgb_b12)
	);
	
	
	bricks #(
		.BRICK_RIGHT(280),
		.BRICK_LEFT(250),
		.BRICK_UP(180),
		.BRICK_DOWN(200),
		.BRICK_COLOR_r(5'b00000),
		.BRICK_COLOR_g(6'b111111),
		.BRICK_COLOR_b(5'b00000)) brick_unit_13  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick13_vis),
		.brick_on(brick_on13),
		.brick_rgb_r(brick_rgb_r13),
		.brick_rgb_g(brick_rgb_g13),
		.brick_rgb_b(brick_rgb_b13)
	);
	
	
	bricks #(
		.BRICK_RIGHT(480),
		.BRICK_LEFT(450),
		.BRICK_UP(180),
		.BRICK_DOWN(200),
		.BRICK_COLOR_r(5'b11111),
		.BRICK_COLOR_g(6'b000000),
		.BRICK_COLOR_b(5'b00000)) brick_unit_14  (
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.brick_vis(brick14_vis),
		.brick_on(brick_on14),
		.brick_rgb_r(brick_rgb_r14),
		.brick_rgb_g(brick_rgb_g14),
		.brick_rgb_b(brick_rgb_b14)
	);
	
	assign brick_total = brick1_vis + brick2_vis + brick3_vis + brick4_vis + brick5_vis + brick6_vis + brick7_vis + brick8_vis + brick9_vis + brick11_vis + brick12_vis + brick13_vis + brick14_vis;
		always @*
			if(brick_total == 5'b01101)
				led = 1;
			else 
            led = 0;			
	
	wire goal_hit,wall_hit,paddle_hit;
   ball 
		#(
			.UPPER_LIMIT_X(639),
			.LOWER_LIMIT_X(0)
		)
		playing_ball
		(
			.clk(CLOCK_50),
			.reset(reset),
			.paddle_left(paddle_left),
			.paddle_right(paddle_rigt),
			//.alt_colour(alt_colour),
			.ref_tick(ref_tick),
			.pix_x(pixel_x),
			.pix_y(pixel_y),
			.ball_on(ball_on),
			.ball_rgb_r(ball_rgb_r),
			.ball_rgb_g(ball_rgb_g),
			.ball_rgb_b(ball_rgb_b),
			//.left_bound_hit(left_goal_hit),
			.bound_hit(right_goal_hit),
			.paddle_hit(paddle_hit),
			.brick1_vis(brick1_vis),
			.brick2_vis(brick2_vis),
			.brick3_vis(brick3_vis),
			.brick4_vis(brick4_vis),
			.brick5_vis(brick5_vis),
			.brick6_vis(brick6_vis),
			.brick7_vis(brick7_vis),
			.brick8_vis(brick8_vis),
			.brick9_vis(brick9_vis),
			.brick11_vis(brick11_vis),
			.brick12_vis(brick12_vis),
			.brick13_vis(brick13_vis),
			.brick14_vis(brick14_vis),
			.wall_hit(wall_hit)
		);
		
		
	//wall genration circuit
	wire [4:0] left_goal_rgb_r,mid_wall_rgb_r,right_goal_rgb_r;
	wire [5:0] left_goal_rgb_g,mid_wall_rgb_g,right_goal_rgb_g;
	wire [4:0] left_goal_rgb_b,mid_wall_rgb_b,right_goal_rgb_b;
	wire left_goal_on,mid_wall_on,right_goal_on;
		
	
	wall #(
		.TOP(L_TOP),
		.BOTTEM(L_BOTTEM),
		.LEFT(L_LEFT),
		.RIGHT(L_RIGHT)
	) left_wall
	(
		.wall_on(left_goal_on),
		.wall_rgb_r(left_goal_rgb_r),
		.wall_rgb_g(left_goal_rgb_g),
		.wall_rgb_b(left_goal_rgb_b),
		.pix_x(pixel_x),
		.pix_y(pixel_y)
	);
	
	wall #(
		.TOP(M_TOP),
		.BOTTEM(M_BOTTEM),
		.LEFT(M_LEFT),
		.RIGHT(M_RIGHT)
	) top_wall
	(
		.wall_on(mid_wall_on),
		.wall_rgb_r(mid_wall_rgb_r),
		.wall_rgb_g(mid_wall_rgb_g),
		.wall_rgb_b(mid_wall_rgb_b),
		.pix_x(pixel_x),
		.pix_y(pixel_y)
	);
	
	wall #(
		.TOP(R_TOP),
		.BOTTEM(R_BOTTEM),
		.LEFT(R_LEFT),
		.RIGHT(R_RIGHT)
	) right_wall
	(
		.wall_on(right_goal_on),
		.wall_rgb_r(right_goal_rgb_r),
		.wall_rgb_g(right_goal_rgb_g),
		.wall_rgb_b(right_goal_rgb_b),
		.pix_x(pixel_x),
		.pix_y(pixel_y)
	);
	
	//score keeping
	wire left_text_on;
	wire [4:0] left_text_rgb_r;
	wire [5:0] left_text_rgb_g;
	wire [4:0] left_text_rgb_b;
	//wire left_inc;
	wire left_score_max;
	edge_detector edge_unit1
	(
		.tick(left_inc),
		.clk(CLOCK_50),
		.reset(reset),
		.in(right_goal_hit)
	);
	score_keeper left_score
		(
			.text_on(left_text_on),
			.text_rgb_r(left_text_rgb_r),
			.text_rgb_g(left_text_rgb_g),
			.text_rgb_b(left_text_rgb_b),
			.pix_x(pixel_x),
			.pix_y(pixel_y),
			.clk(CLOCK_50),
			.reset(reset),
			.inc(left_inc),
			.max_score_reached(left_score_max)
		);
		

	
	edge_detector edge_unit2
	(
		.tick(right_inc),
		.clk(CLOCK_50),
		.reset(reset),
		.in(goal_hit)
	);
	/*score_keeper 
		#(
			.LEFT(326)
		)right_score
		(
			.text_on(right_text_on),
			.text_rgb_r(right_text_rgb_r),
			.text_rgb_g(right_text_rgb_g),
			.text_rgb_b(right_text_rgb_b),
			.pix_x(pixel_x),
			.pix_y(pixel_y),
			.clk(CLOCK_50),
			.reset(reset),
			.inc(right_score_max),
			.max_score_reached(right_score_max)
		);
		
		///// power bar
		wire [4:0] barr_rgb_r , barr_rgb_b , barg_rgb_r , barg_rgb_b;
		wire [5:0] barr_rgb_g , barg_rgb_g;
	power_bar power_unit
	(
	.brick1(brick1_vis),
	.brick2(brick2_vis),
	.brick3(brick3_vis),
	.brick4(brick4_vis),
	.brick5(brick5_vis),
	.brick6(brick6_vis),
	.brick7(brick7_vis),
	.brick8(brick8_vis),
	.brick9(brick9_vis),
	.brick11(brick11_vis),
	.brick12(brick12_vis),
	.brick13(brick13_vis),
	.brick14(brick14_vis),
	.pix_x(pix_x),
	.pix_y(pix_y),
	.bar_on_green(bar_og),
	.bar_on_red(bar_or),
	.barr_rgb_r(RED_RGB_R),
	.barr_rgb_g(RED_RGB_G),
	.barr_rgb_b(RED_RGB_B),
	.barg_rgb_r(GREEN_RGB_R),
	.barg_rgb_g(GREEN_RGB_G),
	.barg_rgb_b(GREEN_RGB_B)
	);*/
	
	wire tg_on, ta_on, tm_on, te1_on, to_on , tv_on , te2_on, tr1_on;
///game over
	game_over
	#(
	.LEFT(250),
	.RIGHT(258)
	)
	unit_g(
	.t_on(tg_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0111),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
	game_over
	#(
	.LEFT(259),
	.RIGHT(267)
	)
	unit_a(
	.t_on(ta_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0001),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
	game_over
	#(
	.LEFT(268),
	.RIGHT(276)
	)
	unit_m(
	.t_on(tm_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1101),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
	game_over
	#(
	.LEFT(277),
	.RIGHT(285)
	)
	unit_e1(
	.t_on(te1_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0101),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
		
	game_over
	#(
	.LEFT(294),
	.RIGHT(302)
	)
	unit_o(
	.t_on(to_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1111),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);	
	
	game_over
	#(
	.LEFT(303),
	.RIGHT(311)
	)
	unit_v(
	.t_on(tv_on),
	.clk(CLOCK_50),
	.sel_text(3'b101),
	.regis(4'b0110),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
		game_over
	#(
	.LEFT(312),
	.RIGHT(320)
	)
	unit_e2(
	.t_on(te2_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0101),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
			game_over
	#(
	.LEFT(321),
	.RIGHT(329)
	)
	unit_r1(
	.t_on(tr1_on),
	.clk(CLOCK_50),
	.sel_text(3'b101),
	.regis(4'b0010),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
	
///you have done it!

wire ty1_on,to1_on,tu1_on,th1_on,ta2_on,tv2_on,te3_on,td11_on,to2_on,tn1_on,te3_on,ti1_on,tt1_on,tlast_on;

game_over
	#(
	.LEFT(250),
	.RIGHT(258)
	)
	unit_y1(
	.t_on(ty1_on),
	.clk(CLOCK_50),
	.sel_text(3'b101),
	.regis(4'b1001),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
	
game_over
	#(
	.LEFT(259),
	.RIGHT(267)
	)
	unit_o1(
	.t_on(to1_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1111),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(268),
	.RIGHT(276)
	)
	unit_u1(
	.t_on(tu1_on),
	.clk(CLOCK_50),
	.sel_text(3'b101),
	.regis(4'b0101),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(284),
	.RIGHT(292)
	)
	unit_h1(
	.t_on(th1_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1000),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(293),
	.RIGHT(301)
	)
	unit_a2(
	.t_on(ta2_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0001),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
game_over
	#(
	.LEFT(302),
	.RIGHT(310)
	)
	unit_v2(
	.t_on(tv2_on),
	.clk(CLOCK_50),
	.sel_text(3'b101),
	.regis(4'b0110),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(311),
	.RIGHT(319)
	)
	unit_e3(
	.t_on(te3_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0101),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(327),
	.RIGHT(335)
	)
	unit_d11(
	.t_on(td11_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0100),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(336),
	.RIGHT(342)
	)
	unit_o2(
	.t_on(to2_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1111),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(344),
	.RIGHT(352)
	)
	unit_n1(
	.t_on(tn1_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1110),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(353),
	.RIGHT(361)
	)
	unit_e4(
	.t_on(te4_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b0101),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(368),
	.RIGHT(376)
	)
	unit_i1(
	.t_on(ti1_on),
	.clk(CLOCK_50),
	.sel_text(3'b100),
	.regis(4'b1001),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);

game_over
	#(
	.LEFT(377),
	.RIGHT(385)
	)
	unit_t1(
	.t_on(tt1_on),
	.clk(CLOCK_50),
	.sel_text(3'b101),
	.regis(4'b0100),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);	
	
	game_over
	#(
	.LEFT(387),
	.RIGHT(395)
	)
	unit_last(
	.t_on(tlast_on),
	.clk(CLOCK_50),
	.sel_text(3'b010),
	.regis(4'b0001),
	.pix_x(pixel_x),
	.pix_y(pixel_y)
	);
	
		
		
	always @(posedge CLOCK_50)
		if(pixel_tick)
		begin
			rgb_reg_r <= rgb_next_r;
			rgb_reg_g <= rgb_next_g;
			rgb_reg_b <= rgb_next_b;
		end
		
	always @*
		if(~video_on)
		begin
			rgb_next_r = 3'b000;
			rgb_next_g = 3'b000;
			rgb_next_b = 3'b000;
		end
		else if(left_text_on)
		begin
			rgb_next_r = left_text_rgb_r;
			rgb_next_g = left_text_rgb_g;
			rgb_next_b = left_text_rgb_b;
		end	
		
		else if(left_goal_on)
		begin
			rgb_next_r = left_goal_rgb_r;
			rgb_next_g = left_goal_rgb_g;
			rgb_next_b = left_goal_rgb_b;
		end	
		else if(right_goal_on)
		begin
			rgb_next_r = right_goal_rgb_r;
			rgb_next_g = right_goal_rgb_g;
			rgb_next_b = right_goal_rgb_b;
		end	
		else if(right_paddle_on)
		begin
			rgb_next_r = right_paddle_rgb_r;
			rgb_next_g = right_paddle_rgb_g;
			rgb_next_b = right_paddle_rgb_b;
		end
		else if(ball_on)
		begin
			rgb_next_r = ball_rgb_r;
			rgb_next_g = ball_rgb_g;
			rgb_next_b = ball_rgb_b;
			end
		else if(mid_wall_on)
		begin
			rgb_next_r = mid_wall_rgb_r;
			rgb_next_g = mid_wall_rgb_g;
			rgb_next_b = mid_wall_rgb_b;
		end
	  else if(brick_on1)
		begin
			rgb_next_r = brick_rgb_r1;
			rgb_next_g = brick_rgb_g1;
			rgb_next_b = brick_rgb_b1;
		end 
		else if(brick_on2)
		begin
			rgb_next_r = brick_rgb_r2;
			rgb_next_g = brick_rgb_g2;
			rgb_next_b = brick_rgb_b2;
		end 
		else if(brick_on3)
		begin
			rgb_next_r = brick_rgb_r3;
			rgb_next_g = brick_rgb_g3;
			rgb_next_b = brick_rgb_b3;
		end 
		else if(brick_on4)
		begin
			rgb_next_r = brick_rgb_r4;
			rgb_next_g = brick_rgb_g4;
			rgb_next_b = brick_rgb_b4;
		end 
		 else if(brick_on5)
		begin
			rgb_next_r = brick_rgb_r5;
			rgb_next_g = brick_rgb_g5;
			rgb_next_b = brick_rgb_b5;
		end 
		else if(brick_on6)
		begin
			rgb_next_r = brick_rgb_r6;
			rgb_next_g = brick_rgb_g6;
			rgb_next_b = brick_rgb_b6;
		end 
		else if(brick_on7)
		begin
			rgb_next_r = brick_rgb_r7;
			rgb_next_g = brick_rgb_g7;
			rgb_next_b = brick_rgb_b7;
		end 
		else if(brick_on8)
		begin
			rgb_next_r = brick_rgb_r8;
			rgb_next_g = brick_rgb_g8;
			rgb_next_b = brick_rgb_b8;
		end 
		else if(brick_on9)
		begin
			rgb_next_r = brick_rgb_r9;
			rgb_next_g = brick_rgb_g9;
			rgb_next_b = brick_rgb_b9;
		end 
		else if(brick_on11)
		begin
			rgb_next_r = brick_rgb_r11;
			rgb_next_g = brick_rgb_g11;
			rgb_next_b = brick_rgb_b11;
		end 
		else if(brick_on12)
		begin
			rgb_next_r = brick_rgb_r12;
			rgb_next_g = brick_rgb_g12;
			rgb_next_b = brick_rgb_b12;
		end 
		else if(brick_on13)
		begin
			rgb_next_r = brick_rgb_r13;
			rgb_next_g = brick_rgb_g13;
			rgb_next_b = brick_rgb_b13;
		end 
		else if(brick_on14)
		begin
			rgb_next_r = brick_rgb_r14;
			rgb_next_g = brick_rgb_g14;
			rgb_next_b = brick_rgb_b14;
		end 
		else if(tg_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(ta_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(tm_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(te1_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(to_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(tv_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(te2_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end 
		else if(tr1_on && left_score_max & (~led))
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end
		else if(ty1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(to1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(tu1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(th1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(ta2_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(tv2_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(te3_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(td11_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(to2_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(tn1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(te4_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(ti1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(tt1_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else if(tlast_on && led)
		begin
			rgb_next_r = 5'b11111;
			rgb_next_g = 6'b111111;
			rgb_next_b = 5'b00000;
		end
		else
		begin
			rgb_next_r = 5'b00000;
			rgb_next_g = 6'b000000;
			rgb_next_b = 5'b00000;
		end	
	
	assign rgb_r = (video_on) ? rgb_next_r : 5'b00000;
	assign rgb_g = (video_on) ? rgb_next_g : 6'b000000;
	assign rgb_b = (video_on) ? rgb_next_b : 5'b00000;
	assign ref_tick = (pixel_x == 0) && (pixel_y == 481) && ~pause; 
	
	
	//////////////////////////////////////////SOUND/////////////////////////////////////////////////
	wire paddle_hit_tick, wall_hit_tick;
	
	edge_detector edge_unit3
	(
		.tick(paddle_hit_tick),
		.clk(CLOCK_50),
		.reset(reset),
		.in(paddle_hit)
	);
	edge_detector edge_unit4
	(
		.tick(wall_hit_tick),
		.clk(CLOCK_50),
		.reset(reset),
		.in(wall_hit)
	);
	sound_controller sound_unit1
		(
			.clk(CLOCK_50),
			.reset(reset),
			.speaker(speaker1),
			.goal(left_inc | right_inc),
			.paddle(paddle_hit_tick),
			.wall(wall_hit_tick)
		);
		
		
		
	//////////////////////////////////////////PONG CONTROL FSM/////////////////////////////////////
	wire key_pressed, key_pressed_tick, score_max_tick;
	assign key_pressed = (~left | ~right);
	
	edge_detector edge_unit5
	(
		.tick(key_pressed_tick),
		.clk(CLOCK_50),
		.reset(reset),
		.in(key_pressed)
	);
	
	edge_detector edge_unit6
	(
		.tick(left_score_max_tick),
		.clk(CLOCK_50),
		.reset(reset),
		.in(left_score_max)
	);
	
	edge_detector edge_unit7
	(
		.tick(right_score_max_tick),
		.clk(CLOCK_50),
		.reset(reset),
		.in(right_score_max)
	);
	
	pong_control_fsm control_fsm1
		(
			//inputs
			.clk(CLOCK_50),
			.reset(~r),
			.key_pressed(key_pressed_tick),
			.left_score_max(left_score_max_tick),
			.right_score_max(right_score_max_tick),
			//outputs
			.pause(pause),
			.reset_game(reset)
		);
		
		music music1
		(
		.clk(CLOCK_50),
		.speaker(speaker2)
		);
		
		
		
endmodule	