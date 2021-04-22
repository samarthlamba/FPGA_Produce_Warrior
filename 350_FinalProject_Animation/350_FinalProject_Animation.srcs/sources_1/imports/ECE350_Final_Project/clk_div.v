module clk_div(clk, clkout);
input clk;
output clkout;

localparam MHz = 1000000;
localparam SYSTEM_FREQ = 100*MHz;
reg clk50 = 0;
reg counter50Mh = 0;
wire[31:0] counterLimit;
assign counterLimit = (SYSTEM_FREQ / 2*(99*MHz)) - 1;

always @(posedge clk) begin
  if(counter50Mh < counterLimit)
          counter50Mh <= counter50Mh +1;
  else begin
      counter50Mh <= 0;
      clk50 <= ~clk50;
  end
end

assign clkout = clk50;

endmodule
