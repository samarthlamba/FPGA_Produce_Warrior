module left_shift_4_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;

    assign output1[3] = 0;
    assign output1[2] = 0;
    assign output1[1] = 0;
    assign output1[0] = 0;

    assign output1[31:4] = input1[27:0];
    endmodule