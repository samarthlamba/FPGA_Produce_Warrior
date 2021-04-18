module encoder(highestOutput, lowestOutput, input1, input2, input3, input4);
    output lowestOutput, highestOutput;
    input input1, input2, input3, input4;

    wire notInput3;
    wire and_input3_1;


    not notGate(notInput3, input3);
    and andGate(and_input3_1, notInput3, input2);
    or orGate1(highestOutput, input4, input3);
    or orGate2(lowestOutput, and_input3_1, input4);
    //https://www.google.com/search?q=priprity+encoderverilog&tbm=isch&ved=2ahUKEwjukqTxl8TvAhUNKlMKHcg1Ap8Q2-cCegQIABAA&oq=priprity+encoderverilog&gs_lcp=CgNpbWcQA1CfCFi6DmC7D2gAcAB4AIABRIgBqgOSAQE3mAEAoAEBqgELZ3dzLXdpei1pbWfAAQE&sclient=img&ei=17NYYK7LFo3UzALI64j4CQ&bih=969&biw=1920&rlz=1C1CHBF_enUS916US917&safe=active#imgrc=t7JqCPze7qTOwM
endmodule
