`timescale 1ns / 1 ps
module binary_BCD(
    input clk,
    input [7:0] eightbitbinary,
    output reg [3:0] onesplace = 0,
    output reg [3:0] tensplace = 0,
    output reg [3:0] hundredsplace = 0
);

reg [3:0] iters = 0;
reg [19:0] shift_reg = 0;
reg [3:0] init_hund = 0;
reg [3:0] init_ten = 0;
reg [3:0] init_one = 0;
reg [7:0] old_eight = 0;

always @(posedge clk) begin
    if (iters == 0 & (old_eight != eightbitbinary)) begin
        shift_reg = 20'd0;
        old_eight = eightbitbinary;
        init_hund = shift_reg[19:16];
        init_ten = shift_reg[15:12];
        init_one = shift_reg[11:8];
        iters = iters + 1;
    end
    if (iters <9 & iters>0)begin
        if(init_hund >= 5) init_hund = init_hund + 3;
        if(init_ten >= 5) init_ten = init_ten + 3;
        if(init_one >= 5) init_one = init_one + 3;
        shift_reg [19:8] = {init_hund, init_ten, init_one};
        shift_reg = shift_reg << 1;
        init_hund = shift_reg[19:16];
        init_ten = shift_reg[15:12];
        init_one = shift_reg[11:8];
        iters = iters + 1;
    end
    if (iters == 9) begin
        iters = 0;
        onesplace = init_one;
        tensplace = init_ten;
        hundredsplace = init_hund;
    end
end
endmodule