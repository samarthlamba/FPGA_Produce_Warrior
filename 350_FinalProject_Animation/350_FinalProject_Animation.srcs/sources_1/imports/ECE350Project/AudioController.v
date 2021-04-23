module AudioController(
    input        clk, 		// System Clock Input 100 Mhz
    input        micData,	// Microphone Output
    input   switches,	// Tone control switches
    output       micClk, 	// Mic clock 
    output       chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut,	// PWM signal to the audio jack	
    output       audioEn);	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	wire[31:0] CounterLimit;
	wire[31:0] mainCounterLimit;
	reg[31:0] counter = 0; 
	reg clk1MHz = 0;
	wire[6:0] duty_cycle;
	reg[6:0] duty_cycle_condition;

	assign chSel   = 1'b0;  // Collect Mic Data on the rising edge 
	assign audioEn = switches;  // Enable Audio Output
	assign mainCounterLimit = CounterLimit;
	// Initialize the frequency array. FREQs[0] = 261
	wire[31:0] FREQs;
	
	assign FREQs = 32'd523;
    assign CounterLimit = (SYSTEM_FREQ / (2*FREQs)) - 1;
	

	always @(posedge clk) begin
		if(counter < mainCounterLimit)
			counter <= counter + 1;
		else begin
			counter <= 0;
			clk1MHz <= ~clk1MHz;
		end
	end
	
	//assign duty_cycle = clk1MHz ? 7'd75 : 7'd25;

    always @(posedge clk) begin
    if(switches == 1'b1) 
        duty_cycle_condition = clk1MHz ? 7'd75 : 7'd25;
    else if(audioEn == 1'b0)
        duty_cycle_condition = clk1MHz ? 7'd0 : 7'd0;
    end
    
    assign duty_cycle = duty_cycle_condition;
	
	PWMSerializer call(clk, 1'b0, duty_cycle, audioOut);

endmodule