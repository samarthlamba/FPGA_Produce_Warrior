module multiplication(multiplicand, multiplier, clk, ctrl_mult, data_resultRDY, data_exception, out);
    input clk;
    input ctrl_mult;
    input [31:0] multiplier, multiplicand;
    output[31:0] out;
    output data_resultRDY, data_exception;

    wire [64:0] initial_product, product, running_value, register_product;
    wire [5:0] counter1;
    wire [5:0] counter; 
    wire [3:0] select; 
    wire mult_ready, counterNotEnded;
    wire ovf_negative_mulitplicand1, ovf_negative_mulitplicand2, counterStarted, counterEnded;



    

    four_bit_flip_flop counter4bit(counter1, 1'b1, ~clk, 1'b1, ctrl_mult);
    assign counter = counter1[4:0];
    and(counterNotEnded, counter[0], ~counter[1], ~counter[2], ~counter[3], counter[4]);
    assign initial_product = {32'b0, multiplier, 1'b0};


    
    assign running_value = ctrl_mult ? initial_product : product;

    register_65bits registerRemember(register_product, running_value, clk, 1'b1, ctrl_mult); 

    booth boothFinalCalc(register_product, multiplicand, product);

    assign out = ctrl_mult? 32'b0:register_product [32:1];
    assign data_resultRDY = counterNotEnded;

    //mux_eight_one mux_ouput(temp_out, select, )

    overflow overflow_final(data_exception, register_product[64:33], multiplicand, multiplier, register_product [32:1]);

    //check if at beginining set the registers

endmodule