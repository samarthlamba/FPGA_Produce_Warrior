/* module multiplication_tb;
   reg clk;
   reg e, clr, multiplicand, multiplier, clk, ctrl_mult, data_resultRDY, out;
   wire [3:0] out;

   four_bit_flip_flop multiplication ( multiplicand, multiplier, clk, ctrl_mult, data_resultRDY, out);

   always #5 clk = ~clk;

   initial begin
      e = 1'b1;
      clr <= 1;
      clk <= 0;
      #10;
      clr <= 0;
      #10;
      repeat (16) begin
         $display("count = :%b", out);
          #10;
      end

      //repeat (25) @ (posedge clk);
      $finish;
   end
endmodule */