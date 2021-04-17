`timescale 1ns / 1ps

module BCD(
    input [3:0] d1, 
    input [3:0] d2, 
    input [3:0] d3, 
    input [3:0] d4, 
    input [1:0] refcounts,
    output reg [3:0] display_d = 0
);

always @(refcounts)
begin
    case(refcounts)
        2'd0:
            display_d = d1;
        2'd1:
            display_d = d2;
        2'd2:
            display_d = d3;
        2'd3:
            display_d = d4;
    endcase
end
endmodule