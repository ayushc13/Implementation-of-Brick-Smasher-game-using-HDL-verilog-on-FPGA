`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
module game_over

#(
parameter UP = 300,
parameter DOWN = 316,
parameter LEFT = 300,
parameter RIGHT = 308
)
(
			output t_on,
			input clk,
			input [2:0]sel_text,
			input [3:0]regis,
			input [10:0]pix_x,pix_y
    );
	 
	
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
	 
assign char_addr = {sel_text, regis};
	assign row_addr  = pix_y - UP;
	assign rom_addr  = {char_addr,row_addr};
	assign bit_addr  = pix_x - LEFT;
	assign font_bit  = font_word[~bit_addr];
	
	
assign t_on = ((UP <= pix_y) && (pix_y < DOWN) && (LEFT <= pix_x) && (pix_x < RIGHT))
					  && (font_bit);
					  	

endmodule
