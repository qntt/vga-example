module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, up, down, left, right,
							 snake_data, equal1, equal2);
							 //board, 
							 //snake1, snake2, 
							 //head1, head2,
							 //length1, length2,
							 //score1, score2,
							 //stage, 
							 //isDrawing);


input [487 : 0] snake_data;							
							
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
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
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
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
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

integer applePosition;
 
reg [7:0] color_index;


initial begin
	pixelWidth = 12;
	move1 = 2;
	
	applePosition = 40*10+25;
	
end

integer j;
reg isInImage;
reg isInImage2;

integer head1position, head2position;
integer currPosition1;
reg [1:0] currDirection1;

integer currPosition2;
reg [1:0] currDirection2;

integer heartsTimer1;

wire [32*50-1:0] position1, position2;

output [49:0] equal1, equal2;

snakeBody snbody (snake_data[199:0], position1, position2, head1Position, head2Position);
equality_50 equal_sn1(position1, boardPosition, length1, equal1);
equality_50 equal_sn2(position2, boardPosition, length2, equal2);

// process snake's movement
always@(posedge iVGA_CLK)
begin

	// TODO: uncomment the following line
	//stage = snake_data[(1824-1600+1)*32-1 -:32];
	//stage = 2;
	
	
	// 1. get the stage
	stage = snake_data[359:328];
	
	// 2. get the position of head and length
	head1position = snake_data[231:200];
	length1 = snake_data[295:264];
	head2position = snake_data[263:232];
	length2 = snake_data[327:296];
	head1 = snake_data[391:360];
	head2 = snake_data[423:392];
	
	heartsTimer1 = snake_data[487:456];
	
	// 3. loop through all directions to see if the current body part has a color
	
	if (stage== 32'd0) begin
		color_index = 8'd2;
	end
	
	
	if (stage == 32'd2) begin
		//color_index = 8'd1;
	
			addressRow = ADDR / 640;
			addressCol = ADDR % 640; 
			 
			// check if ADDR is in the game screen (40x40 board)
			if (addressCol < 480) begin
				boardRow = addressRow/12;
				boardCol = addressCol/12;
				boardPosition = 40*boardRow + boardCol;
				
				isInImage = 1'b0;
				isInImage2 = 1'b0;
				
				currPosition1 = head1position;
				currPosition2 = head2position;
				
				if (currPosition1 == boardPosition) begin
					color_index = 8'd1;
					isInImage = 1'b1;
				end
				if (currPosition2 == boardPosition) begin
					color_index = 8'd2;
					isInImage2 = 1'b1;
				end
				currDirection1 = snake_data[2*(head1)+1 -:2];
				currDirection2 = snake_data[2*(head2)+1 + 50 -:2];
				
				if (equal1 > 50'b0) begin
					color_index = 8'd1;
					isInImage = 1'b1;
				end
				
//				if (equal2 > 50'b0) begin
//					color_index = 8'd2;
//					isInImage2 = 1'b1;
//				end
				
//				
//				for (j=1; j<50; j=j+1) begin
//					if (j < length1) begin 
//						
//						if (position1[32*(j+1)-1 -: 32] == boardPosition) begin
//							color_index = 8'd1;
//							isInImage = 1'b1;
//						end
//					end
//					
//					if (j < length2 && stage==4) begin 
//					
//						if (position2[32*(j+1)-1 -: 32] == boardPosition) begin
//							color_index = 8'd2;
//							isInImage2 = 1'b1;
//						end
//					end
//				end
//				
				if (boardPosition == applePosition) begin
					color_index = 8'd3;
					isInImage = 1'b1;
				end
				if (isInImage == 1'b0 && isInImage2 == 1'b0) begin
					color_index = 8'd4;
				end
				
				// TODO: display snake 2's positions
				
				
			end

			// draw boundaries of board
			else if (addressCol == 480) begin
				color_index = 8'd0;
			end
			// area for drawing hearts timer
			else if (addressRow > 60 && addressRow < 80 && addressCol > 520 && addressCol < 600) begin
				if (addressCol*100 < (600-520)*heartsTimer1 + 520*100) begin
					color_index = 8'd3;
				end
				else begin
					color_index = 8'd4;
				end
			end
			else begin
				color_index = 8'd4;
			end
		
			
	end
	if (stage == 32'd3) begin 
		color_index = 8'd3;
	end
//		else begin
//			color_index = 8'd4;
//		end



	
	
	


end



	
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



module equality_50(position, boardPosition, length, equal);

	input [32*50-1:0] position;
	input [31:0] boardPosition, length;
	
	output [49:0] equal;
	
	genvar i;
	generate
		for (i=1; i<50; i=i+1) begin: loop_equality50
			assign equal[i] = (position[32*(i+1)-1: 32*i]==boardPosition && i<length) ? 1'b1 : 1'b0;
		end
	endgenerate

endmodule
 	
	
	
	

module snakeBody(snake_data, position1, position2, head1Position, head2Position);

	input [199:0] snake_data;

	output [32*50-1:0] position1, position2;
	
	input [31:0] head1Position, head2Position;

	// for the heads

	assign position1[31:0] = head1Position;
	assign position2[31:0] = head2Position;

	genvar i;
	generate
		for (i=1; i<50; i=i+1) begin: loop1_snakebody
			snakeBodyPart snakebody1(
				.prevPosition(position1[32*(i)-1:32*(i-1)]),
				.prevDirection(snake_data[2*(i)-1:2*(i-1)]),
				.position(position1[32*(i+1)-1:32*(i)])
			);
			
			snakeBodyPart snakebody2(
				.prevPosition(position2[32*(i)-1:32*(i-1)]),
				.prevDirection(snake_data[2*(i+50)-1:2*(i-1+50)]),
				.position(position2[32*(i+1)-1:32*(i)])
			);
		end
	endgenerate

endmodule

module snakeBodyPart(prevPosition, prevDirection, position);

	input [31:0] prevPosition;
	input [1:0] prevDirection;
	
	output [31:0] position;
	
	mux_4_1 snake_pos_mux (.out(position), .in0(prevPosition-40), 
		.in1(prevPosition+1), .in2(prevPosition+40), 
		.in3(prevPosition-1), .select(prevDirection));

endmodule











