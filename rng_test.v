module rng_test (clock, randomNum);

output [31:0] randomNum;
input clock;

integer  counter;
	reg loadSeed;
	
	initial begin
		counter = 32'd0;
		loadSeed = 1'b1;
	end
	
	
	always@(posedge clock) begin
	
		if (counter == 1) begin
			loadSeed = 1'b0;
		end
		counter = counter + 1;
	
	end
	
	rng rng1(.clk(clock), .reset(1'b1), .loadseed_i(loadSeed), .rngOut(randomNum[11:0]));
	 assign randomNum[31:12] = 20'b0;

endmodule 