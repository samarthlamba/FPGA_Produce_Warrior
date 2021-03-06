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
	inout ps2_data,
	input[8:0] x_accelerometer,
	input[8:0] y_accelerometer,
	input [31:0] reg_1_x,
	input [31:0] reg_2_x,
	input [31:0] reg_3_x,
	input [31:0] reg_4_x,
	input [31:0] reg_5_x,
	input [31:0] reg_6_x,
	input clk50,
	output screenEndVal,
	input clock_final,
	output lostlife,
	output [4:0] livescount,
	output audioOut,
	output youLoseOut,
	input [31:0] reg_9_y);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "../assetsMemFiles/";
    
	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock 
	reg clkLeft_Right;
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end
    reg [6:0] counter1;
    always @(posedge clk) begin
        counter1 = counter1+1;
        
        clkLeft_Right = counter1[4];
    
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
	reg hammerStatus;
	reg pearStatus;
	reg bananaStatus;
	reg youLoseStatus;
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
	reg[9:0] xcoordinateHammer;
	reg[8:0] ycoordinateHammer;
	wire sqcolor;
	wire splashApple;
	wire splashWatermelon;
	wire splashLemon;
	wire splashPear;
	wire splashCoconut;
	wire splashBanana;
	
	reg waterUp;
	reg lemonUp;
	reg pearUp;
	reg bananaUp;
	reg appleUp;
	reg coconutUp;
	reg [7:0] seed;
	wire [7:0] randomOut;
	reg load;
	reg [3:0] updated;
	reg[4:0] counts;
	reg lifelost;
	reg splashHammer;
    reg splashWater = 1'b0;
    reg splashApples = 1'b0;
    reg splashPears = 1'b0;
    reg splashBananas = 1'b0;
    reg splashCoconuts = 1'b0;
    reg splashLemons = 1'b0;
    reg splashHammer = 1'b0;
    wire splashWatercheck;
    wire splashApplecheck;
    wire splashPearcheck;
    wire splashCoconutcheck;
    wire splashLemoncheck;
    wire splashBananacheck; 
	
	wire waterUpAndSplash;
	
	
	assign sqcolor = 12'h128;
	assign screenEndVal = ~screenEnd;
	
	   initial begin
	   splashHammer = 1'b0;
		    counts = 3'b000;
   			lifelost = 1'b0;
	       updated = 4'b0;
	       waterUp = 1'b1;
	       lemonUp = 1'b1;
           pearUp = 1'b1;
           bananaUp = 1'b1;
           appleUp = 1'b1;
          coconutUp = 1'b1;
            xcoordinateApple = 427;
            xcoordinatePear = 350;
            xcoordinateBanana = 60;
            xcoordinateCoconut =220;
            xcoordinateLemon =160;
             ycoordinateApple = 50;
            ycoordinatePear = 50;
            ycoordinateBanana = 90;
            ycoordinateCoconut =70;
            ycoordinateLemon =78;
            xcoordinateWater = 82;
            youLoseStatus = 1'b0;
	   end
     
	always @(posedge clk) begin
	    if(x < 210 + 10'd200 && y < 120 + 10'd200 && x > 210 && y > 120)
	       youLoseStatus = 1'b1;
        else
            youLoseStatus = 1'b0;
	    if(x < xcoordinateLemon + 10'd50 && y < ycoordinateLemon + 10'd50 && x > xcoordinateLemon && y > ycoordinateLemon)
			lemonStatus = 1'b1;
		else
			lemonStatus = 1'b0;
        if(x < xcoordinateHammer + 10'd100 && y < ycoordinateHammer + 10'd100 && x > xcoordinateHammer && y > ycoordinateHammer)
			hammerStatus = 1'b1;
		else
			hammerStatus = 1'b0;
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
    always @(posedge clk50 && reg_1_x != 10'd0 && screenEnd) begin
        if((clk25 && reg_1_x > 32'b0 && ycoordinateWater >= 460))
            xcoordinateWater =  reg_1_x[9:0] + 15;
        else if(xcoordinateWater < 380 && clkLeft_Right)
            xcoordinateWater = xcoordinateWater+1;
        else
            xcoordinateWater = xcoordinateWater - 1;
        if((clk25 && reg_1_x > 32'b0 && ycoordinateApple >= 460))
            xcoordinateApple = reg_2_x[9:0] - 20;
         else if(xcoordinateApple < 380 && clkLeft_Right)
            xcoordinateApple = xcoordinateApple+1;
         else
            xcoordinateApple = xcoordinateApple - 1;
        if(clk25 && reg_1_x > 32'b0 && ycoordinatePear >= 460)
            xcoordinatePear = reg_3_x[9:0] + 15;
        else if(xcoordinatePear < 380 && clkLeft_Right)
            xcoordinatePear = xcoordinatePear+1;
           else
            xcoordinatePear = xcoordinatePear - 1;
        if(clk25 && reg_1_x > 32'b0 && ycoordinateBanana >= 460)
            xcoordinateBanana = reg_4_x[9:0] - 20;
        else if(xcoordinateBanana < 380 && clkLeft_Right)
            xcoordinateBanana = xcoordinateBanana+1;
           else
            xcoordinateBanana = xcoordinateBanana - 1;
        if(clk25 && reg_1_x > 32'b0 && ycoordinateCoconut >= 460)
            xcoordinateCoconut = reg_5_x[9:0] + 15;
         else if(xcoordinateCoconut < 380 && clkLeft_Right)
            xcoordinateCoconut = xcoordinateCoconut+1;
           else
            xcoordinateCoconut = xcoordinateCoconut - 1;
        if(clk25 && reg_1_x > 32'b0  &&ycoordinateLemon >= 460)
            xcoordinateLemon = reg_6_x;
          else if(ycoordinateLemon < 380 && clkLeft_Right)
            xcoordinateLemon = xcoordinateLemon + 1;
           else
            xcoordinateLemon = xcoordinateLemon - 1;
  
    end
    always @(posedge clock_final) begin
        if(ycoordinateWater <= 9'd480 && screenEnd && waterUp == 1'b1)
            ycoordinateWater = ycoordinateWater + 1'b1;
        else if(ycoordinateWater > 9'd480 && waterUp == 1'b1)
            waterUp = ~waterUp;
        if(ycoordinateWater < 9'd110 && waterUp == 1'b0)
            waterUp = ~waterUp;
          if(ycoordinateWater >= 9'd110 && screenEnd && waterUp == 1'b0)
            ycoordinateWater = ycoordinateWater - 1'b1;
         if(ycoordinateApple <= 9'd480 && screenEnd && appleUp == 1'b1)
            ycoordinateApple = ycoordinateApple + 1'b1;
        else if(ycoordinateApple > 9'd480 && appleUp == 1'b1)
            appleUp = ~appleUp;
        if(ycoordinateApple < 9'd110 && appleUp == 1'b0)
            appleUp = ~appleUp;
        if(ycoordinateApple >= 9'd110 && screenEnd && appleUp == 1'b0)
            ycoordinateApple = ycoordinateApple - 1'b1;
            
                 
        if(ycoordinatePear <= 9'd480 && screenEnd && pearUp == 1'b1)
            ycoordinatePear = ycoordinatePear + 1'b1;
        else if(ycoordinatePear > 9'd480 && pearUp == 1'b1)
            pearUp = ~pearUp;
        if(ycoordinatePear < 9'd110 && pearUp == 1'b0)
            pearUp = ~pearUp;
        if(ycoordinatePear >= 9'd110 && screenEnd && pearUp == 1'b0)
            ycoordinatePear = ycoordinatePear - 1'b1;
            
         
        if(ycoordinateBanana <= 9'd480 && screenEnd && bananaUp == 1'b1)
            ycoordinateBanana = ycoordinateBanana + 1'b1;
        else if(ycoordinateBanana > 9'd480 && bananaUp == 1'b1)
            bananaUp = ~bananaUp;
        if(ycoordinateBanana < 9'd110 && bananaUp == 1'b0)
            bananaUp = ~bananaUp;
        if(ycoordinateBanana >= 9'd110 && screenEnd && bananaUp == 1'b0)
            ycoordinateBanana = ycoordinateBanana - 1'b1;
 
         if(ycoordinateCoconut <= 9'd480 && screenEnd && coconutUp == 1'b1)
            ycoordinateCoconut = ycoordinateCoconut + 1'b1;
        else if(ycoordinateCoconut > 9'd480 && coconutUp == 1'b1)
            coconutUp = ~coconutUp;
        if(ycoordinateCoconut < 9'd110 && coconutUp == 1'b0)
            coconutUp = ~coconutUp;
        if(ycoordinateCoconut >= 9'd110 && screenEnd && coconutUp == 1'b0)
            ycoordinateCoconut = ycoordinateCoconut - 1'b1;
            
   
                   
        if(ycoordinateLemon <= 9'd480 && screenEnd && lemonUp == 1'b1)
            ycoordinateLemon = ycoordinateLemon + 1'b1;
        else if(ycoordinateLemon > 9'd480 && lemonUp == 1'b1)
            lemonUp = ~lemonUp;
        if(ycoordinateLemon < 9'd110 && lemonUp == 1'b0)
            lemonUp = ~lemonUp;
        if(ycoordinateLemon >= 9'd110 && screenEnd && lemonUp == 1'b0)
            ycoordinateLemon = ycoordinateLemon - 1'b1;   
           if(splashWatercheck || splashApplecheck || splashPearcheck || splashCoconutcheck || splashBananacheck || splashLemoncheck) begin
                splashHammer <= 1'b1;
           end
           else
            splashHammer <= 1'b0;
        xcoordinateHammer = x_accelerometer;
		ycoordinateHammer = y_accelerometer; 
		  //updated = 4'b1;
		 
    end
    imagecollision watermelonsplash(xcoordinateWater, ycoordinateWater, x_accelerometer, y_accelerometer, 10'd50, splashWatercheck);
    imagecollision applesplash(xcoordinateApple, ycoordinateApple, x_accelerometer, y_accelerometer, 10'd50, splashApplecheck);
    imagecollision pearsplash(xcoordinatePear, ycoordinatePear, x_accelerometer, y_accelerometer, 10'd50, splashPearcheck);
    imagecollision coconutsplash(xcoordinateCoconut, ycoordinateCoconut, x_accelerometer, y_accelerometer, 10'd50, splashCoconutcheck);
    imagecollision bananasplash(xcoordinateBanana, ycoordinateBanana, x_accelerometer, y_accelerometer, 10'd50, splashBananacheck);
    imagecollision lemonsplash(xcoordinateLemon, ycoordinateLemon, x_accelerometer, y_accelerometer, 10'd50, splashLemoncheck);
    //assign splashWatermelon = waterUp;
	
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
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundHammer; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundPear; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundBanana;
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundCoconut;
	imageSetter water(colorDataBackgroundWatermelon, clk, x, y, xcoordinateWater, ycoordinateWater);
    imageSetterApple apple(colorDataBackgroundApple, clk, x, y, xcoordinateApple, ycoordinateApple);
    imageSetterLemon lemon(colorDataBackgroundLemon, clk, x, y, xcoordinateLemon, ycoordinateLemon);
    imageSetterPear pear(colorDataBackgroundPear, clk, x, y, xcoordinatePear, ycoordinatePear);
    imageSetterBanana banana(colorDataBackgroundBanana, clk, x, y, xcoordinateBanana, ycoordinateBanana);
    imageSetterCoconut coconut(colorDataBackgroundCoconut, clk, x, y, xcoordinateCoconut, ycoordinateCoconut);
    imageSetterHammer hammer(colorDataBackgroundHammer, clk, x, y, xcoordinateHammer, ycoordinateHammer);
    
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundAppleSplash; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundWatermelonSplash; 

	//wire[BITS_PER_COLOR-1:0] colorDataBackgroundAppleSplash; 

	wire[BITS_PER_COLOR-1:0] colorDataBackgroundLemonSplash; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundPearSplash; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundBananaSplash;
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundCoconutSplash;    
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundLose;
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundHammerSplash;  
    imageSetterWatermelonSplash waterSplash(colorDataBackgroundWatermelonSplash, clk, x, y, xcoordinateWater, ycoordinateWater);
    imageSetterAppleSplash appleSplash(colorDataBackgroundAppleSplash, clk, x, y, xcoordinateApple, ycoordinateApple);
    imageSetterLemonSplash lemonSplash(colorDataBackgroundLemonSplash, clk, x, y, xcoordinateLemon, ycoordinateLemon);
    imageSetterPearSplash pearSplash(colorDataBackgroundPearSplash, clk, x, y, xcoordinatePear, ycoordinatePear);
    imageSetterBananaSplash bananaSplash(colorDataBackgroundBananaSplash, clk, x, y, xcoordinateBanana, ycoordinateBanana);
    imageSetterCoconutSplash coconutSplash(colorDataBackgroundCoconutSplash, clk, x, y, xcoordinateCoconut, ycoordinateCoconut);
     imageSetterHammerSplash hammerSplash(colorDataBackgroundHammerSplash, clk, x, y, xcoordinateHammer, ycoordinateHammer);
    imageSetterYouLose youLose(colorDataBackgroundLose, clk, x, y, 10'd210, 9'd120);
    
    wire[BITS_PER_COLOR-1:0] colorDataBackgroundAppleFinal; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundWatermelonFinal; 
	//integer[BITS_PER_COLOR-1:0] colorDataBackgroundWate
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundLemonFinal; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundPearFinal; 
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundBananaFinal;
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundCoconutFinal;    
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundLemonFinal;  
	wire[BITS_PER_COLOR-1:0] colorDataBackgroundHammerFinal;
	
//	always @(posedge clk) begin
//	   if(waterUp == 1'b1) begin
	   
//	   end
//	end
    integer Watercount = 0;
    integer Applecount = 0;
    integer Pearcount = 0;
    integer Bananacount = 0;
    integer Coconutcount = 0;
    integer Lemoncount = 0;
    
    
    
   always @(posedge clk) begin
    if(splashWatercheck == 1'b1) begin
        Watercount <= Watercount + 1;
        splashWater <= 1'b1;
        //audioOut_reg = 1'b1;
    end
    if(waterUp == 1'b1) begin
        if(Watercount > 0) begin
        splashWater <= 1'b1;
        //audioOut_reg = 1'b1;
        end
    end
    if(waterUp == 1'b0 && ycoordinateWater >=479) begin
        Watercount <= 0;
        splashWater <= 1'b0;
        //audioOut_reg = 1'b0;
    end
    if(splashApplecheck == 1'b1) begin
        Applecount <= Applecount + 1;
        splashApples <= 1'b1;
    end
    if(appleUp == 1'b1) begin
        if(Applecount > 0) begin
        splashApples <= 1'b1;
        end
    end
    if(appleUp == 1'b0 && ycoordinateApple >=479) begin
        Applecount <= 0;
        splashApples <= 1'b0;
    end
    if(splashPearcheck == 1'b1) begin
        Pearcount <= Pearcount + 1;
        splashPears <= 1'b1;
    end
    if(pearUp == 1'b1) begin
        if(Pearcount > 0) begin
        splashPears <= 1'b1;
        end
    end
    if(pearUp == 1'b0 && ycoordinatePear >=479) begin
        Pearcount <= 0;
        splashPears <= 1'b0;
    end
    if(splashBananacheck == 1'b1) begin
        Bananacount <= Bananacount + 1;
        splashBananas <= 1'b1;
    end
    if(bananaUp == 1'b1) begin
        if(Bananacount > 0) begin
        splashBananas <= 1'b1;
        end
    end
    if(bananaUp == 1'b0 && ycoordinatePear >=479) begin
        Bananacount <= 0;
        splashBananas <= 1'b0;
    end
    if(splashCoconutcheck == 1'b1) begin
        Coconutcount <= Coconutcount + 1;
        splashCoconuts <= 1'b1;
    end
    if(coconutUp == 1'b1) begin
        if(Coconutcount > 0) begin
        splashCoconuts <= 1'b1;
        end
    end
    if(coconutUp == 1'b0 && ycoordinateCoconut >=479) begin
        Coconutcount <= 0;
        splashCoconuts <= 1'b0;
    end
    
       if(splashLemoncheck == 1'b1) begin
        Lemoncount <= Coconutcount + 1;
        splashLemons <= 1'b1;
    end
    if(lemonUp == 1'b1) begin
        if(Lemoncount > 0) begin
        splashLemons <= 1'b1;
        end
    end
    if(lemonUp == 1'b0 && ycoordinateLemon >=479) begin
        Lemoncount <= 0;
        splashLemons <= 1'b0;
    end

   end
    
   
  
   // TODO: this just automatically goes to 3 lives no matter what...lostlife is whether or not the lives need to be displayed
   //livescount is what to display (see seven seg counter)
   reg audioOut_reg;
   always@(posedge screenEnd) begin
    if(lifelost != 1'b1 && ((ycoordinateWater >= 478 && waterUp == 1'b0 && splashWater == 1'b0 && ycoordinateWater <= 479) || (ycoordinateApple <= 479 && ycoordinateApple >= 478 && appleUp == 1'b0 && splashApple == 1'b0) || (ycoordinatePear <= 479 && ycoordinatePear >= 478 && pearUp == 1'b0 && splashPear == 1'b0) || (ycoordinateBanana >= 478 && bananaUp == 1'b0 && splashBanana == 1'b0) || (ycoordinateCoconut >= 478 && coconutUp == 1'b0 && splashCoconut == 1'b0))) begin
        lifelost <= 1'b1;
         counts <= counts + 1'b1;
         audioOut_reg <= 1'b1;
    end
    //it beeps and switches everytime at the bottom, confused how to switch
    else begin
    //counts = 3'd2;
    lifelost <= 1'b0;
    audioOut_reg <= 1'b0;
    end
    end
    
    assign lostlife = lifelost;  //doesnt matter
    assign livescount = counts;
    assign audioOut = audioOut_reg;
    
    assign splashWatermelon = splashWater;
    assign splashApple = splashApples;
    assign splashPear = splashPears;
    assign splashBanana = splashBananas;
    assign splashCoconut = splashCoconuts;
    assign splashLemon= splashLemons;
    
	   
	assign colorDataBackgroundAppleFinal = splashApple ? colorDataBackgroundAppleSplash : colorDataBackgroundApple;
	assign colorDataBackgroundWatermelonFinal = splashWatermelon ? colorDataBackgroundWatermelonSplash : colorDataBackgroundWatermelon;
	assign colorDataBackgroundLemonFinal = splashLemon ? colorDataBackgroundLemonSplash : colorDataBackgroundLemon;
	assign colorDataBackgroundPearFinal = splashPear ? colorDataBackgroundPearSplash : colorDataBackgroundPear;
	assign colorDataBackgroundBananaFinal = splashBanana ? colorDataBackgroundBananaSplash : colorDataBackgroundBanana;
	assign colorDataBackgroundCoconutFinal = splashCoconut ? colorDataBackgroundCoconutSplash : colorDataBackgroundCoconut;
	assign colorDataBackgroundHammerFinal = splashHammer ? colorDataBackgroundHammerSplash : colorDataBackgroundHammer;
	
	
	encoder_8_bit chooser(chosenForeground, 1'b1, appleStatus && colorDataBackgroundAppleFinal !=12'h000, waterStatus && colorDataBackgroundWatermelonFinal !=12'h000, lemonStatus && colorDataBackgroundLemonFinal !=12'h000, pearStatus && colorDataBackgroundPearFinal !=12'h000, bananaStatus && colorDataBackgroundBananaFinal !=12'h000, coconutStatus && colorDataBackgroundCoconutFinal !=12'h000, hammerStatus && colorDataBackgroundHammerFinal != 12'hfff &&  colorDataBackgroundHammerFinal != 12'h000 );
    encoder_8_bit chooser2(chosenForeBackground, 1'b1, appleStatus && chosenForeground != 3'd1, waterStatus && chosenForeground != 3'd2, lemonStatus  && chosenForeground != 3'd3, pearStatus && chosenForeground != 3'd4, bananaStatus && chosenForeground != 3'd5, coconutStatus && chosenForeground != 3'd6, 1'b0);
    
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
	
	assign youLoseOut = youLoseStatus;
	mux_eight_one colorDataChooser(colordata, chosenForeground, colorDataBackground1, colorDataBackgroundAppleFinal, colorDataBackgroundWatermelonFinal,colorDataBackgroundLemonFinal,colorDataBackgroundPearFinal, colorDataBackgroundBananaFinal,colorDataBackgroundCoconutFinal, colorDataBackgroundHammerFinal);
	mux_eight_one colorDataChooser2(colordataForeBackground, chosenForeBackground, colorDataBackground1, colorDataBackgroundApple, colorDataBackgroundWatermelon,colorDataBackgroundLemon,colorDataBackgroundPear, colorDataBackgroundBanana,colorDataBackgroundCoconut, colorDataBackgroundHammerFinal);
	assign colorChoose = (youLoseStatus ===1'b1 && colorDataBackgroundLose != 12'h000 && livescount >= 9) ? colorDataBackgroundLose : colordata;
	assign colorOut = active ?  colorChoose : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule