`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//
//////////////////////////////////////////////////////////////////////////////////
module wall

#(
parameter TOP=595,
parameter BOTTEM=600,
parameter LEFT=0,
parameter RIGHT=800
)


(
output  wall_on,
output  [4:0]wall_rgb_r , wall_rgb_b,
output  [5:0]wall_rgb_g,
input [10:0]pix_x,pix_y
    );



assign wall_rgb_r = 5'b00000;
assign wall_rgb_g = 6'b000000;
assign wall_rgb_b = 5'b11111;

assign wall_on = (LEFT <= pix_x) 
					  && (pix_x <= RIGHT) 
					  && (TOP <= pix_y) 
					  && (pix_y <= BOTTEM);	
		
		
endmodule
