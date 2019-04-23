module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, up, down, left, right,
							 snake_data);
							 //board, 
							 //snake1, snake2, 
							 //head1, head2,
							 //length1, length2,
							 //score1, score2,
							 //stage, 
							 //isDrawing);

input [995 : 0] snake_data;							
							
input iRST_n;
input iVGA_CLK;
input up, down, left, right;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;     


integer counter;



//input [1600:0] board;
//input [200:0] snake1, snake2;
//input [31:0] head1, head2;
//input [31:0] length1, length2;
//input [31:0] score1, score2;
                   
///////// ////                     
reg [18:0] ADDR,ADDR144,ADDRsl,ADDRpnh,ADDRnum,ADDRboard;
reg [15:0] ADDRlb,ADDRlogo;
reg [16:0] ADDRsidebar;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index,index_main,index_highscore,index_head,index_body, index_apple,index_sl,index_lb,index_pnh,index_logo,index_sidebar;
wire [7:0] index_zero,index_one,index_two,index_three,index_four,index_five,index_six,index_seven,index_eight,index_nine;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
integer cc,rr,ccc,rrr,crcr;
////


assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1) begin
     ADDR<=ADDR+1;
	end
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDRboard ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
//sidebar_data	sb_data_inst (
//	.address ( ADDRsidebar ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_sidebar )
//	);

//	main_data	main_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_main )
//	);
//	highscore_data	highscore_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_highscore )
//	);
	head_data	head_data_inst (
	.address ( ADDR144 ),
	.clock ( VGA_CLK_n ),
	.q ( index_head )
	);
	body_data	body_data_inst (
	.address ( ADDR144 ),
	.clock ( VGA_CLK_n ),
	.q ( index_body )
	);
	apple_data	apple_data_inst (
	.address ( ADDR144 ),
	.clock ( VGA_CLK_n ),
	.q ( index_apple )
	);
//	lb	lb_data_inst (
//	.address ( ADDRlb ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_lb )
//	);	
//	snakelogo	sl_data_inst (
//	.address ( ADDRlogo ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_logo )
//	);	
	zero_data	zero_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_zero )
	);	
	one_data	one_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_one )
	);	
	two_data	two_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_two )
	);	
	three_data	three_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_three )
	);	
	four_data	four_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_four )
	);	
	five_data	five_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_five )
	);	
	six_data	_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_six )
	);	
	seven_data	seven_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_seven )
	);	
	eight_data	eight_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_eight )
	);	
	nine_data	nine_data_inst (
	.address ( ADDRnum ),
	.clock ( VGA_CLK_n ),
	.q ( index_nine )
	);	
//	snakelogo_data	sl_data_inst (
//	.address ( ADDRsl ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_sl )
//	);	
//	playandhigh_data	pnh_data_inst (
//	.address ( ADDRpnh ),
//	.clock ( VGA_CLK_n ),
//	.q ( index_pnh )
//	);
/////////////////////////
//////Add switch-input logic here

integer pixelWidth;

integer addressRow, addressCol;
integer boardPosition;
integer boardRow, boardCol;

 integer head1, head2;
 integer length1, length2;
 integer stage;
 
 integer move1;
  integer dig1,dig2,dig3,dig4,dig5,dig6;
 wire [3:0] digreg1,digreg2,digreg3,digreg4,digreg5,digreg6;
 wire [7:0] digindex1,digindex2,digindex3,digindex4,digindex5,digindex6,indexhigh;

integer applePosition;
integer invincibilityTimer1, invincibilityTimer2, invincibilityPosition, score1, score2;
 
reg [7:0] color_index;


initial begin
	pixelWidth = 12;
	move1 = 2;
		dig1=8;
	dig2=6;
	dig3=7;
	dig4=3;
	dig5=5;
	dig6=2;
	
	//applePosition = 40*10+25;
	
end

integer j;
reg isInImage;
integer lbaddr,numaddr;
integer shiftit;
integer theleftbar;

integer head1position, head2position;
integer currPosition, currPosition2;
reg [1:0] currDirection;

integer heartsTimer;
integer countboard;
integer shifting;

wire isBoardPositionPresent, isBoardPositionPresent2;
wire isdigone,isdigtwo,isdigthree,isdigfour,isdigfive,isdigsix,isleader;
wire [2:0] selecthigh;


// for snake 1 [110...119]
TargetFindModule tf_module1 (.values(snake_data[629:520]), .target(boardPosition[10:0]), .isTargetPresent(isBoardPositionPresent));

TargetFindModule tf_module2 (.values(snake_data[739:630]), .target(boardPosition[10:0]), .isTargetPresent(isBoardPositionPresent2));

//		if(addressRow>239&&addressRow<280&&addressCol>287&&addressCol<320)

//assign isdigone = ( (addressRow>239) & (addressRow<280) & (addressCol>287) & (addressCol<320));
//assign isdigtwo = ( (addressRow>239) & (addressRow<280) & (addressCol>319) & (addressCol<352));
//assign isdigthree = ( (addressRow>319) & (addressRow<360) & (addressCol>287) & (addressCol<320));
//assign isdigfour = ( (addressRow>319) & (addressRow<360) & (addressCol>319) & (addressCol<352));
//assign isdigfive = ( (addressRow>399) & (addressRow<440) & (addressCol>287) & (addressCol<320));
//assign isdigsix = ( (addressRow>399) & (addressRow<440) & (addressCol>319) & (addressCol<352));
//assign isleader = ( (addressRow>38) & (addressRow<177) & (addressCol>194) & (addressCol<444));
//assign selecthigh[0]=isdigone|isdigthree|isdigfive|isleader;
//assign selecthigh[1]=isdigtwo|isdigthree|isdigsix|isleader;
//assign selecthigh[2]=isdigfour|isdigfive|isdigsix|isleader;
//mux_8high highscoreindex(indexhigh,8'h44,digindex1,digindex2,digindex3,digindex4,digindex5,digindex6,digindex6,selecthigh);

//	highscore1 = snake_data[931:900];
//	highscore2 = snake_data[963:932];
//	highscore3 = snake_data[995:964];
//	

	
//	
////	//digreg1=highscore1 / 10;
//assign	digreg2=snake_data[903:900];
////	//digreg3=highscore2 / 10;
//assign	digreg4=snake_data[935:932];
////	//digreg5=highscore3 / 10;
//assign	digreg6=snake_data[967:964];
////	
////	
//	
//




//		if(addressRow>38&&addressRow<177&&addressCol>194&&addressCol<444)
//		begin
//		color_index=index_lb;
//		end
//		if(addressRow>239&&addressRow<280&&addressCol>287&&addressCol<320)
//		begin
//
//		color_index=digindex1;
//		end
//		if(addressRow>239&&addressRow<280&&addressCol>319&&addressCol<352)
//		begin
//
//		color_index= digindex2;
//		end
//		if(addressRow>319&&addressRow<360&&addressCol>287&&addressCol<320)
//		begin
//
//		color_index= digindex3;
//		end
//		if(addressRow>319&&addressRow<360&&addressCol>319&&addressCol<352)
//		begin
//
//		color_index= digindex4;
//		end
//		if(addressRow>399&&addressRow<440&&addressCol>287&&addressCol<320)
//		begin
//
//		color_index= digindex5;
//		end
//		if(addressRow>399&&addressRow<440&&addressCol>319&&addressCol<352)
//		begin
//
//		color_index= digindex6;
//		end
// process snake's movement
always@(posedge iVGA_CLK)
begin

	// TODO: uncomment the following line
	//stage = snake_data[(1824-1600+1)*32-1 -:32];
	//stage = 2;
	countboard=countboard+1;
	if (countboard==5000000) countboard=0;
					if (countboard==100) shiftit=shiftit+1;
					if (shiftit==480) shiftit=0;
					if (countboard==1000000) shifting=1;
					if (countboard==2000000) shifting=2;
					if (countboard==3000000) shifting=3;
					if (countboard==4000000) shifting=4;
					if (countboard==5000000) shifting=5;
	

	
	// 1. get the stage
	stage = snake_data[359:328];
	
	// 2. get the position of head and length
	head1position = snake_data[231:200];
	length1 = snake_data[295:264];
	head2position = snake_data[263:232];
	length2 = snake_data[327:296];
	head1 = snake_data[391:360];
	head2 = snake_data[423:392];
	applePosition = snake_data[455:424];
	
	heartsTimer = snake_data[487:456];
	
	invincibilityTimer1 = snake_data[771:740];
	invincibilityTimer2 = snake_data[803:772];
	invincibilityPosition = snake_data[835:804];
	
	score1 = snake_data[867:836];
	score2 = snake_data[899:868];
//	highscore1 = snake_data[931:900];
//	highscore2 = snake_data[963:932];
//	highscore3 = snake_data[995:964];
//	

	
	
	
	
	
//	
//			
//	digreg1=dig1;
//	digreg2=dig2;
//	digreg3=dig3;
//	digreg4=dig4;
//	digreg5=dig5;
//	digreg6=dig6;

	
	// 3. loop through all directions to see if the current body part has a color
	addressRow = ADDR / 640;
			addressCol = ADDR % 640; 

//wheretheheadis = snake_data[2*(head1)+1 -:2];
//						if (wheretheheadis == 2'b00) begin
//							rr=addressCol % 12;
//                     cc= 12 * (addressRow % 12);
//						end
//						else if (wheretheheadis == 2'b01) begin
//							cc=addressCol % 12;
//                     rr= 12 * (addressRow % 12);
//						end
//						else if (wheretheheadis == 2'b10) begin
//							rr=addressCol % 12;
//                     cc= 12 * (12-addressRow % 12);
//						end
//						else if (wheretheheadis == 2'b11) begin
//							cc= 12 - addressCol % 12;
//                     rr= 12 * (addressRow % 12);
//						end
//
//						crcr=cc+rr;
//						ADDRHEAD=crcr;
					ccc=addressCol % 12;
                 rrr= 12 * (addressRow % 12);
						ADDR144=ccc+rrr;
//							lbaddr=((addressRow - 38 ) * 250 + addressCol - 194 ) % 34750;
//							ADDRlb=lbaddr;
								numaddr=addressCol % 32 +32 * (addressRow % 40);
								ADDRnum=numaddr;
								cc=(addressRow-19)*407;
								rr=addressCol-114;
								crcr=cc+rr;
								theleftbar=((ADDR+shiftit) % 640);
								if (crcr>61863) ADDRlogo=0;
								else ADDRlogo=crcr;
								if (addressCol>479) ADDRboard=ADDR;
//								else if (theleftbar>480) ADDRboard=ADDR+shiftit+160;
//								else if ((ADDR+shiftit)>(480*640-160)) ADDRboard=ADDR+shiftit-480*640;
								else ADDRboard=ADDR+shiftit;
//								ADDRsidebar=addressRow * 160+addressCol-480;
	
	
	if (stage== 32'd0) begin
		color_index = 8'd0;
		if(addressRow>19&&addressRow<172&&addressCol>114&&addressCol<522)
		begin

		color_index=index_logo;
		end
	end
	
	
	if (stage == 32'd2) begin
		//color_index = 8'd1;
//	
//			addressRow = ADDR / 640;
//			addressCol = ADDR % 640; 
			 
			// check if ADDR is in the game screen (40x40 board)
			if (addressCol < 480) begin
				boardRow = addressRow/pixelWidth;
				boardCol = addressCol/pixelWidth;
				boardPosition = 40*boardRow + boardCol;
				
				isInImage = 1'b0;
				
				if (isBoardPositionPresent == 1'b1) begin

				
				if (shifting == 1) color_index = index_body;
				if (shifting == 2) color_index = index_body+1;
				if (shifting == 3) color_index = index_body+2;
				if (shifting == 4) color_index = index_body+3;
				if (shifting == 5) color_index = index_body+4;

					isInImage = 1'b1;
				end
				
				
				if (isBoardPositionPresent2 == 1'b1) begin
					color_index = index_body;
					isInImage = 1'b1;
				end				
				
				if (head1position == boardPosition) begin
					color_index = index_head;
					isInImage = 1'b1;
				end
				
				if (head2position == boardPosition) begin
					color_index = index_head;
					isInImage = 1'b1;
				end
				

				
				if (boardPosition == applePosition) begin
					color_index = index_apple;
					isInImage = 1'b1;
				end
				
				if (boardPosition == invincibilityPosition) begin
					color_index = index_apple+18;
					isInImage = 1'b1;
				end
				
				if (isInImage == 1'b0) begin

					color_index = index;
				end
				
				
				
			end
//					color_index = 8'h1c;
//			// draw boundaries of board
//			else if (addressCol == 480) begin
//				color_index = 8'd0;
//			end
			// area for drawing hearts timer
			else if (addressRow > 60 && addressRow < 80 && addressCol > 520 && addressCol < 600) begin
				if (addressCol*100 < (600-520)*heartsTimer + 520*100) begin
					color_index = 8'd0;
				end
//				else begin
//					color_index = 8'd4;
//				end
			else begin
					color_index = 8'd46;
			end
			end
			// area for drawing invincibility timer
			else if (addressRow > 100 && addressRow < 120 && addressCol > 520 && addressCol < 600) begin
				if (addressCol*100 < (600-520)*invincibilityTimer1 + 520*100) begin
					color_index = 8'd2;
				end
//				else begin
//
//				end
			else begin
					color_index = 8'd46;
			end
			end
			else begin
					color_index = 8'd46;
			end
		
			
	end
	if (stage == 32'd3) begin 
 
		color_index = indexhigh;
//		
		


		
		
		

		



//		if(addressRow>38&&addressRow<177&&addressCol>194&&addressCol<444)
//		begin
//
//		color_index=index_lb;
//		end
//		if(addressRow>239&&addressRow<280&&addressCol>287&&addressCol<320)
//if (isdigone)
//		begin
////		case (digreg1)
////		4'd0 : digindex1=index_zero;
////		4'd1 : digindex1=index_one;
////		4'd2 : digindex1=index_two;
////		4'd3 : digindex1=index_three;
////		4'd4 : digindex1=index_four;
////		4'd5 : digindex1=index_five;
////		4'd6 : digindex1=index_six;
////		4'd7 : digindex1=index_seven;
////		4'd8 : digindex1=index_eight;
////		4'd9 : digindex1=index_nine;
////		endcase
//		color_index=digindex1;
//		end
//		if(addressRow>239&&addressRow<280&&addressCol>319&&addressCol<352)
//		begin
////			case (digreg2)
////		4'd0 : digindex2=index_zero;
////		4'd1 : digindex2=index_one;
////		4'd2 : digindex2=index_two;
////		4'd3 : digindex2=index_three;
////		4'd4 : digindex2=index_four;
////		4'd5 : digindex2=index_five;
////		4'd6 : digindex2=index_six;
////		4'd7 : digindex2=index_seven;
////		4'd8 : digindex2=index_eight;
////		4'd9 : digindex2=index_nine;
////		endcase
//		color_index= digindex2;
//		end
//		if(addressRow>319&&addressRow<360&&addressCol>287&&addressCol<320)
//		begin
////				case (digreg3)
////		4'd0 : digindex3=index_zero;
////		4'd1 : digindex3=index_one;
////		4'd2 : digindex3=index_two;
////		4'd3 : digindex3=index_three;
////		4'd4 : digindex3=index_four;
////		4'd5 : digindex3=index_five;
////		4'd6 : digindex3=index_six;
////		4'd7 : digindex3=index_seven;
////		4'd8 : digindex3=index_eight;
////		4'd9 : digindex3=index_nine;
////		endcase
//		color_index= digindex3;
//		end
//		if(addressRow>319&&addressRow<360&&addressCol>319&&addressCol<352)
//		begin
////				case (digreg4)
////		4'd0 : digindex4=index_zero;
////		4'd1 : digindex4=index_one;
////		4'd2 : digindex4=index_two;
////		4'd3 : digindex4=index_three;
////		4'd4 : digindex4=index_four;
////		4'd5 : digindex4=index_five;
////		4'd6 : digindex4=index_six;
////		4'd7 : digindex4=index_seven;
////		4'd8 : digindex4=index_eight;
////		4'd9 : digindex4=index_nine;
////		endcase
//		color_index= digindex4;
//		end
//		if(addressRow>399&&addressRow<440&&addressCol>287&&addressCol<320)
//		begin
////				case (digreg5)
////		4'd0 : digindex5=index_zero;
////		4'd1 : digindex5=index_one;
////		4'd2 : digindex5=index_two;
////		4'd3 : digindex5=index_three;
////		4'd4 : digindex5=index_four;
////		4'd5 : digindex5=index_five;
////		4'd6 : digindex5=index_six;
////		4'd7 : digindex5=index_seven;
////		4'd8 : digindex5=index_eight;
////		4'd9 : digindex5=index_nine;
////		endcase
//		
//		color_index= digindex5;
//		end
//		if(addressRow>399&&addressRow<440&&addressCol>319&&addressCol<352)
//		begin
////				case (digreg6)
////		4'd0 : digindex6=index_zero;
////		4'd1 : digindex6=index_one;
////		4'd2 : digindex6=index_two;
////		4'd3 : digindex6=index_three;
////		4'd4 : digindex6=index_four;
////		4'd5 : digindex6=index_five;
////		4'd6 : digindex6=index_six;
////		4'd7 : digindex6=index_seven;
////		4'd8 : digindex6=index_eight;
////		4'd9 : digindex6=index_nine;
////				endcase
//		color_index= digindex6;
//		end
end
//		else begin
//			color_index = 8'd4;
//		end



	
	
	


end
//
//mux_16_1 muxnum1 (digindex1, index_zero,index_one,index_two,index_three,index_four,index_five,
//		index_six,index_seven,index_eight,index_nine, index_nine,index_nine,index_nine,index_nine,index_nine,index_nine, digreg1);
//
//
//
//mux_16_1 muxnum2 (digindex2, index_zero,index_one,index_two,index_three,index_four,index_five,
//		index_six,index_seven,index_eight,index_nine, index_nine,index_nine,index_nine,index_nine,index_nine,index_nine, digreg2);
//
//mux_16_1 muxnum3 (digindex3, index_zero,index_one,index_two,index_three,index_four,index_five,
//		index_six,index_seven,index_eight,index_nine, index_nine,index_nine,index_nine,index_nine,index_nine,index_nine, digreg3);
//
//mux_16_1 muxnum4 (digindex4, index_zero,index_one,index_two,index_three,index_four,index_five,
//		index_six,index_seven,index_eight,index_nine, index_nine,index_nine,index_nine,index_nine,index_nine,index_nine, digreg4);
//
//mux_16_1 muxnum5 (digindex5, index_zero,index_one,index_two,index_three,index_four,index_five,
//		index_six,index_seven,index_eight,index_nine, index_nine,index_nine,index_nine,index_nine,index_nine,index_nine, digreg5);
//
//mux_16_1 muxnum6 (digindex6, index_zero,index_one,index_two,index_three,index_four,index_five,
//		index_six,index_seven,index_eight,index_nine, index_nine,index_nine,index_nine,index_nine,index_nine,index_nine, digreg6);


//////Color table output
img_index	img_index_inst (
	.address ( color_index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign r_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign b_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	


module TargetFindModule (values, target, isTargetPresent);

	// checks if at least one value in values equal the target

	input [11*(9+1)-1 : 0] values;
	input [10:0] target;
	
	wire [11:0] isEqual;
	
	output isTargetPresent;
	
	genvar i;
	generate
	for (i=0; i<=9; i=i+1) begin: loop1
		equality eq1 (.out(isEqual[i]), .a(target), .b(values[11*(i+1)-1: 11*i]));
	end
	endgenerate
	
	assign isTargetPresent = ~(isEqual == 11'b0);
	
//	assign isEqual[11] = 1'b0;
//	equality out_equal (.out(isTargetPresent), .a(isEqual), .b(11'b0));

endmodule 


module equality (out, a, b);

	input [10:0] a, b;
	output out;
	
	assign out = ~(a[0]^b[0] || a[1]^b[1] || a[2]^b[2] || a[3]^b[3] || a[4]^b[4] || 
						a[5]^b[5] || a[6]^b[6] || a[7]^b[7] || a[8]^b[8] || a[9]^b[9] || a[10]^b[10]);

endmodule 












