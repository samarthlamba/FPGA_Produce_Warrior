module decoder(input_enable, select, out);
    input input_enable;
    input [4:0] select;
    output [31:0] out; 
    wire [31:0] pre_shift;

    assign pre_shift[0] = input_enable;
    assign pre_shift[31:1] = {31{1'b0}};


    sll shift1(pre_shift, select, out);

endmodule


