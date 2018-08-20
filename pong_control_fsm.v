module pong_control_fsm
	(
		output reg pause,
		output reg new_game_msg,
		output reg left_win_msg,right_win_msg,
		output reg reset_game,
		input clk, reset,
		input key_pressed,
		input left_score_max, right_score_max
	);
	
	//reset timer
	wire tick;
	reg en;
		timer_1sec reset_timer
			(
				.clk(clk),
				.reset(reset),
				.tick(tick),
				.en(en)
			);
		
	//states
	localparam [2:0] new_game = 3'b000,
						  playing = 3'b001,
						  left_win = 3'b010,
						  right_win = 3'b011,
						  reset_st = 3'b100;
	//state registors
	reg [2:0] state_reg, state_next;
	
	always @(posedge clk, posedge reset)
		if(reset)
			state_reg <= reset_st;
		else
			state_reg <= state_next;
			
	//next state logic
	always @*
		begin
			state_next = state_reg;
			pause = 1'b0;
			new_game_msg = 1'b0;
			left_win_msg = 1'b0;
			right_win_msg = 1'b0;
			reset_game = 1'b0;
			en = 1'b0;
			case(state_reg)
				new_game:
					begin
						new_game_msg = 1'b1;
						pause = 1'b1;
						if(key_pressed)
							state_next = playing;
						else
							state_next = new_game;
					end
				playing:
					begin
						if(left_score_max)
							state_next = left_win;
						else if(right_score_max)
							state_next = right_win;
						else
							state_next = playing;
					end
				left_win:
					begin
						pause = 1'b1;
						left_win_msg = 1'b1;
						if(key_pressed)
							state_next = reset_st;
						else
							state_next = left_win;
					end
				right_win:
					begin
						pause = 1'b1;
						right_win_msg = 1'b1;
						if(key_pressed)
							state_next = reset_st;
						else
							state_next = right_win;
					end
				reset_st:
					begin
						en = 1'b1;
						reset_game = 1'b1;
						pause = 1'b1;
						if(tick)
							state_next = new_game;
						else
							state_next = reset_st;
					end
				default:
					state_next = reset_st;
			endcase
		end
		
		
endmodule	