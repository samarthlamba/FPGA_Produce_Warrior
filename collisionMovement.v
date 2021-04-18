//also take in x, y for hammer and check for collsion here itself. 
//Output a "tag or marker" when collision happens. Accordingly remove and add point
module collisionMovement(ycoordinateWater, screenEnd, waterUp, ycoordinateWater2, WaterUp2, screenEnd2)
    input [8:0] ycoordinateWater;
    input WaterUp;
    input screenEnd;

    output [8:0] ycoordinateWater2;
    input wire WaterUp2;
    input wire screenEnd2;
    
    
    if(ycoordinateWater <= 9'd480 && screenEnd && waterUp == 1'b1)
            ycoordinateWater2 = ycoordinateWater + 1'b1;
    else if(ycoordinateWater > 9'd480 && waterUp == 1'b1)
            WaterUp2 = ~waterUp;
    if(ycoordinateWater < 9'd180 && waterUp == 1'b0)
            WaterUp2 = ~waterUp;
    if(ycoordinateWater >= 9'd180 && screenEnd && waterUp == 1'b0)
            ycoordinateWater2 = ycoordinateWater - 1'b1;
endmodule