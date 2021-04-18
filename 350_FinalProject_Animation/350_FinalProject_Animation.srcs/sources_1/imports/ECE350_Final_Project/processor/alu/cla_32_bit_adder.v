module cla_32_bit_adder(sum, input1, input2, ovf, cin);
    input [31:0] input1;
    input [31:0] input2;
    input cin;
    output [31:0] sum;
    output ovf;

    wire [3:0] wireG, wireP;
    wire w0, w1, w2, w3, w4, w5, w6, c8, c16, c24, c32;

    cla_8_bit_adder block0_calc(sum[7:0], wireP[0], wireG[0], input1[7:0], input2[7:0], cin);
    and bigP_c0(w0, wireP[0], cin);
    or c_8(c8, wireG[0], w0);

    cla_8_bit_adder block1_calc(sum[15:8], wireP[1], wireG[1], input1[15:8], input2[15:8], c8);
    and bigP_c1(w1, wireP[1], c8);
    or c_16(c16, wireG[1], w1);

    cla_8_bit_adder block2_calc(sum[23:16], wireP[2], wireG[2], input1[23:16], input2[23:16], c16);
    and bigP_c2(w2, wireP[2], c16);
    or c_24(c24, wireG[2], w2);

    cla_8_bit_adder block3_calc(sum[31:24], wireP[3], wireG[3], input1[31:24], input2[31:24], c24);
    and bigP_c3(w3, wireP[3], c24);
    or c_32(c32, wireG[3], w3);


    xnor xnor1(w4, input1[31], input2[31]);
    xnor xnor2(w5, input1[31], sum[31]);

    not overflow(w6, w5);

    and finalOverflow(ovf, w4, w6);
    endmodule



