module seven_seg_counter(input clk, input reset, output reg [3:0] anode, output reg [6:0] cathode);
//https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html
reg [26:0] counts;
wire en;
reg [15:0] display;
reg [3:0] BCD;
reg [19:0] refcounts;
wire [1:0] LEDcountchoose;

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

assign en = (en == 99999999) ? 1: 0;
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
assign LEDcountchoose = refcounts[19:18];

always @(*)
begin
    case(LEDcountchoose)
    2'b00: begin
        anode = 4'b0111;
        BCD = display/1000;
    end
    2'b01: begin
        anode = 4'b1011;
        BCD = (display % 1000)/100;
    end
    2'b10: begin
        anode = 4'b1101;
        BCD = ((display % 1000)%100)/10;
    end
    2'b11: begin
        anode = 4'b1110;
        BCD = ((display % 1000)%100)%10;
    end
    endcase
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
        default: cathode = 7'b0000001; // "0"
        endcase
    end
 endmodule