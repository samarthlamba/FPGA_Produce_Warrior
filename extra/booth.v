module booth(product, multiplicand, out);

    input [31:0] multiplicand;
    input [64:0] product;
    wire [31:0] new_product;
    wire [31:0] negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted;
    output [64:0] out;
    wire [64:0] out_pre_shift;
    wire [2:0] bottom_bits;
    
    
    assign bottom_bits = product[2:0];
    booth_calc values(product[64:33], multiplicand, negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted);

    mux_eight_one mutex(new_product, bottom_bits, product[64:33], multiplicand_adder, multiplicand_adder, multiplicand_adder_shifted, negative_multiplicand_shifted_1, negative_multiplicand, negative_multiplicand, product[64:33]);

    assign out_pre_shift[64:33] = new_product;
    assign out_pre_shift[32:0] = product[32:0];
    assign out[64] = out_pre_shift[64];
     assign out[63] = out_pre_shift[64];
    assign out[62:0] = out_pre_shift[64:2];
endmodule
