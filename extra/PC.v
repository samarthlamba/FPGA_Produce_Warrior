module PC(out, in, clock, en, reset);

    input [31:0] in;
    input clock, en, reset;
    output [31:0] out;

    register_32bits regPC(out, in, clock, en, reset);
    
endmodule