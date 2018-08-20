module freq_genrator
	#(
		parameter FREQ = 440
	)
	(
		output freq,
		input clk, reset
	);
	
	localparam CLK_FREQ = 50000000;
	localparam CLK_DIV  = CLK_FREQ / (FREQ * 2);

	reg freq_reg;
	wire freq_next;
	reg [16:0] count_reg;
	wire [16:0] count_next;
	wire tick;
	
	always @(posedge clk, posedge reset)
		if(reset)
			begin
				count_reg <= 0;
				freq_reg <= 0;
			end
		else
			begin
				count_reg <= count_next;
				freq_reg  <= freq_next;
			end
	
	//next state logic
	assign tick = (count_reg == CLK_DIV);
	assign count_next = (tick) ? 0 : count_reg + 1;
	assign freq_next = (tick) ? ~freq_reg : freq_reg;
	
	//output
	assign freq = freq_reg;
endmodule

