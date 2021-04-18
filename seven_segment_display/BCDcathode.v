module BCDcathode(
    input [3:0] d,
    output reg [7:0] cathodeval = 0
);

always @(d)
begin
    case(d)
        4'd0:
            cathodeval = 8'b11000000;
        4'd1:
            cathodeval = 8'b11111001;
        4'd2:
            cathodeval = 8'b10100100;
        4'd3:
            cathodeval = 8'b10110000;
        4'd4:
            cathodeval = 8'b10011001;
        4'd5:
            cathodeval = 8'b10010010;
        4'd6:
            cathodeval = 8'b10000010;
        4'd7:
            cathodeval = 8'b11111000;
        4'd8:
            cathodeval = 8'b10000000;
        4'd9:
            cathodeval = 8'b10010000;
        default:
            cathodeval = 8'b11000000;
    endcase
end
endmodule