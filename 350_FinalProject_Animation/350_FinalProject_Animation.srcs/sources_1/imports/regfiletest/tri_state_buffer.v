module tri_state_buffer(in, output_enable, out);
    input [31:0] in;
    input output_enable;
    output [31:0] out;

    assign out = output_enable ? in : {32{1'bz}};

endmodule