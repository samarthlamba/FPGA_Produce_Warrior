module DX(inst_out_dx, pc_out_dx, A_out_dx, B_out_dx, inst_in_dx, pc_in, A_in_dx, B_in_dx, clock, en, reset);
    input [31:0] inst_in_dx, pc_in, A_in_dx, B_in_dx;
    input clock, en, reset;
    output [31:0] inst_out_dx, pc_out_dx, A_out_dx, B_out_dx;
    

    register_32bits regPC(inst_out_dx, inst_in_dx, clock, en, reset);
    register_32bits regPC2(pc_out_dx, pc_in, clock, en, reset);
    register_32bits regPC3(A_out_dx, A_in_dx, clock, en, reset);
    register_32bits regPC4(B_out_dx, B_in_dx, clock, en, reset);
    
endmodule