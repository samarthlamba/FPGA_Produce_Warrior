module left_shift_2_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;

    assign output1[0] = 0;
    assign output1[1] = 0;

    assign output1[31:2] = input1[29:0];
    endmodule