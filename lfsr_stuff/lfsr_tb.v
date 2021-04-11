`timescale 1 ns /100 ps
module lfsr_tb;
    reg clk;
reg rst;
reg [7:0] seed;
reg load;
wire [7:0] total;
wire q;
lfsr L(q, clk, rst,
seed, load);

    initial
        begin
            clk = 0;
            load = 0;
            seed = 7'b0011;
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
    #100 seed = 4'b0011;
    load = 1;
    #4500 load = 0;

end

    genvar c;
    generate     
    for (c = 0; c < 8; c = c + 1) begin: test
      
    assign total[c] = q;
    end
    endgenerate

    always @(q, load, seed) begin
    #1;
    $display("Output:%b, %b, %d",q, load, total);

end
endmodule