`timescale 1ns / 1 ps
module display_top(
    input wire refclk, 
    input wire [3:0] ones,
    input wire [3:0] tens,
    input wire [3:0] hundreds,
    output wire [3:0] anodeval,
    output wire [7:0] cathodeval);


wire [1:0] refcounts;
wire [3:0] digit;



refcount refcountsget(.refclk(refclk), .refcounts(refcounts));

anode anodeget(.refcounts(refcounts), .anodeval(anodeval));

BCD BCDget(
    .d1(ones), 
    .d2(tens), 
    .d3(hundreds), 
    .d4(4'd0),
    .refcounts(refcounts),
    .display_d(digit)
);

BCDcathode BCDcathodeget(
    .d(digit),
    .cathodeval(cathodeval)
);
endmodule