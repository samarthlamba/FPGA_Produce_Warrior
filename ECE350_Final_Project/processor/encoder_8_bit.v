module encoder_8_bit(out, input0, input1, input2, input3, input4, input5, input6, input7);
    output [2:0] out;
    input input0, input1, input2, input3, input4, input5, input6, input7;

    assign out[0] = (~input6 && (~input4 && ~input2 && input1 || ~input4 && input3 || input5) || input7);
    assign out[1] = (~input5 && ~input4 && (input2 || input3) || input6 || input7);
    assign out[2] = input4 || input5 || input6 || input7;
    //https://www.electronics-tutorials.ws/combination/comb_4.html
endmodule
