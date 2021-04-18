module MW(inst_out_mw, d_out_mw, o_out_mw, inst_in_mw, d_in_mw, o_in_mw, clock, en, reset);
    input [31:0] inst_in_mw, d_in_mw, o_in_mw;
    input clock, en, reset;
    output [31:0] inst_out_mw, d_out_mw, o_out_mw;

    register_32bits regPC(inst_out_mw, inst_in_mw, clock, en, reset);
    register_32bits regPC2(d_out_mw, d_in_mw, clock, en, reset);
    register_32bits regPC3(o_out_mw, o_in_mw, clock, en, reset);
    
endmodule