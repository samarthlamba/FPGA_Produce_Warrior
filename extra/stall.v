module stall(isMultDiv, isStall, data_exception_mult, data_exception_div, FD_instr_out_original, FD_instr_in_original, data_operandA, data_operandB, data_result_multiplication, clock);
    output isMultDiv, isStall, data_exception_mult, data_exception_div;
    output [31:0] data_result_multiplication;
    input [31:0] FD_instr_out_original, FD_instr_in_original, data_operandA, data_operandB;
    input clock;

wire isMultiplication, isDivision, isMultiplicationOrDivision, multCtrl, divCtrl, data_exception;
    wire [31:0] DX_instr_out, FD_instr_out, data_result_multiplication;
    wire operation, mult_signal, div_signal, data_resultRDY;


    register_32bits FD_instrRegister(FD_instr_out, FD_instr_out_original, clock, isMultiplicationOrDivision, 1'b0);
    assign isStall = isMultiplicationOrDivision && ~data_resultRDY; //(FD_instr_out[26:22] == FD_instr_in_original[26:22] || data_resultRDY) && 

    //need memory cycle

    //not clock cycle
    assign isMultiplication = FD_instr_out_original[31:27] == 5'd0 && (FD_instr_out_original[6:2] == 5'b00110);
    assign isDivision =  FD_instr_out_original[31:27] == 5'd0 &&  FD_instr_out_original[6:2] == 5'b00111;
    assign isMultiplicationOrDivision = isMultiplication || isDivision;
    assign isMultDiv = isMultiplicationOrDivision;
    dffe_ref ctrl(mult_signal, isMultiplication && ~data_resultRDY, ~clock, isMultiplication, isDivision);
    dffe_ref ctrl1(div_signal, isDivision && ~data_resultRDY, ~clock, isDivision, isMultiplication);

    multdiv multiplicationDivision(data_operandA, data_operandB, ~mult_signal  && isMultiplication, ~div_signal && isDivision, clock, data_result_multiplication, data_exception, data_resultRDY);
    assign data_exception_div = data_exception && isDivision;
    assign data_exception_mult = data_exception && isMultiplication;
    

   //fast jumping/fast branching. 
endmodule