`timescale 1 ns /100 ps
module lfsr_tb;
    reg clk;
reg rst;
reg [7:0] seed;
reg load;
wire total;
wire [7:0] q;
lfsr L(q, clk, rst,
seed, load);

    initial
        begin
            clk = 0;
            load = 0;
            seed = 7'd5;
            rst = 0;
            #10 rst = 1;
            #10 rst = 0;
        end
// drive clock
always
    begin
        #50 clk = !clk;
    end
// program lfsr
initial begin
    #100 seed = 7'd5;
    load = 1;
    #4500 load = 0;

end

    always @(q) begin
    #1;
    $display("Output:%d, %b",q, load);

end
endmodule