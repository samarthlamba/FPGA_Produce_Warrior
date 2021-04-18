module overflow(ovf, partial, A, B, lower_partial);
    input [31:0] partial;
    input [31:0] A, B, lower_partial;
    output ovf;

    wire negative, finalSign, large_number, answer_zero, ovf_first2, finalSign1, lower_partialMSB, nor_partial, sign_expected, signage, ovf_first, B_not_zero, A_not_zero, ABzero;

    assign lower_partialMSB = lower_partial[31];

    //all 0s
    nor nor_values(nor_partial, partial[0], partial[1], partial[2], partial[3], partial[4],
    partial[5], partial[6], partial[7], partial[8], partial[9], partial[10], partial[11], partial[12], partial[13], partial[14],
    partial[15], partial[16], partial[17], partial[18], partial[19], partial[20], partial[21], partial[22], partial[23], partial[24],
    partial[25], partial[26], partial[27], partial[28], partial[29], partial[30], partial[31], lower_partial[31]);

    nor nor_values1(answer_zero, lower_partial[0], lower_partial[1], lower_partial[2], lower_partial[3], lower_partial[4],
    lower_partial[5], lower_partial[6], lower_partial[7], lower_partial[8], lower_partial[9], lower_partial[10], lower_partial[11], lower_partial[12], lower_partial[13], lower_partial[14],
    lower_partial[15], lower_partial[16], lower_partial[17], lower_partial[18], lower_partial[19], lower_partial[20], lower_partial[21], lower_partial[22], lower_partial[23], lower_partial[24],
    lower_partial[25], lower_partial[26], lower_partial[27], lower_partial[28], lower_partial[29], lower_partial[30], lower_partial[31], partial[0]);

//all 1s
    and negative_values(negative,partial[0], partial[1], partial[2], partial[3], partial[4],
    partial[5], partial[6], partial[7], partial[8], partial[9], partial[10], partial[11], partial[12], partial[13], partial[14],
    partial[15], partial[16], partial[17], partial[18], partial[19], partial[20], partial[21], partial[22], partial[23], partial[24],
    partial[25], partial[26], partial[27], partial[28], partial[29], partial[30], partial[31]);

    xor xor_output(sign_expected, A[31], B[31]);

    
    xnor xnor_output(signage, sign_expected, lower_partial[31]);

    or A_or(A_not_zero, A[1], A[2], A[3], A[4],
    A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14],
    A[15], A[16], A[17], A[18], A[19], A[20], A[21], A[22], A[23], A[24],
    A[25], A[26], A[27], A[28], A[29], A[30], A[31], A[0]);

    or B_or(B_not_zero, B[1], B[2], B[3], B[4],
    B[5], B[6], B[7], B[8], B[9], B[10], B[11], B[12], B[13], B[14],
    B[15], B[16], B[17], B[18], B[19], B[20], B[21], B[22], B[23], B[24],
    B[25], B[26], B[27], B[28], B[29], B[30], B[31], B[0]);
        
    or eitherZero(ABzero, ~B_not_zero, ~A_not_zero); //one of them is a zero of ABzero is true
// 0 0 0
// 0 1 0
// 1 0 1
// 1 1 0
    //and zeroUnexpected(finalsign1, ~ABzero, answer_zero);
    and signageWithZero(finalSign, ~signage, ~ABzero);//neither of them are zero, and expected sign match
    nor nor_final(ovf_first, nor_partial, negative); //negative is 1 if all 0, nor_partial is 1
    //xnor badOverflow(large_number,)
    xor signsMessy(ovf_first2, partial[31], lower_partial[31]);
   // nor potentialOverflow(ovf_first2, nor_partial, negative);
    or (ovf, ovf_first, finalSign,ovf_first2);

endmodule