module left_shift_16_bits (input1, output1);
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
    assign output1[8] = 0;
    assign output1[9] = 0;
    assign output1[10] = 0;
    assign output1[11] = 0;
    assign output1[12] = 0;
    assign output1[13] = 0;
    assign output1[14] = 0;
    assign output1[15] = 0;
    assign output1[31:16]= input1[15:0];
    endmodule