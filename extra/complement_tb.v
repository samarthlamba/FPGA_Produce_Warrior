`timescale 1ns/100ps
module complement_tb;

    reg signed [31:0] A, B;
    wire aZero, bZero;
    wire signed [31:0] dividend, divisor;

    complement complement1(A, B, aZero, bZero, dividend, divisor);

    initial begin
    A=32'd2;B=-32'd4; 
    #20 A=-32'd15;B=-32'd15;
    
    #40 A=32'd0;B=32'd8;
    #80 A=32'd100;B=32'd0;
    #160 A=-32'd10;B=32'd3;
    // Set a time delay, in nanoseconds
    #1280;
    $finish;
    end
    
    always @(A, B, aZero, bZero, dividend, divisor) begin
            #1;
            $display("A:%d, B:%d, aZero:%d, bZero:%d, dividend:%d, divisor:%d", A, B, aZero, bZero, dividend, divisor);
        end

    initial begin
         $dumpfile("complement_tb.vcd");

   $dumpvars(0, complement_tb); 
    end
endmodule
