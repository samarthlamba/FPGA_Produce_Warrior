module anode(input [1:0] refcounts, output reg [3:0] anodeval = 0);

always @(refcounts)
begin
    case(refcounts)
        2'b00:
            anodeval = 4'b1110;
        2'b01:
            anodeval = 4'b1101;
        2'b10:
            anodeval = 4'b1011;
        2'b11:
            anodeval = 4'b0111;
    endcase
end

endmodule