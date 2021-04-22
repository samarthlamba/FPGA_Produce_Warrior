module clk_div(clk, clkout);
input clk;
output clkout;

reg clk50 = 0;
reg counter50Mh = 0;
wire counterLimit;
assign counterLimit = 1'b1;

always @(posedge clock) begin
  if(counter50Mh < counterLimit)
          counter50Mh <= counter50Mh +1;
  else begin
      counter50Mh <= 0;
      clk50 <= ~clk50;
  end
end

assign clkout = clk50;

endmodule
