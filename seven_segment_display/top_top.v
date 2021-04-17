`timescale 1 ns / 1ps
module top_top(input wire clk, input wire switch, output wire [3:0] anodeval, output wire [7:0] cathodeval);

    wire refclk;
    wire counter_clk;
    wire [7:0] eightbitbin;
    wire [3:0] ones, tens, hundreds;

    clk_divider #(4999) refclkget(clk, refclk);
    clk_divider #(4999999) countclkget(clk, counter_clk);
    counter getcount(counter_clk, switch, eightbitbin);
    binary_BCD binbcdconvert(clk, eightbitbin, ones, tens, hundreds);
    display_top sevenseg(refclk, ones, tens, hundreds, anodeval, cathodeval);
endmodule