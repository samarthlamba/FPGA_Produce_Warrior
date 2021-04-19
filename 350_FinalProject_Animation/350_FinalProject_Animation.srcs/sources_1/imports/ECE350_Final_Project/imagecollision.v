module imagecollision(x, y,  x2, y2, size, collision);
    input[9:0] x;
    input[8:0] y;
    input[9:0] x2;
    input[8:0] y2;
    input[9:0] size;
    output collision;
    reg collisionval;

    always @(*) begin
        if(x2 <= x + size && y2 <= y + size && x2 >= x && y2 >= y)
            collisionval = 1'b1;
        else
            collisionval = 1'b0;
    end
    
    assign collision = collisionval;

endmodule