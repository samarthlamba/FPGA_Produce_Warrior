`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input up,
	input down,
	input left,
	input right,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "../assetsMemFiles/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock 
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	
	wire[9:0] x;
	wire[8:0] y;

	reg appleStatus;
	reg waterStatus;
	reg lemonStatus;
	reg pearStatus;
	reg bananaStatus;
	reg coconutStatus;
	reg[9:0] xcoordinateApple;
	wire[2:0] chosenForeground;
	wire[2:0] chosenForeBackground;
	reg[8:0] ycoordinateApple;
	reg[9:0] xcoordinateWater;
	reg[8:0] ycoordinateWater;
	reg[9:0] xcoordinatePear;
	reg[8:0] ycoordinatePear;
	reg[9:0] xcoordinateBanana;
	reg[8:0] ycoordinateBanana;
	reg[9:0] xcoordinateCoconut;
	reg[8:0] ycoordinateCoconut;
	reg[9:0] xcoordinateLemon;
	reg[8:0] ycoordinateLemon;
	wire sqcolor;
	assign sqcolor = 12'h128;

	
	always @(posedge clk) begin
	   if(x < xcoordinateLemon + 10'd50 && y < ycoordinateLemon + 10'd50 && x > xcoordinateLemon && y > ycoordinateLemon)
			lemonStatus = 1'b1;
		else
			lemonStatus = 1'b0;
		if(x <= xcoordinatePear + 10'd50 && y < ycoordinatePear + 10'd50 && x > xcoordinatePear && y > ycoordinatePear)
			pearStatus = 1'b1;
		else
			pearStatus = 1'b0;
		if(x < xcoordinateBanana + 10'd50 && y < ycoordinateBanana + 10'd50 && x > xcoordinateBanana && y > ycoordinateBanana)
			bananaStatus = 1'b1;
		else
			bananaStatus = 1'b0;
		if(x < xcoordinateCoconut + 10'd50 && y < ycoordinateCoconut + 10'd50 && x > xcoordinateCoconut && y > ycoordinateCoconut)
			coconutStatus = 1'b1;
		else
			coconutStatus = 1'b0;
		if(x < xcoordinateApple + 10'd50 && y < ycoordinateApple + 10'd50 && x >= xcoordinateApple && y > ycoordinateApple)
			appleStatus = 1'b1;
		else
			appleStatus = 1'b0;
        if(x < xcoordinateWater + 10'd50 && y < ycoordinateWater + 10'd50 && x >= xcoordinateWater && y > ycoordinateWater)
			waterStatus = 1'b1;
		else
			waterStatus = 1'b0;
	   
	end
    encoder_8_bit chooser(chosenForeground, 1'b1, appleStatus && colorDataBackgroundApple !=12'h000, waterStatus && colorDataBackgroundWatermelon !=12'h000, lemonStatus && colorDataBackgroundLemon !=12'h000, pearStatus && colorDataBackgroundPear !=12'h000, bananaStatus && colorDataBackgroundBanana !=12'h000, coconutStatus && colorDataBackgroundCoconut !=12'h000, 1'b0);
    encoder_8_bit chooser2(chosenForeBackground, 1'b1, appleStatus && chosenForeground != 3'd1, waterStatus && chosenForeground != 3'd2, lemonStatus  && chosenForeground != 3'd3, pearStatus && chosenForeground != 3'd4, bananaStatus && chosenForeground != 3'd5, coconutStatus && chosenForeground != 3'd6, 1'b0);
    
    always @(posedge clk) begin
        if(up && screenEnd)
            ycoordinateWater = ycoordinateWater - 1'b1;
        else if(down && screenEnd)
            ycoordinateWater = ycoordinateWater + 1'b1;
        else if(right && screenEnd)
            xcoordinateWater = xcoordinateWater + 1'b1;
        else if(left && screenEnd)
            xcoordinateWater = xcoordinateWater - 1'b1;
        
        ycoordinateApple = 20;
         xcoordinateApple = 20;
        xcoordinatePear = 40;;
        ycoordinatePear = 40;;
 	    xcoordinateBanana = 60;
	    ycoordinateBanana =60;
	    xcoordinateCoconut =80;
      ycoordinateCoconut =80;
	    xcoordinateLemon =100;
	    ycoordinateLemon =100;        
        
    end

	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[BITS_PER_COLOR-1:0] colorDataBackground; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundWatermelon; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundApple; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundLemon; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundPear; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundBanana;
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundCoconut;
	imageSetter water(colorDataBackgroundWatermelon, clk, x, y, xcoordinateWater, ycoordinateWater);
    imageSetterApple apple(colorDataBackgroundApple, clk, x, y, xcoordinateApple, ycoordinateApple);
    imageSetterLemon lemon(colorDataBackgroundLemon, clk, x, y, xcoordinateLemon, ycoordinateLemon);
    imageSetterPear pear(colorDataBackgroundPear, clk, x, y, xcoordinatePear, ycoordinatePear);
    imageSetterBanana banana(colorDataBackgroundBanana, clk, x, y, xcoordinateBanana, ycoordinateBanana);
    imageSetterCoconut coconut(colorDataBackgroundCoconut, clk, x, y, xcoordinateCoconut, ycoordinateCoconut);
//---------------------------------------------------------------------------------------------------------------

	wire[BITS_PER_COLOR-1:0] colorDataBackground1; 
	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress1;
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr1;
	assign imgAddress1 = x + 640*y;

	
	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "dojoimage.mem"})) // Memory initialization
	ImageData1(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress1),					 // Image data address
		.dataOut(colorAddr1),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "dojocolors.mem"}))  // Memory initialization
	ColorPalette1(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr1),					       // Address from the ImageData RAM
		.dataOut(colorDataBackground1),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	wire[BITS_PER_COLOR-1:0] colorChoose; 
	wire[BITS_PER_COLOR-1:0] colordata;
	wire[BITS_PER_COLOR-1:0] colordataForeBackground;
	wire[BITS_PER_COLOR-1:0] colorChooseFinal;
	wire calculation;
	
	mux_eight_one colorDataChooser(colordata, chosenForeground, colorDataBackground1, colorDataBackgroundApple, colorDataBackgroundWatermelon,colorDataBackgroundLemon,colorDataBackgroundPear, colorDataBackgroundBanana,colorDataBackgroundCoconut, colorDataBackground1);
	mux_eight_one colorDataChooser2(colordataForeBackground, chosenForeBackground, colorDataBackground1, colorDataBackgroundApple, colorDataBackgroundWatermelon,colorDataBackgroundLemon,colorDataBackgroundPear, colorDataBackgroundBanana,colorDataBackgroundCoconut, colorDataBackground1);
	assign colorChoose = colordata;
	assign colorOut = active ?  colorChoose : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule