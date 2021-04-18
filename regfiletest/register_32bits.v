module register_32bits(out, in, clk, input_enable, clr);

    input[31:0] in;
    input clk;
    input input_enable;
    input clr;
    output[31:0] out;

    dffe_ref d_flip_flop0(out[0], in[0], clk, input_enable, clr);
    dffe_ref d_flip_flop1(out[1], in[1], clk, input_enable, clr);
    dffe_ref d_flip_flop2(out[2], in[2], clk, input_enable, clr);
    dffe_ref d_flip_flop3(out[3], in[3], clk, input_enable, clr);
    dffe_ref d_flip_flop4(out[4], in[4], clk, input_enable, clr);
    dffe_ref d_flip_flop5(out[5], in[5], clk, input_enable, clr);
    dffe_ref d_flip_flop6(out[6], in[6], clk, input_enable, clr);
    dffe_ref d_flip_flop7(out[7], in[7], clk, input_enable, clr);
    dffe_ref d_flip_flop8(out[8], in[8], clk, input_enable, clr);
    dffe_ref d_flip_flop9(out[9], in[9], clk, input_enable, clr);
    dffe_ref d_flip_flop10(out[10], in[10], clk, input_enable, clr);
    dffe_ref d_flip_flop11(out[11], in[11], clk, input_enable, clr);
    dffe_ref d_flip_flop12(out[12], in[12], clk, input_enable, clr);
    dffe_ref d_flip_flop13(out[13], in[13], clk, input_enable, clr);
    dffe_ref d_flip_flop14(out[14], in[14], clk, input_enable, clr);
    dffe_ref d_flip_flop15(out[15], in[15], clk, input_enable, clr);
    dffe_ref d_flip_flop16(out[16], in[16], clk, input_enable, clr);
    dffe_ref d_flip_flop17(out[17], in[17], clk, input_enable, clr);
    dffe_ref d_flip_flop18(out[18], in[18], clk, input_enable, clr);
    dffe_ref d_flip_flop19(out[19], in[19], clk, input_enable, clr);
    dffe_ref d_flip_flop20(out[20], in[20], clk, input_enable, clr);
    dffe_ref d_flip_flop21(out[21], in[21], clk, input_enable, clr);
    dffe_ref d_flip_flop22(out[22], in[22], clk, input_enable, clr);
    dffe_ref d_flip_flop23(out[23], in[23], clk, input_enable, clr);
    dffe_ref d_flip_flop24(out[24], in[24], clk, input_enable, clr);
    dffe_ref d_flip_flop25(out[25], in[25], clk, input_enable, clr);
    dffe_ref d_flip_flop26(out[26], in[26], clk, input_enable, clr);
    dffe_ref d_flip_flop27(out[27], in[27], clk, input_enable, clr);
    dffe_ref d_flip_flop28(out[28], in[28], clk, input_enable, clr);
    dffe_ref d_flip_flop29(out[29], in[29], clk, input_enable, clr);
    dffe_ref d_flip_flop30(out[30], in[30], clk, input_enable, clr);
    dffe_ref d_flip_flop31(out[31], in[31], clk, input_enable, clr);

endmodule