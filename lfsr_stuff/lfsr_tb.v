`timescale 1 ns /100 ps
module lfsr_tb;
    reg clk;
    reg clr;
    reg [7:0] seed;
    reg select, reset;
    wire [3:0] out;

    lfsr check(out, clk, reset);
   initial
begin
    clk = 0;
    reset = 1;
    #15;
    
    reset = 0;
    #200;
end

    always 
        #30 clk = ~clk;
    

    always @(out) begin
    #1;
    $display("Output:%d",out);

end
endmodule