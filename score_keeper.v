module score_keeper
	#(
		parameter MAX_SCORE = 5,
		parameter TOP  = 5,
		parameter LEFT = 306,
		parameter COLOR_r = 5'b11100,
		parameter COLOR_g = 6'b111100,
		parameter COLOR_b = 5'b11100
	)
	(
		output text_on,
		output [4:0] text_rgb_r,text_rgb_b,
		output [5:0] text_rgb_g,
		output max_score_reached,
		input [10:0] pix_x, pix_y,
		input clk,inc,reset
	);
	
	//constant declaration
	localparam WIDTH  = 8;
	localparam HEIGHT = 16;
	
	localparam RIGHT  = LEFT + WIDTH;
	localparam BOTTEM = TOP + HEIGHT;
	
	//score storing register
	reg [3:0] score_reg;
	wire [3:0] score_next;
	
	
	reg [31:0] test_count_reg;
	always @(posedge clk,posedge reset)
		if(reset)
		 begin
			score_reg <= -1;
			test_count_reg <= -1;
		 end
		else
		 begin
			score_reg <= score_next;
			test_count_reg <= test_count_reg + 1;
		 end
	assign score_next = (~inc) ? score_reg : (max_score_reached) ? 0 : score_reg + 1;  
	
	//rom interface
	wire [3:0] row_addr;
	wire [2:0] bit_addr;
	wire [6:0] char_addr;
	wire [10:0] rom_addr;
	wire [7:0] font_word;
	wire font_bit;
	
	font_rom font_rom_unit 
	(
		.clk(clk),
		.addr(rom_addr),
		.data(font_word)
	);
	
	assign char_addr = {3'b011, score_reg};
	assign row_addr  = pix_y - TOP;
	assign rom_addr  = {char_addr,row_addr};
	assign bit_addr  = pix_x - LEFT;
	assign font_bit  = font_word[~bit_addr];
	
	assign text_on = ((TOP <= pix_y) && (pix_y < BOTTEM) && (LEFT <= pix_x) && (pix_x < RIGHT)) // box detection
					  && (font_bit);//on bit
					  
	assign text_rgb_r = COLOR_r;
	assign text_rgb_g = COLOR_g;
	assign text_rgb_b = COLOR_b;
	
	assign max_score_reached = (score_reg == MAX_SCORE);
	
endmodule
