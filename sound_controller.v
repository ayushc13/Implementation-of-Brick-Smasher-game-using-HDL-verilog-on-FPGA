module sound_controller
	(
		output reg speaker,
		input clk, reset, goal, paddle, wall
	);
	
	/////////////////////////////FRQUENCY PRODUCTION CIRCUIT/////////////////////////////////////
	
	wire freq_440;
	wire freq_330;
	wire freq_220;
	
	freq_genrator 
		#(
			.FREQ(440)
		)
	freq_unit_440
		(
			.freq(freq_440),
			.clk(clk),
			.reset(reset)
		);
		
	freq_genrator 
		#(
			.FREQ(330)
		)
	freq_unit_330
		(
			.freq(freq_330),
			.clk(clk),
			.reset(reset)
		);
		
	freq_genrator 
		#(
			.FREQ(220)
		)
	freq_unit_220
		(
			.freq(freq_220),
			.clk(clk),
			.reset(reset)
		);
	
	/////////////////////////////////////////TIMER/////////////////////////////////////////////////
	wire tick;
	reg en,r_set;
	
	timer_1sec timer1
		(
				.clk(clk),
				.en(en),
				.tick(tick),
				.reset(r_set)
		);
	
	/////////////////////////////////////////SOUND FSM///////////////////////////////////////////////
	
	//states
	localparam [1:0] paused = 2'b00,
						  play_goal = 2'b01,
						  play_paddle = 2'b10,
						  play_wall = 2'b11;
	
	//states registors
	reg [1:0] state_reg,state_next;
	
	always @(posedge clk, posedge reset)
		if(reset)
			state_reg <= paused;
		else
			state_reg <= state_next;
	
	//next state logic
	always @*
		begin
			state_next = state_reg;
			en = 1'b0;
			r_set = 1'b0;
			speaker = 1'b0;
			case(state_reg)
				paused:
					begin
						r_set = 1'b1;
						if(goal)
							state_next = play_goal;
						else if(paddle)
							state_next = play_paddle;
						else if(wall)
							state_next = play_wall;
						else	
							state_next = paused;
					end
				play_goal:
					begin
						en = 1'b1;
						speaker = freq_220;
						if(tick)
							state_next = paused;
						else
							state_next = play_goal;
					end
				play_paddle:
					begin
						en = 1'b1;
						speaker = freq_330;
						if(tick)
							state_next = paused;
						else
							state_next = play_paddle;
					end
				play_wall:
					begin
						en = 1'b1;
						speaker = freq_440;
						if(tick)
							state_next = paused;
						else
							state_next = play_wall;
					end
			endcase
		end
	
endmodule
		