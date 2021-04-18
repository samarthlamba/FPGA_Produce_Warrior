`timescale 1 ns /100 ps
module imagecollision_tb;
    reg[9:0] x = 10'd50;
    reg[8:0] y = 9'd50;
    reg[9:0] size = 10'd50;
    reg[9:0] x2;
    reg[8:0] y2;
    wire collision;
    
    imagecollision test(x, y, x2, y2, size, collision);

    initial begin
    x2 = 10'd49; y2 = 10'd80;
    #20 x2 = 10'd80; y2 = 10'd80;
    #40 x2 = 10'd75; y2 = 10'd36;
    #80 x2 = 10'd100; y2 = 10'd100;
    #160 x2 = 10'd50; y2 = 10'd50;
    #320 x2 = 10'd55; y2 = 10'd86;
    #640 x2 = 10'd50; y2 = 10'd100;

    #1280;
    $finish;
    end

   always @(x, y, x2, y2, size, collision) begin
            #1;
            $display("x:%d, y:%d, x2:%d, y2:%d, size:%d, collision:%d", x, y, x2, y2, size, collision);
        end

    initial begin
         $dumpfile("imagecollision_tb.vcd");

   $dumpvars(0, imagecollision_tb); 
    end
endmodule
