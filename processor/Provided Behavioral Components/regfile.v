module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, 
	data_readRegA, data_readRegB, screenEndVal, reg_out1, 
	reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, 
	reg_out9, reg_out10, reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out29
);

	input [31:0] screenEndVal;
	output [31:0] data_readRegA, data_readRegB;
	output [31:0] reg_out1, reg_out2, reg_out3, reg_out4, reg_out5, reg_out6, reg_out7, reg_out8, 
	reg_out9, reg_out10, reg_out11, reg_out12, reg_out13, reg_out14, reg_out15, reg_out16, reg_out29;


	// add your code here
	wire [31:0] reg_out0, reg_out17, reg_out18, 
	reg_out19, reg_out20, reg_out21, reg_out22, reg_out23, reg_out24, reg_out25, reg_out26, reg_out27, reg_out28, reg_out30, reg_out31,
	decoder_output;

input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;



	wire [31:0] and_gate, read_source1, read_source2;
	decoder decoder1(ctrl_writeEnable, ctrl_writeReg, decoder_output);
	decoder decoder2(1'b1, ctrl_readRegA, read_source1);
	decoder decoder3( 1'b1, ctrl_readRegB, read_source2);

	//decoder to and output (top of pic)
	genvar i;
	generate
		for (i = 0; i < 32; i = i +1) begin: loop1
			and and_value(and_gate[i], ctrl_writeEnable, decoder_output[i]);
		end
	endgenerate

	genvar k;
	generate
		for (k = 0; k < 32; k = k +1) begin: loop2
			and and_value(and_gate[k], ctrl_writeEnable, decoder_output[k]);
		end
	endgenerate

	register_32bits register_output0(reg_out0, {data_writeReg}, ~clock, 1'b0, ctrl_reset);
	register_32bits register_output1(reg_out1, data_writeReg, ~clock, and_gate[1], ctrl_reset);
	register_32bits register_output2(reg_out2, data_writeReg, ~clock, and_gate[2], ctrl_reset);
	register_32bits register_output3(reg_out3, data_writeReg, ~clock, and_gate[3], ctrl_reset);
	register_32bits register_output4(reg_out4, data_writeReg, ~clock, and_gate[4], ctrl_reset);
	register_32bits register_output5(reg_out5, data_writeReg, ~clock, and_gate[5], ctrl_reset);
	register_32bits register_output6(reg_out6, data_writeReg, ~clock, and_gate[6], ctrl_reset);
	register_32bits register_output7(reg_out7, data_writeReg, ~clock, and_gate[7], ctrl_reset);
	register_32bits register_output8(reg_out8, data_writeReg, ~clock, and_gate[8], ctrl_reset);
	register_32bits register_output9(reg_out9, data_writeReg, ~clock, and_gate[9], ctrl_reset);
	register_32bits register_output10(reg_out10, data_writeReg, ~clock, and_gate[10], ctrl_reset);
	register_32bits register_output11(reg_out11, data_writeReg, ~clock, and_gate[11], ctrl_reset);
	register_32bits register_output12(reg_out12, data_writeReg, ~clock, and_gate[12], ctrl_reset);
	register_32bits register_output13(reg_out13, data_writeReg, ~clock, and_gate[13], ctrl_reset);
	register_32bits register_output14(reg_out14, data_writeReg, ~clock, and_gate[14], ctrl_reset);
	register_32bits register_output15(reg_out15, data_writeReg, ~clock, and_gate[15], ctrl_reset);
	register_32bits register_output16(reg_out16, data_writeReg, ~clock, and_gate[16], ctrl_reset);
	register_32bits register_output17(reg_out17, data_writeReg, ~clock, and_gate[17], ctrl_reset);
	register_32bits register_output18(reg_out18, data_writeReg, ~clock, and_gate[18], ctrl_reset);
	register_32bits register_output19(reg_out19, data_writeReg, ~clock, and_gate[19], ctrl_reset);
	register_32bits register_output20(reg_out20, data_writeReg, ~clock, and_gate[20], ctrl_reset);
	register_32bits register_output21(reg_out21, data_writeReg, ~clock, and_gate[21], ctrl_reset);
	register_32bits register_output22(reg_out22, data_writeReg, ~clock, and_gate[22], ctrl_reset);
	register_32bits register_output23(reg_out23, data_writeReg, ~clock, and_gate[23], ctrl_reset);
	register_32bits register_output24(reg_out24, data_writeReg, ~clock, and_gate[24], ctrl_reset);
	register_32bits register_output25(reg_out25, data_writeReg, ~clock, and_gate[25], ctrl_reset);
	register_32bits register_output26(reg_out26, data_writeReg, ~clock, and_gate[26], ctrl_reset);
	register_32bits register_output27(reg_out27, data_writeReg, ~clock, and_gate[27], ctrl_reset);
	register_32bits register_output28(reg_out28, data_writeReg, ~clock, and_gate[28], ctrl_reset);
	register_32bits register_output29(reg_out29, data_writeReg, ~clock, and_gate[29], ctrl_reset);
	register_32bits register_output30(reg_out30, data_writeReg, ~clock, and_gate[30], ctrl_reset);
	register_32bits register_output31(reg_out31, data_writeReg, ~clock, and_gate[31], ctrl_reset);


	tri_state_buffer tri_state_output0(reg_out0, read_source1[0], data_readRegA);
	tri_state_buffer tri_state_output1(reg_out1, read_source1[1], data_readRegA);
	tri_state_buffer tri_state_output2(reg_out2, read_source1[2], data_readRegA);
	tri_state_buffer tri_state_output3(reg_out3, read_source1[3], data_readRegA);
	tri_state_buffer tri_state_output4(reg_out4, read_source1[4], data_readRegA);
	tri_state_buffer tri_state_output5(reg_out5, read_source1[5], data_readRegA);
	tri_state_buffer tri_state_output6(reg_out6, read_source1[6], data_readRegA);
	tri_state_buffer tri_state_output7(reg_out7, read_source1[7], data_readRegA);
	tri_state_buffer tri_state_output8(reg_out8, read_source1[8], data_readRegA);
	tri_state_buffer tri_state_output9(reg_out9, read_source1[9], data_readRegA);
	tri_state_buffer tri_state_output10(reg_out10, read_source1[10], data_readRegA);
	tri_state_buffer tri_state_output11(reg_out11, read_source1[11], data_readRegA);
	tri_state_buffer tri_state_output12(reg_out12, read_source1[12], data_readRegA);
	tri_state_buffer tri_state_output13(reg_out13, read_source1[13], data_readRegA);
	tri_state_buffer tri_state_output14(reg_out14, read_source1[14], data_readRegA);
	tri_state_buffer tri_state_output15(reg_out15, read_source1[15], data_readRegA);
	tri_state_buffer tri_state_output16(reg_out16, read_source1[16], data_readRegA);
	tri_state_buffer tri_state_output17(reg_out17, read_source1[17], data_readRegA);
	tri_state_buffer tri_state_output18(reg_out18, read_source1[18], data_readRegA);
	tri_state_buffer tri_state_output19(reg_out19, read_source1[19], data_readRegA);
	tri_state_buffer tri_state_output20(reg_out20, read_source1[20], data_readRegA);
	tri_state_buffer tri_state_output21(reg_out21, read_source1[21], data_readRegA);
	tri_state_buffer tri_state_output22(reg_out22, read_source1[22], data_readRegA);
	tri_state_buffer tri_state_output23(reg_out23, read_source1[23], data_readRegA);
	tri_state_buffer tri_state_output24(reg_out24, read_source1[24], data_readRegA);
	tri_state_buffer tri_state_output25(reg_out25, read_source1[25], data_readRegA);
	tri_state_buffer tri_state_output26(reg_out26, read_source1[26], data_readRegA);
	tri_state_buffer tri_state_output27(reg_out27, read_source1[27], data_readRegA);
	tri_state_buffer tri_state_output28(reg_out28, read_source1[28], data_readRegA);
	tri_state_buffer tri_state_output29(reg_out29, read_source1[29], data_readRegA);
	tri_state_buffer tri_state_output30(reg_out30, read_source1[30], data_readRegA);
	tri_state_buffer tri_state_output31(reg_out31, read_source1[31], data_readRegA);


	tri_state_buffer tri_state_outputB0(reg_out0, read_source2[0], data_readRegB);
	tri_state_buffer tri_state_outputB1(reg_out1, read_source2[1], data_readRegB);
	tri_state_buffer tri_state_outputB2(reg_out2, read_source2[2], data_readRegB);
	tri_state_buffer tri_state_outputB3(reg_out3, read_source2[3], data_readRegB);
	tri_state_buffer tri_state_outputB4(reg_out4, read_source2[4], data_readRegB);
	tri_state_buffer tri_state_outputB5(reg_out5, read_source2[5], data_readRegB);
	tri_state_buffer tri_state_outputB6(reg_out6, read_source2[6], data_readRegB);
	tri_state_buffer tri_state_outputB7(reg_out7, read_source2[7], data_readRegB);
	tri_state_buffer tri_state_outputB8(reg_out8, read_source2[8], data_readRegB);
	tri_state_buffer tri_state_outputB9(reg_out9, read_source2[9], data_readRegB);
	tri_state_buffer tri_state_outputB10(reg_out10, read_source2[10], data_readRegB);
	tri_state_buffer tri_state_outputB11(reg_out11, read_source2[11], data_readRegB);
	tri_state_buffer tri_state_outputB12(reg_out12, read_source2[12], data_readRegB);
	tri_state_buffer tri_state_outputB13(reg_out13, read_source2[13], data_readRegB);
	tri_state_buffer tri_state_outputB14(reg_out14, read_source2[14], data_readRegB);
	tri_state_buffer tri_state_outputB15(reg_out15, read_source2[15], data_readRegB);
	tri_state_buffer tri_state_outputB16(reg_out16, read_source2[16], data_readRegB);
	tri_state_buffer tri_state_outputB17(reg_out17, read_source2[17], data_readRegB);
	tri_state_buffer tri_state_outputB18(reg_out18, read_source2[18], data_readRegB);
	tri_state_buffer tri_state_outputB19(reg_out19, read_source2[19], data_readRegB);
	tri_state_buffer tri_state_outputB20(reg_out20, read_source2[20], data_readRegB);
	tri_state_buffer tri_state_outputB21(reg_out21, read_source2[21], data_readRegB);
	tri_state_buffer tri_state_outputB22(reg_out22, read_source2[22], data_readRegB);
	tri_state_buffer tri_state_outputB23(reg_out23, read_source2[23], data_readRegB);
	tri_state_buffer tri_state_outputB24(reg_out24, read_source2[24], data_readRegB);
	tri_state_buffer tri_state_outputB25(reg_out25, read_source2[25], data_readRegB);
	tri_state_buffer tri_state_outputB26(reg_out26, read_source2[26], data_readRegB);
	tri_state_buffer tri_state_outputB27(reg_out27, read_source2[27], data_readRegB);
	tri_state_buffer tri_state_outputB28(reg_out28, read_source2[28], data_readRegB);
	tri_state_buffer tri_state_outputB29(reg_out29, read_source2[29], data_readRegB);
	tri_state_buffer tri_state_outputB30(reg_out30, read_source2[30], data_readRegB);
	tri_state_buffer tri_state_outputB31(reg_out31, read_source2[31], data_readRegB);



endmodule
