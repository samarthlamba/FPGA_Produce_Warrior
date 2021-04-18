module right_shift_2_bits (input1, output1);
    input [31:0] input1;
    output [31:0] output1;

    assign output1[31] = input1[31];
    assign output1[30] = input1[31];


    assign output1[29:0] = input1[31:2];
    endmodule