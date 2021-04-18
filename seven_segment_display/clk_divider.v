`timescale 1ns / 1ps
//https://www.youtube.com/watch?v=iei1EugtQvQ
module clk_divider #(parameter divby = 4999) (input wire clk, output reg div_clk = 0);


integer count = 0;
//clk div value = 100 MHz // (2*desired freq) - 1

always @(posedge clk) begin
    if(count == divby)
        count <= 0;
        div_clk <= ~div_clk;
    else
        count <= count + 1;
        div_clk <= div_clk;
end

// always @(posedge clk)begin
//     if(count == 1000)
//         div_clk <= ~div_clk;
//     else
//         div_clk <= div_clk;
// end



endmodule