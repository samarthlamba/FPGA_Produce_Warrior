module lfsr(out, clk, clr, seed, select);
    input [7:0] seed;
    input select;
    input clr, clk;
    
    output[7:0] out;

// we used : http://rdsl.csit-sun.pub.ro/docs/PROIECTARE%20cu%20FPGA%20CURS/lecture6[1].pdf as a template to develop this module

    wire [7:0] ffout;
    wire [7:0] ffin;
    wire num_one;
    wire num_two;
    wire num_out;
    
    dffe_ref dffe(ffout[0], ffin[0], clk, 1'b1, clr);
    dffe_ref dffe2(ffout[1], ffin[1], clk, 1'b1, clr);
    dffe_ref dffe3(ffout[2], ffin[2], clk, 1'b1, clr);
    dffe_ref dffe4(ffout[3], ffin[3], clk, 1'b1, clr);
    dffe_ref dffe5(ffout[4], ffin[4], clk, 1'b1, clr);
    dffe_ref dffe6(ffout[5], ffin[5], clk, 1'b1, clr);
    dffe_ref dffe7(ffout[6], ffin[6], clk, 1'b1, clr);
    dffe_ref dffe8(ffout[7], ffin[7], clk, 1'b1, clr);

    mux_2_1 mux1(ffin[0], select, seed[0], num_out);
    mux_2_1 mux2(ffin[1], select, seed[1], ffout[0]);
    mux_2_1 mux3(ffin[2], select, seed[2], ffout[1]);
    mux_2_1 mux4(ffin[3], select, seed[3], ffout[2]);
    mux_2_1 mux5(ffin[4], select, seed[4], ffout[3]);
    mux_2_1 mux6(ffin[5], select, seed[5], ffout[4]);
    mux_2_1 mux7(ffin[6], select, seed[6], ffout[5]);
    mux_2_1 mux8(ffin[7], select, seed[7], num_out);


    xor n2(num_one, ffout[5], ffout[7]);
    xor n3(num_two,num_one, ffout[4]);
    xor n4(num_out,num_two, ffout[3]);

    assign out = ffout;

endmodule