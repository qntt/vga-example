module snake_register (value_in, index, clock, reset, enable, value_out);

input [31:0] value_in, index;
input clock, reset, enable;

output [995:0] value_out;

genvar i;

//generate
//	for (i=0; i<=99; i=i+1) begin: loop1
//		register_2 snake_2_bit_reg (
//			 .data_out(value_out[2*i+1 : 2*i]),
//			 .clock(clock),
//			 .ctrl_writeEnable((index == i) && enable),
//			 .ctrl_reset(reset),
//			 .data_in(value_in[1:0])
//		);
//	end
//endgenerate

assign value_out[199:0] = 200'b0;


register snake_reg_head1position (
	 .data_out(value_out[231:200]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 100) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_head2position (
	 .data_out(value_out[263:232]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 101) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_length1 (
	 .data_out(value_out[295:264]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 102) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_length2 (
	 .data_out(value_out[327:296]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 103) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_stage (
	 .data_out(value_out[359:328]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 104) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_head1 (
	 .data_out(value_out[391:360]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 105) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_head2 (
	 .data_out(value_out[423:392]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 106) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_apple1 (
	 .data_out(value_out[455:424]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 107) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_heartsTimer (
	 .data_out(value_out[487:456]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 108) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_heartsTimer2 (
	 .data_out(value_out[519:488]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 108) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);


generate
	for (i=110; i<=129; i=i+1) begin: loop1
		register_11 snakePosition_reg1 (
			 .data_out(value_out[11*(i-110+1)-1 + 520 : 11*(i-110)+520]),
			 .clock(clock),
			 .ctrl_writeEnable((index == i) && enable),
			 .ctrl_reset(reset),
			 .data_in(value_in[10:0])
		);
	end
endgenerate

register snake_reg_invincibilitytimer1 (
	 .data_out(value_out[771:740]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 130) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_invincibilitytimer2 (
	 .data_out(value_out[803:772]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 131) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_invincibilityPosition (
	 .data_out(value_out[835:804]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 132) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_score1 (
	 .data_out(value_out[867:836]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 133) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_score2 (
	 .data_out(value_out[899:868]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 134) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_highscore1 (
	 .data_out(value_out[931:900]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 135) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_highscore2 (
	 .data_out(value_out[963:932]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 136) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);

register snake_reg_highscore3 (
	 .data_out(value_out[995:964]),
	 .clock(clock),
	 .ctrl_writeEnable((index == 137) && enable),
	 .ctrl_reset(reset),
	 .data_in(value_in)
);



endmodule 