module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;
    wire data_resultRDY_div, operationHappening, data_resultRDY_mult, data_resultRDY_mul, data_exception_div, data_exception_mult, operation;
    wire [31:0] data_result_mul, data_result_div;
    output [31:0] data_result;
    output data_exception, data_resultRDY;

    or operationCheck(operationHappening, ctrl_MULT, ctrl_DIV);
    srLatch operationStarted(operation, ctrl_MULT, ctrl_DIV, operationHappening);

    assign data_result = operation?data_result_mul:data_result_div;
    assign data_exception = operation?data_exception_mult: data_exception_div;
    assign data_resultRDY = operation?data_resultRDY_mult : data_resultRDY_div;
    division div(data_operandA, data_operandB, clock, ctrl_DIV, data_resultRDY_div, data_exception_div, data_result_div);
    multiplication mult(data_operandA, data_operandB, clock, ctrl_MULT, data_resultRDY_mult, data_exception_mult, data_result_mul);

endmodule