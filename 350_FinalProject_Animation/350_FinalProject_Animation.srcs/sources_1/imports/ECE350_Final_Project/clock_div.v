
module clock_div(clk, clkout);
input clk;
output clkout;

reg clockdiv;
reg[27:0] counter = 28'd0;
parameter DIVIDEBY = 28'd50000000;
//reg clk50 = 0;
//reg counter50Mh = 0;
//wire counterLimit;
//assign counterLimit =1'b1;

always @(posedge clk) begin
    counter <= counter + 28'd1;
  if(counter >= (DIVIDEBY -1)) 
        counter <= 28'd0;
        clockdiv <= (counter < DIVIDEBY/2)? 1'b1:1'b0;
  end
  assign clkout = clockdiv;
endmodule