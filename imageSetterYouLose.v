module imageSetterYouLose(out, clk, x, y, xcoordinateApple1, ycoordinateApple1);

    input clk;
    output[12-1:0] out;
    input[9:0] x;
	input[8:0] y;
	input[9:0] xcoordinateApple1;
	input[8:0] ycoordinateApple1;
	reg [40:0] name;

    
    localparam 
        
        // Number of pixels on the screen
        VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480, // Standard VGA Height
		PIXEL_COUNT_FRUIT = 50*50,
		FILES_PATH = "../assetsMemFiles/",
		PIXEL_ADDRESS_WIDTH_FRUIT = $clog2(PIXEL_COUNT_FRUIT) + 1,// Use built in log2 command
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command; 								 // Number of Colors available

	wire[PIXEL_ADDRESS_WIDTH_FRUIT-1:0] imgAddress;  	 // Image address for the image data
	
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x-xcoordinateApple1 + 50*(y-ycoordinateApple1);				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT_FRUIT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH_FRUIT),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, {"youLose", "image.mem"}})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorDataBackground; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, {"youLose", "colors.mem"}}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorDataBackground),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
        assign out = colorDataBackground;
endmodule