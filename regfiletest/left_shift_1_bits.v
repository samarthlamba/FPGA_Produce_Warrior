module left_shift_1_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;

    assign output1[0] = 0;

    assign output1[31:1] = input1[30:0];
endmodule