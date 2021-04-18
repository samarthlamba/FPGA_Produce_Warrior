module four_bit_flip_flop (q, t, clk, en, clr);
//4 bit coutner
    input t, clk, en, clr;
    output [5:0] q;

    wire one, t1, t2, t3, t2_5, t3_5, t4_5, t5_5;
    wire [5:0] intermediate_q;

    //assign one = 1'b1;


    t_flip_flop t_flipFlop1(intermediate_q[0], t, clk, en, clr);

    t_flip_flop t_flipFlop2(intermediate_q[1], intermediate_q[0], clk, en, clr);

    and andFirstTwoFlipFLop(t2_5, intermediate_q[1], intermediate_q[0]);

    t_flip_flop t_flipFlop3(intermediate_q[2], t2_5, clk, en, clr);

    and (t3_5, t2_5, intermediate_q[2]);
    
    t_flip_flop t_flipFlop4(intermediate_q[3], t3_5, clk, en, clr);

    and (t4_5, t3_5, intermediate_q[3]);

    t_flip_flop t_flipFlop5(intermediate_q[4], t4_5, clk, en, clr);

     and (t5_5, t4_5, intermediate_q[4]);

    t_flip_flop t_flipFlop6(intermediate_q[5], t5_5, clk, en, clr);

    assign q = intermediate_q;
    
//https://electronics.stackexchange.com/questions/99485/d-flip-flops-but-no-feedback-loops-impossible

endmodule