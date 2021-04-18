module FD(inst_out_fd, pc_out_fd, input_imem, pc_in, clock, en, reset);
    input [31:0]  input_imem, pc_in;
    input clock, en, reset;
    output [31:0] inst_out_fd, pc_out_fd;

    register_32bits regPC(pc_out_fd, pc_in, clock, en, reset);
    register_32bits regPC2(inst_out_fd, input_imem, clock, en, reset);
    
endmodule