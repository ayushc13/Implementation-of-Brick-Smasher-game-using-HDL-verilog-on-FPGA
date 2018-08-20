module timer_1sec
	(
		output tick,
		input reset,clk,en
	);
	
	localparam CLOCK_FREQ = 50000000/4;
	reg [26:0] timer_reg;
	wire [26:0] timer_next;
	
	//registors
	always @(posedge clk, posedge reset)
		if(reset)
			timer_reg <= 0;
		else
			timer_reg <= timer_next;
	
	//next state logic
	assign timer_next = (en)? ((tick) ? 0 : timer_reg + 1) : timer_reg;
	
	//output logic
	assign tick = (timer_reg == CLOCK_FREQ); 
	
endmodule
