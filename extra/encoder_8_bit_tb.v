`timescale 1 ns / 100 ps
module encoder_8_bit_tb;
    reg [7:0]inputTotal;
    wire[2:0] out;
    encoder_8_bit encoder(out, inputTotal[0], inputTotal[1], inputTotal[2], inputTotal[3], inputTotal[4], inputTotal[5], inputTotal[6], inputTotal[7]);
    initial
    begin
    inputTotal=8'b11001100; #10;
    inputTotal=8'b01100110; #10;
    inputTotal=8'b00110011; #10;
    inputTotal=8'b00010010; #10;
    inputTotal=8'b00001001; #10;
    inputTotal=8'b00000100; #10;
    inputTotal=8'b00000011; #10;
    inputTotal=8'b00000001; #10;
    inputTotal=8'b00000000; # 10;
    #100;
    end // initial begin

    always @(inputTotal, out) begin
        #1;
        $display("Input: %b, inputDecimal: %d => output:%d", inputTotal, inputTotal, out);
    end
endmodule
