`timescale 1 ns /100 ps
module lfsr_tb;
    reg clk;
    reg clr;
    reg [7:0] seed;
    reg select;
    wire out;

    lfsr check(out, clk, clr, seed, select);

    initial
        begin
            clk = 0;
            select = 0;
            seed = 0;
            clr = 0;
            #10 clr = 1;
            #10 clr = 0;
        end
    always 
        #30 clk = !clk;
    
    initial begin
        #50 seed = 8'b00000001;
             select = 1;
        #50 select = 0;
    end
endmodule