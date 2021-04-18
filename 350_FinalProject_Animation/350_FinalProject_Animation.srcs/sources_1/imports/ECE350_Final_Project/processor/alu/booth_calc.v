module booth_calc(product, multiplicand, negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted);

    input [31:0] multiplicand;
    input [31:0] product;
    output [31:0] negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted;
    wire [31:0] multiplicand_shifted_1;
    wire [31:0] temp_negative_multiplicand_shifted_1, temp_negative_multiplicand;
    wire ovf_negative_mulitplicand1, ovf_negative_mulitplicand2, ovf_postive_multiplicand1, ovf_positive_multiplcand2;
        
    assign multiplicand_shifted_1 = multiplicand << 1;

    //calculate values after subtracting mulitplicand
    assign temp_negative_multiplicand = ~multiplicand;
    assign temp_negative_multiplicand_shifted_1= ~multiplicand_shifted_1;
    cla_32_bit_adder negativeMultiplicand(negative_multiplicand, temp_negative_multiplicand, product, ovf_negative_mulitplicand1, 1'b1);
    cla_32_bit_adder negativeMultiplicand2(negative_multiplicand_shifted_1, temp_negative_multiplicand_shifted_1, product, ovf_negative_mulitplicand2, 1'b1);
    
    //calculate values after adding multiplicand
    cla_32_bit_adder adderMultiplicand(multiplicand_adder, multiplicand, product, ovf_postive_multiplicand1, 1'b0);
    cla_32_bit_adder adderMultiplicandShifted(multiplicand_adder_shifted, multiplicand_shifted_1, product, ovf_positive_multiplcand2, 1'b0);

endmodule