module right_shift_8_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;

    assign output1[31] = input1[31];
    assign output1[30] = input1[31];
    assign output1[29] = input1[31];
    assign output1[28] = input1[31];
    assign output1[27] = input1[31];
    assign output1[26] = input1[31];
    assign output1[25] = input1[31];
    assign output1[24] = input1[31];
    assign output1[23:0] = input1[31:8];
    endmodule