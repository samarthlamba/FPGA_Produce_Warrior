module seven_seg_counter(input clk, input reset, output[3:0] anode,output a7, output a6, output a5, output a4, output[6:0] LEDvals, input choose, input[2:0] livesvalue);

reg [26:0] counts;
reg[6:0] cathode;
reg[6:0] LEDval;
wire en;
reg [15:0] display;
reg [3:0] BCD;
reg [19:0] refcounts;
wire [1:0] LEDcountchoose;
reg [3:0] anodes;
wire a0,a1,a2,a3;

always @(posedge clk or posedge reset)
begin
    if(reset)
        counts <= 0;
    else begin
        if(counts >= 99999999)
            counts <= 0;
        else
            counts <= counts + 1;
    end
end

assign en = (counts == 99999999) ? 1: 0;
always @(posedge clk or posedge reset)
begin
    if(reset)
        display <= 0;
    else if(en == 1)
        display <= display + 1;
end
always @(posedge clk or posedge reset)
begin
    if(reset)
        refcounts <= 0;
    else
        refcounts <= refcounts + 1;
end
assign LEDcountchoose = refcounts[19:17];

always @(*)
begin
    case(LEDcountchoose)
    2'b000: begin
        anodes <= 4'b0111;
        BCD = display/1000;
    end
    2'b001: begin
        anodes <= 4'b1011;
        BCD = (display % 1000)/100;
    end
    2'b010: begin
        anodes <= 4'b1101;
        BCD = ((display % 1000)%100)/10;
    end
    2'b011: begin
        anodes <= 4'b1110;
        BCD = ((display % 1000)%100)%10;
    end
    endcase
end
assign a7 = 1'b1;
assign a6 = 1'b1;
assign a5 = 1'b1;
//assign a4 = 1'b0;
assign a0 = 1'b1;
assign a1 = 1'b1;
assign a2 = 1'b1;
assign a3 = 1'b1;
always @(*)
begin
    if(livesvalue == 3'b001) begin
        LEDval <= 7'b0000110;
    end
    if(livesvalue == 3'b010) begin
        LEDval <= 7'b0010010;
    end
    if(livesvalue == 3'b011) begin
        LEDval <= 7'b1001111;
    end
    if(livesvalue == 3'b100) begin
        LEDval <= 7'b0000001;
    end
end
always @(*)
    begin
        case(BCD)
        4'b0000: cathode = 7'b0000001; // "0"     
        4'b0001: cathode = 7'b1001111; // "1" 
        4'b0010: cathode = 7'b0010010; // "2" 
        4'b0011: cathode = 7'b0000110; // "3" 
        4'b0100: cathode = 7'b1001100; // "4" 
        4'b0101: cathode = 7'b0100100; // "5" 
        4'b0110: cathode = 7'b0100000; // "6" 
        4'b0111: cathode = 7'b0001111; // "7" 
        4'b1000: cathode = 7'b0000000; // "8"     
        4'b1001: cathode = 7'b0000100; // "9"
//        4'b1010: cathode = 7'b0001110; //"L"
//        4'b1011: cathode = 7'b0110000; // "I"
//        4'b1100: cathode = 7'b0111110; // "V"
//        4'b1101: cathode = 7'b1001111; //"E"
        default: cathode = 7'b0000001; // "0"
        endcase
    end
assign LEDvals = choose ? LEDval: cathode;
assign anode[0] = choose ? 1'b1 : anodes[0];
assign anode[1] = choose ? 1'b1 : anodes[1];
assign anode[2] = choose ? 1'b1 : anodes[2];
assign anode[3] = choose ? 1'b1 : anodes[3];
assign a4 = choose ? 1'b0 : 1'b1;

 endmodule