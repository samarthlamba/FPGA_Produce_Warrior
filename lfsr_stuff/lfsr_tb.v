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
            seed = 7'd3;
            rst = 0;
            
    #100 load = 1;
    #4500 load = 0;
        end
// drive clock
always
    begin
        #50 clk = !clk;
    end
// program lfsr

    always @(q) begin
    #1;
    $display("Output:%d, %b",q, load);

end
 initial begin
        // Output file name 
        $dumpfile("lfsr.vcd");
        //Module to capture and what level, 0 means all wires
        $dumpvars(0, lfsr_tb);
    end
endmodule