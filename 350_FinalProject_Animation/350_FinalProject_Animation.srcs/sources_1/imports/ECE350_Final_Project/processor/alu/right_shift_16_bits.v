module right_shift_16_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;
    wire temp;

    assign output1[31] = input1[31];
    assign output1[30] = input1[31];
    assign output1[29] = input1[31];
    assign output1[28] = input1[31];
    assign output1[27] = input1[31];
    assign output1[26] = input1[31];
    assign output1[25] = input1[31];
    assign output1[24] = input1[31];
    assign output1[23] = input1[31];
    assign output1[22] = input1[31];
    assign output1[21] = input1[31];
    assign output1[20] = input1[31];
    assign output1[19] = input1[31];
    assign output1[18] = input1[31];
    assign output1[17] = input1[31];
    assign output1[16] = input1[31];
    assign output1[15:0] = input1[31:16];

    endmodule