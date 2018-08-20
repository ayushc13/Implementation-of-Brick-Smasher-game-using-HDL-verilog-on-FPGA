module vga_sync
	(
		output h_sync,v_sync,video_on,p_tick,
		output [10:0] pixel_x,pixel_y,
		input clk,reset
	);
	

	
	localparam HD = 640;
	localparam HF = 48;
	localparam HB = 16;
	localparam HR = 96;
	localparam VD = 480;
	localparam VF = 10;
	localparam VB = 33;
	localparam VR = 2;
	
	reg mod2_reg;
	wire mod2_next;
	
	reg [10:0] h_counter_reg,h_counter_next;
	reg [10:0] v_counter_reg,v_counter_next;
	
	reg v_sync_reg,h_sync_reg;
	wire v_sync_next,h_sync_next;
	
	wire h_end,v_end,pixel_tick;
	
	always @(posedge clk, posedge reset)
	begin
		if(reset)
		begin
			mod2_reg <= 1'b0;
			v_counter_reg <= 0;
			h_counter_reg <= 0;
			v_sync_reg <= 1'b0;
			h_sync_reg <= 1'b0;
		end
		else
		begin
			mod2_reg <= mod2_next;
			v_counter_reg <= v_counter_next;
			h_counter_reg <= h_counter_next;
			v_sync_reg <= v_sync_next;
			h_sync_reg <= h_sync_next;
		end
	end
	
	assign mod2_next = ~mod2_reg;
	assign pixel_tick = mod2_reg;
	
	assign h_end = (h_counter_reg == (HD + HF + HB + HR - 1));
	
	assign v_end = (v_counter_reg == (VD + VF + VB + VR - 1));
	
	always @*
		if(pixel_tick)
			if(h_end)
				h_counter_next = 0;
			else
				h_counter_next = h_counter_reg + 1;
		else
			h_counter_next = h_counter_reg;
			
	always @*
		if(pixel_tick & h_end)
			if(v_end)
				v_counter_next = 0;
			else
				v_counter_next = v_counter_reg + 1;
		else
			v_counter_next = v_counter_reg;
	
	
	assign h_sync_next = (h_counter_reg >= (HD + HB) && h_counter_reg <= (HD + HB + HR - 1));
	assign v_sync_next = (v_counter_reg >= (VD + VB) && v_counter_reg <= (VD + VB + VR - 1));
	
	assign video_on = (h_counter_reg < HD) && (v_counter_reg < VD);
	
	
	assign h_sync = h_sync_reg;
	assign v_sync = v_sync_reg;
	
	assign pixel_x = h_counter_reg;
	assign pixel_y = v_counter_reg;
	
	assign p_tick = pixel_tick;
endmodule
