module sra(input1, ctrl_shiftamt, output1);
    input [31:0] input1;
    input [4:0] ctrl_shiftamt;
    output [31:0] output1;
    wire [31:0] mux_16, mux_8, mux_4, mux_2, mux_1, calc_shift_after_16, calc_shift_after_8, calc_shift_after_4,calc_shift_1, calc_shift_2;

    right_shift_16_bits shift1(input1, calc_shift_after_16);
    right_shift_8_bits shift2(mux_16, calc_shift_after_8); 
    right_shift_4_bits shift3(mux_8, calc_shift_after_4);
    right_shift_2_bits shift4(mux_4, calc_shift_2);
    right_shift_1_bits shift5(mux_2, calc_shift_1);

    assign mux_16 = ctrl_shiftamt[4] ? calc_shift_after_16 : input1;
    assign mux_8 = ctrl_shiftamt[3] ? calc_shift_after_8 : mux_16;
    assign mux_4 = ctrl_shiftamt[2] ? calc_shift_after_4: mux_8;
    assign mux_2 = ctrl_shiftamt[1] ? calc_shift_2: mux_4;
    assign mux_1 = ctrl_shiftamt[0] ? calc_shift_1: mux_2;

    assign output1 = mux_1;
    endmodule