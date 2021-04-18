`timescale 1ns / 1 ps

module counter(
    input wire counter_clk,
    input wire switch,
    output reg [7:0] count = 0
);

    always @(posedge counter_clk) begin
        if (switch == 0) begin
            count <= count;
        end
        if (switch == 1) begin
            count <= count + 1;
        end
    end


endmodule
