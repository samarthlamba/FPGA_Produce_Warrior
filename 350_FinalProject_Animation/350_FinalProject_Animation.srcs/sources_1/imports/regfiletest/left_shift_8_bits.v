module left_shift_8_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;

    assign output1[0] = 0;
    assign output1[1] = 0;
    assign output1[2] = 0;
    assign output1[3] = 0;
    assign output1[4] = 0;
    assign output1[5] = 0;
    assign output1[6] = 0;
    assign output1[7] = 0;
    assign output1[31:8] = input1[23:0];
    endmodule