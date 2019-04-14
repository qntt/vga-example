module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,up,down,left,right, dividedclock);

	
input iRST_n;
input iVGA_CLK;
input up,down,left,right;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;

input dividedclock;

integer counter;
                        
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
     ADDR<=19'd100000;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd100000;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
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
reg [9:0] x_square,y_square;
wire [10:0] addressX,addressY;
//reg [8:0] y;
wire [18:0] address;
assign address = (y_square*10'd640) + x_square;
wire [6:0] width;
assign width = 7'd100;
assign addressX = ADDR % 640;
assign addressY = ADDR / 640;
reg [19:0] count;

reg [7:0] index2;

initial begin
	x_square = 10'd100;
	y_square = 10'd100;
	count = 20'd0;
	
	counter = 0;
end

always@(posedge dividedclock)
begin
		if (ADDR % 2 ==0) begin
			index2 = 8'd0;
		end
		
		if (ADDR % 2 ==0) begin
			index2 = 8'd1;
		end

		if (counter == 0) begin
		
		end
		
		
		if (counter == 1) begin
		
		end
		
		
		if (counter == 2) begin
			
		end
		
		
		if (counter == 3) begin
			
		end
		
		
		// reset the counter
		if (counter == 4) begin
			counter = 0;
		end
		
		
		counter = counter + 1;
		
		
		
		
		
		
		
		
		
		
		

//
//	if (count < 20'd1000000) begin
//		count = count + 20'd1;
//	end 
//	else if (count == 20'd1000000) begin
//		count = 20'd0;
//		if (~up) begin
//			y_square = y_square - 10'd1;
//		end else if (~down) begin
//			y_square = y_square + 10'd1;
//		end else if (~left) begin
//			x_square = x_square - 10'd1;
//		end else if (~right) begin
//			x_square = x_square + 10'd1;
//		end
//	end
//	
//	if (addressX <= x_square + 10'd99 & addressX >= x_square & addressY <= y_square+10'd99 & addressY >= y_square) begin
//		index2 = 8'd2;
//	end
//	else begin
//		index2 = index[7:0];
//	end
	
end
/*
always@(negedge up or negedge down or negedge left or negedge right)
begin 
	if (~up) begin
		y_square = y_square - 10'd1;
	end else if (~down) begin
		y_square = y_square + 10'd1;
	end else if (~left) begin
		x_square = x_square - 10'd1;
	end else if (~right) begin
		x_square = x_square + 10'd1;
	end
end*/
	
//////Color table output
img_index	img_index_inst (
	.address ( index2 ),
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
 	















