module register_32bits(out, in, clk, input_enable, clr);

    input[31:0] in;
    input clk;
    input input_enable;
    input clr;
    output[31:0] out;

    genvar i;
    generate
        for(i = 0; i <= 31; i = i + 1) begin: loop1
            dffe_ref reg_0(out[i], in[i], clk, input_enable[i], clr);
        end 
    endgenerate

endmodule