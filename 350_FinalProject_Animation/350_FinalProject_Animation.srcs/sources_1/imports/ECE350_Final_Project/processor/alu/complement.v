module complement(A, B, aZero, bZero, dividend, divisor);

    input [31:0] A, B;
    output aZero, bZero;
    output [31:0] dividend, divisor;

    wire [31:0] not_dividend, not_divisor,complementedDivisor, complementedDividend;
    wire ovf_1, ovf2, B_not_zero, A_not_zero;

    bitwise_not comp1(A, not_dividend);
    bitwise_not comp2(B, not_divisor);

    cla_32_bit_adder adder1(complementedDividend, not_dividend, 32'b0, ovf_1, 1'b1);
    cla_32_bit_adder adder2(complementedDivisor, not_divisor, 32'b0, ovf_1, 1'b1);


    assign dividend = A[31]? complementedDividend:A;
    assign divisor = B[31]? complementedDivisor:B;

    or A_or(A_not_zero, A[1], A[2], A[3], A[4],
    A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14],
    A[15], A[16], A[17], A[18], A[19], A[20], A[21], A[22], A[23], A[24],
    A[25], A[26], A[27], A[28], A[29], A[30], A[31], A[0]);

    or B_or(B_not_zero, B[1], B[2], B[3], B[4],
    B[5], B[6], B[7], B[8], B[9], B[10], B[11], B[12], B[13], B[14],
    B[15], B[16], B[17], B[18], B[19], B[20], B[21], B[22], B[23], B[24],
    B[25], B[26], B[27], B[28], B[29], B[30], B[31], B[0]);

    not(aZero, A_not_zero);
    not(bZero, B_not_zero);
    


endmodule
