module t_flip_flop (q, t, clk, en, clr);

    input t, clk, en, clr;
    output q;

    wire w1, w2, w3, not_t, intermediate_q, not_intermediate_q;


    not notT(not_t, t);
    and andTop(w1, not_t, intermediate_q);
    and andBottom(w2, t, not_intermediate_q);
    or orMiddle(w3, w2, w1);

    dffe_ref dffeCalculator(intermediate_q, w3, ~clk, en, clr);


    //q and not q
    not(not_intermediate_q, intermediate_q);
    assign q = intermediate_q;

endmodule