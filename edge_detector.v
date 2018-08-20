module edge_detector 
	(
		output reg tick,
		input clk,in,reset
	);
	
	localparam [1:0]  wait1 = 2'b00, edg = 2'b01, wait2 = 2'b10;
	
	reg [2:0] state_reg,state_next;
	
	always @(posedge clk, posedge reset)
		if(reset)
			state_reg <= wait1;
		else
			state_reg <= state_next;
	
	always @*
	 begin
		state_next = state_reg; //default state
		tick = 1'b0;		  //default output
		case(state_reg)
			wait1: 
				if(in)
					state_next = edg;
			edg:
				begin
					tick = 1'b1;
					if(in)
						state_next = wait2;
					else
						state_next = wait1;
				end
			wait2:
				if(~in)
					state_next = wait1;
			default: state_next = wait1;
		endcase
	 end
endmodule
