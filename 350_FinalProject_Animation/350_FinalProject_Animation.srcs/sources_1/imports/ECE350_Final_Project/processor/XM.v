module XM(inst_out_xm, B_out_xm, o_out_xm, inst_in_xm, B_in_xm, o_in_xm, clock, en, reset);
    input [31:0] B_in_xm, o_in_xm, inst_in_xm;
    input clock, en, reset;
    output [31:0] inst_out_xm, B_out_xm, o_out_xm;

    register_32bits regPC1(inst_out_xm, inst_in_xm, clock, en, reset);
    register_32bits regPC2(B_out_xm, B_in_xm, clock, en, reset);
    register_32bits regPC3(o_out_xm, o_in_xm, clock, en, reset);
    
endmodule