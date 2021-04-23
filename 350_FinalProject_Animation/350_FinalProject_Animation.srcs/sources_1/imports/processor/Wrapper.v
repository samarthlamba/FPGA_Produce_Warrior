`timescale 1ns / 1ps
/**
 *  
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset, sclk, mosi, miso, ss, up, down, left, right, restx, resty, hSync, VSync, VGA_R, VGA_B, VGA_G, up_fpga, down_fpga, right_fpga, left_fpga, ps2_clk, ps2_data, anode, a7, a6, a5, a4, y2, y3, LEDvals, choose, sevenreset, LED_out, LED_out2, switch, micData, micClk, chSel, audioSound, audioEnable);
	input clock, reset, miso, sevenreset, switch;
	output sclk, mosi, ss;
	output up, down, left ,right, restx, resty;
	output hSync;
	output VSync;
	output[3:0] VGA_R, VGA_B, VGA_G;
	output[3:0] anode;
	output LED_out;
	output LED_out2;
	output a7, a6, a5, a4;
	inout ps2_clk;
	inout ps2_data;
	input up_fpga, down_fpga, right_fpga, left_fpga;
	input y2, y3;
	output[6:0] LEDvals;
	input choose;
	input micData;
	output micClk;
	output chSel;
	output audioSound;
	output audioEnable;

    reg up1, down1, left1, right1, restx1, resty1;

	wire[8:0] accel_x, accel_y;
	wire[11:0] accel_z;
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	wire screenEndVal;
	wire[31:0] reg_1_x, 
	reg_2_x, reg_3_x, reg_4_x, reg_5_x, reg_6_x, reg_7_x,
	reg_8_x;
	wire[31:0] reg_9_y, reg_10_y, reg_11_y, reg_12_y, reg_13_y,
	reg_14_y, reg_15_y, reg_16_y;
	wire[31:0]reg_29_rand;

	wire clock_final;

	wire lostlife;
	wire[2:0] livescount;
	
	
	assign clock_final = switch ? 1'b0 : clock;
	AccelerometerCtl accelerometer(.SYSCLK(clock), .RESET(reset), .SCLK(sclk), .MOSI(mosi), .MISO(miso), .SS(ss), .ACCEL_X_OUT(accel_x), .ACCEL_Y_OUT(accel_y), .ACCEL_MAG_OUT(accel_z));
    seven_seg_counter callcount(clock, sevenreset, anode, a7, a6, a5, a4, LEDvals, lostlife, livescount);
    AudioController audiooutput(clock, micData, audioOut, micClk, chSel, audioSound, audioEnable);
	always @(posedge clock_final) begin
	    if(accel_x == 385)
	       restx1 = 1'b1;
	    else
	       restx1 = 1'b0;  
		if(accel_x < 385)
		   down1 = 1'b1;
		else
		   down1 = 1'b0;
		if(accel_x > 385)
		   up1 = 1'b1;
		else
		   up1 = 1'b0;
		if(accel_y == 80)
		   resty1 = 1'b1;
		else
		   resty1 = 1'b0;
		if(accel_y < 80)
		   left1 = 1'b1;
		else
		   left1 = 1'b0;
		if(accel_y > 80)
		   right1 = 1'b1;
		else
		   right1 = 1'b0;
	end
	
	assign up = up1;
	assign down = down1;
	assign right = right1;
	assign left = left1;
	assign restx = restx1;
	assign resty = resty1;

    wire audioOut;
	
    VGAController vga(     
	 clock, 			
	 reset, 	
	 up_fpga,
	 down_fpga,
	 left_fpga,
	 right_fpga,
	 hSync, 
	 VSync,		
	 VGA_R,  
	 VGA_G,  
	 VGA_B,
	 ps2_clk,
	 ps2_data,
	 accel_x,
	 accel_y,
	 reg_1_x,
	 reg_2_x,
	 reg_3_x,
	 reg_4_x,
	 reg_5_x,
	 reg_6_x,
	 clk50,
	 screenEndVal,
	 clock_final,
	 lostlife,
	 livescount,
	 audioOut);
	
	 
	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "../Memory Files/lw_sw";
	reg clk50 = 0;
	reg [7:0] counter50Mh = 7'd0;
	wire [7:0]counterLimit;
	assign counterLimit =7'd100;
	
	always @(posedge clock) begin
	   if(switch == 1'b1)
	       clk50 = 1'b0;
	   else if(counter50Mh < counterLimit)
	           counter50Mh <= counter50Mh +1;
	   else begin
	       counter50Mh <= 0;
	       clk50 <= ~clk50;
	   end
	   end
	// Main Processing Unit
	
    wire [7:0] randomOut;
    wire isStalling;
	processor CPU(.clock(clk50), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut), .screenEnd(screenEndVal), .stall2(isStalling)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clk50), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clk50), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .screenEndVal(screenEndVal), .reg_out1(reg_1_x), 
	.reg_out2(reg_2_x), .reg_out3(reg_3_x), .reg_out4(reg_4_x), .reg_out5(reg_5_x), .reg_out6(reg_6_x), .reg_out7(reg_7_x),
	.reg_out8(reg_8_x), .reg_out9(reg_9_y), .reg_out10(reg_10_y), .reg_out11(reg_11_y), .reg_out12(reg_12_y), .reg_out13(reg_13_y),
	.reg_out14(reg_14_y), .reg_out15(reg_15_y), .reg_out16(reg_16_y), .reg_out29(reg_29_rand));
     assign LED_out = screenEndVal;   
     assign LED_out2 = reg_15_y == 32'd121;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
// Processor Memory (RAM)
	RAMproc ProcMem(.clk(clk50), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule