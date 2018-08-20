module power_bar
#(
	parameter RED_RGB_R = 5'b11111,
	parameter RED_RGB_G = 6'b000000,
	parameter RED_RGB_B = 5'b00000,
	parameter GREEN_RGB_R = 5'b00000,
	parameter GREEN_RGB_G = 6'b111111,
	parameter GREEN_RGB_B = 5'b00000

)

(
	input brick1 , brick2 , brick3 , brick4 , brick5 ,brick6 , brick7 , brick8 , brick9 , brick11 ,
	input brick12 , brick13 , brick14,
	input [10:0]pix_x , pix_y,
	output bar_on_red , bar_on_green,
	output [4:0]barr_rgb_r , barr_rgb_g , barg_rgb_r , barg_rgb_g,
	output [5:0]barr_rgb_b , barg_rgb_b
);

wire [3:0]brick_count;
reg [10:0]bar_right_green , bar_left_green , bar_right_red , bar_left_red;
assign brick_count = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9 + brick11 + brick12 + brick13 + brick14;

always @*
	begin
	
		if(brick_count == 2'd0)
			begin
				bar_right_green = 0;
				bar_left_green = 0;
				bar_right_red = 625;
				bar_left_red = 560;
			end
			
		else if(brick_count == 2'd1)
			begin
				bar_right_green = 565;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 566;
			end	
			
		else if(brick_count == 2'd2)
			begin
				bar_right_green = 570;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 571;
			end
			
		else if(brick_count == 2'd3)
			begin
				bar_right_green = 575;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 576;
			end	
			
		else if(brick_count == 2'd0)
			begin
				bar_right_green = 580;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 581;
			end	
			
		else if(brick_count == 2'd4)
			begin
				bar_right_green = 585;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 586;
			end	
			
		else if(brick_count == 2'd5)
			begin
				bar_right_green = 590;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 591;
			end		
			
		else if(brick_count == 2'd6)
			begin
				bar_right_green = 595;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 596;
			end	

		else if(brick_count == 2'd7)
			begin
				bar_right_green = 605;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 606;
			end	

		else if(brick_count == 2'd8)
			begin
				bar_right_green = 610;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 611;
			end	


		else if(brick_count == 2'd9)
			begin
				bar_right_green = 615;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 616;
			end	

		else if(brick_count == 2'd10)
			begin
				bar_right_green = 620;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 621;
			end	

		else if(brick_count == 2'd11)
			begin
				bar_right_green = 625;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 626;
			end	

		else if(brick_count == 2'd12)
			begin
				bar_right_green = 630;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 631;
			end	

		else if(brick_count == 2'd13)
			begin
				bar_right_green = 635;
				bar_left_green = 560;
				bar_right_red = 625;
				bar_left_red = 636;
			end
		else
			begin
				bar_right_green = 0;
				bar_left_green = 0;
				bar_right_red = 0;
				bar_left_red = 0;
			end	
			
	end
	
	assign bar_on_red = ((pix_x <= bar_right_red) && (pix_x >= bar_left_red) && (pix_y <= 17) && (pix_y >= 10));
	assign bar_on_green = ((pix_x <= bar_right_green) && (pix_x >= bar_left_green) && (pix_y <= 17) && (pix_y >= 10));
	assign barr_rgb_r = RED_RGB_R;
	assign barr_rgb_g = RED_RGB_G;
	assign barr_rgb_b = RED_RGB_B; 
	assign barg_rgb_r = GREEN_RGB_R;
	assign barg_rgb_g = GREEN_RGB_G;
	assign barg_rgb_b = GREEN_RGB_B; 
	
endmodule	