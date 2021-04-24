module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
    wire MSB_not; 
    wire add_overflow, sub_overflow, over_flow_results;
    wire [31:0] MSB_not_intermediate, intermediate_subtraction,sub_result, or_result, add_result, sll_result, and_result, sra_result, blank_wire;

    // add your code here:

    
    cla_32_bit_adder adder(add_result, data_operandA, data_operandB, add_overflow, 1'b0); 

     bitwise_or orfunction(data_operandA, data_operandB, or_result); 


    bitwise_not notfunctionB(data_operandB,intermediate_subtraction);
    cla_32_bit_adder finaladd(sub_result,data_operandA, intermediate_subtraction, sub_overflow, 1'b1);

    bitwise_and andfunc(data_operandA, data_operandB, and_result);
    sll notfunction2(data_operandA, ctrl_shiftamt, sll_result);
    sra notfunction3(data_operandA, ctrl_shiftamt, sra_result);

    mux_32_one mux_opcode_chooser(ctrl_ALUopcode, add_result, sub_result, and_result, or_result, sll_result, sra_result,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire, blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire,blank_wire, data_result);
    bitwise_not notfunction1(data_result, MSB_not_intermediate);
    assign MSB_not = MSB_not_intermediate[31];
    mux_two_one_1bit overflowChooser(ctrl_ALUopcode[0], add_overflow, sub_overflow, overflow);
    assign isLessThan = overflow ? MSB_not : data_result[31];
    or checkEqual(isNotEqual, data_result[0], data_result[1], data_result[2], data_result[3], data_result[4], data_result[5], data_result[6], data_result[7], data_result[8], data_result[9], data_result[10], data_result[11], data_result[12], data_result[13], data_result[14], data_result[15], data_result[16], data_result[17], data_result[18], data_result[19], data_result[20], data_result[21], data_result[22], data_result[23], data_result[24], data_result[25], data_result[26], data_result[27], data_result[28], data_result[29], data_result[30], data_result[31]);
endmodule