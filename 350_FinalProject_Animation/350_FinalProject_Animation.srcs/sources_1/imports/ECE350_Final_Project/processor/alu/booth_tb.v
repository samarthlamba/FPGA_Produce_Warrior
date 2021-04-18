`timescale 1ns/100ps
module booth_tb;

    reg [64:0] product;
    reg [31:0] multiplicand;
    wire [64:0] out;


    booth test(product, multiplicand, out);


    initial begin
    product=65'd99;multiplicand=32'd99; 
    #20 product=65'd124;multiplicand=32'd119;
    
    #40 product=65'd6;multiplicand=32'd89;
    #80 product=65'd54;multiplicand=32'd31;
    #160 product=65'd91;multiplicand=32'd30;
    #320 product=65'd11;multiplicand=32'd12;
    #640 product=65'd18;multiplicand=32'd12;
    // Set a time delay, in nanoseconds
    #1280;
    $finish;
    end
    
    always @(product,multiplicand, out) begin
            #1;
            $display("product:%b, multiplicand:%d, select:%b, top_out:%d, bottom_out:%b", product, multiplicand, product[2:0], out[64:33], out[32:0]);
        end

    initial begin
         $dumpfile("Wave_booth_tb.vcd");

   $dumpvars(0, booth_tb); 
    end
endmodule
