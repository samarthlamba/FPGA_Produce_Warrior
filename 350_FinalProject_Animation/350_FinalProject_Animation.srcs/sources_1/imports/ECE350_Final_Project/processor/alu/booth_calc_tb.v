`timescale 1ns/100ps
module booth_calc_tb;

    reg [31:0] product;
    reg [31:0] multiplicand;
    wire [64:0] out;
    wire [31:0] negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted;


    booth_calc test(product, multiplicand, negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted);


    initial begin
    product=32'd99;multiplicand=32'd99; 
    #20 product=32'd124;multiplicand=32'd119;
    
    #40 product=32'd6;multiplicand=32'd89;
    #80 product=32'd54;multiplicand=32'd31;
    #160 product=32'd91;multiplicand=32'd30;
    #320 product=32'd11;multiplicand=32'd12;
    #640 product=32'd18;multiplicand=32'd12;
    // Set a time delay, in nanoseconds
    #1280;
    $finish;
    end
    
    always @(product, multiplicand, negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted) begin
            #1;
            $display("product:%d, multiplicand:%d, negative_multiplicand:%d, negative_multiplicand_shifted_1:%d, multiplicand_adder:%d, multiplicand_adder_shifted:%d", product, multiplicand, negative_multiplicand, negative_multiplicand_shifted_1, multiplicand_adder, multiplicand_adder_shifted);
        end

    initial begin
         $dumpfile("Wave_booth_calc_tb.vcd");

   $dumpvars(0, booth_calc_tb); 
    end
endmodule
