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

module Wrapper (clock, reset, sclk, mosi, miso, ss, up, down, left, right, restx, resty, hSync, VSync, VGA_R, VGA_B, VGA_G, up_fpga, down_fpga, right_fpga, left_fpga, ps2_clk, ps2_data);
	input clock, reset, miso;
	output sclk, mosi, ss;
	output up, down, left ,right, restx, resty;
	output hSync;
	output VSync;
	output[3:0] VGA_R, VGA_B, VGA_G;
	inout ps2_clk;
	inout ps2_data;
	input up_fpga, down_fpga, right_fpga, left_fpga;

    reg up1, down1, left1, right1, restx1, resty1;

	wire[8:0] accel_x, accel_y;
	wire[11:0] accel_z;
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	
	
	always @(posedge clock) begin
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

	AccelerometerCtl accelerometer(.SYSCLK(clock), .RESET(reset), .SCLK(sclk), .MOSI(mosi), .MISO(miso), .SS(ss), .ACCEL_X_OUT(accel_x), .ACCEL_Y_OUT(accel_y), .ACCEL_MAG_OUT(accel_z));

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
	 accel_y);
	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "";
	
	//Accel
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
