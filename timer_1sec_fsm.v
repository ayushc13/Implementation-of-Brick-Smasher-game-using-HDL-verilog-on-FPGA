module timer_1sec_fsm
	(
		output reg timer_up_tick,
		input reset,clk,start
	);
	
	localparam [1:0] paused = 2'b00,
						  running = 2'b01,
						  time_up = 2'b10;
						  
	reg en,r_set;
	wire tick;
	
	timer_1sec timer_unit
		(
			.tick(tick),
			.clk(clk),
			.reset(r_set),
			.en(en)
		);
		
	reg [1:0] state_reg, state_next;
	
	//registers
	always @(posedge clk, posedge reset)
		if(reset)
			state_reg <= paused;
		else
			state_reg <= state_next;
	
	//next state and output logic
	always @*
		begin
			state_next = state_reg;
			en=1'b0;
			r_set=1'b0;
			timer_up_tick=1'b0;
			case(state_reg)
				paused:
					begin
						r_set=1'b1;
						if(start)
							state_next = running;
						else
							state_next = paused;
					end
				running:
					begin
						en=1'b1;
						if(tick)
							state_next = time_up;
						else
							state_next = running;
					end
				time_up:
					begin
						timer_up_tick = 1'b1;
						state_next = paused;
					end
				default:
					state_next = paused;
			endcase
		end
endmodule 
