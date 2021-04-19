`timescale 1ns / 1ps
module clock_div(clk, clkout);

reg clk50 = 0;
reg counter50Mh = 0;
wire counterLimit;
assign counterLimit =1'b1;

always @(posedge clck) begin
  if(counter50Mh < counterLimit) begin
          counter50Mh <= counter50Mh +1;
  end
  else begin
      counter50Mh <= 0;
      clk50 <= ~clk50;
  end
end
  assign clkout = clk50;

endmodule