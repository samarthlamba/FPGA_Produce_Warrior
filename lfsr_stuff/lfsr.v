module lfsr(out, clk, clr, seed, select);
    input [7:0] seed;
    input select;
    input clr, clk;
    
    output out;

// we used : http://rdsl.csit-sun.pub.ro/docs/PROIECTARE%20cu%20FPGA%20CURS/lecture6[1].pdf as a template to develop this module

    wire [7:0] ffout;
    wire [7:0] ffin;
    wire num_one;
    wire num_two;
    wire num_out;
    
    dffe_ref ff[7:0] (ffout, ffin, clk, 1'b1, clr);
    mux_2_1 mux[7:0] (ffin, select, seed, {ffout[6], ffout[5], ffout[4], ffout[3], ffout[2], ffout[1], ffout[0], num_out});

    xor n1(num_one, ffout[7], ffout[5]);
    xor n2(num_two, ffout[4], num_one);
    xor n3(num_out, ffout[3], num_two);

    assign out = num_out;

endmodule