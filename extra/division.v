module division(A, B, clk, ctrl_div, data_resultRDY, data_exception, out);

    input [31:0] A, B;
    wire [31:0] dividend, divisor, result, negative_divisor, chosen_divisor, adder_sum, temp_result, comp_result;
    input ctrl_div, clk;
    output [31:0] out;
    output data_exception, data_resultRDY;
    wire AisZero, BisZero, zero, counter_ready, ovf_not_needed, answer_sign, ovf_1;
    wire [5:0] counter;
    wire [64:0] initialOperandA, quotient, AQ, register_input, running_value, register_quotient;

    complement complementedItems(A, B, AisZero, BisZero, dividend, divisor);

    or(zero, AisZero, BisZero);

    assign data_exception = BisZero;
    
    and(counter_ready, ~counter[5], ~counter[0], counter[1], counter[2], counter[3], counter[4]);
    four_bit_flip_flop counter1(counter, 1'b1, clk, 1'b1, ctrl_div);
    assign initialOperandA[64:32] = 33'b0;
    assign initialOperandA[31:0] = dividend;

    assign running_value = ctrl_div ? initialOperandA : register_quotient;
    assign register_input = adder_sum[31]?{1'b1, adder_sum, AQ[32:2],1'b0}: {1'b1, adder_sum, AQ[32:2], 1'b1};

    cla_32_bit_adder adderValue(adder_sum, AQ[64:33], chosen_divisor, ovf_not_needed, ~AQ[64]);
    register_65bits registerRemember(register_quotient, register_input, ~clk, 1'b1, ctrl_div); 
    //64th bit remember's sign
    assign AQ[64:33] = running_value[62:31];
    assign AQ[32:2] = running_value[30:0];
    assign AQ[1:0] = 2'b0;
    assign data_resultRDY = zero ? 1'b1: counter_ready;
    
    
    assign out = zero?{32{1'b0}}: result;

    bitwise_not divsiorNegative(divisor, negative_divisor);

    assign chosen_divisor = AQ[64]?divisor:negative_divisor;

    xor workWithSigns(answer_sign, A[31], B[31]);
    
    bitwise_not comp2(running_value[31:0], temp_result);
    
    cla_32_bit_adder adder1(comp_result, temp_result, 32'b0, ovf_1, 1'b1);

    assign result = answer_sign?comp_result:running_value[31:0];





endmodule
