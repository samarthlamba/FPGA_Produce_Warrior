`timescale 1ns/100ps
module regfile_tb;

    // module inputs
    reg           clock = 0, ctrl_writeEn, ctrl_reset;
    reg [4:0]     ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    reg [31:0]    data_writeReg;
    reg[31:0] screenEndVal;
	initial begin
		#10 screenEndVal = 32'b00000000000000000000000000000000;
		#20 screenEndVal = 32'b00000000000000000000000000000001;
		#40 screenEndVal = 32'b00000000000000000000000000000000;
		#80 screenEndVal = 32'b00000000000000000000000000000001;
		#160 screenEndVal = 32'b00000000000000000000000000000000;
		#320 screenEndVal = 32'b00000000000000000000000000000001;
		#4000;
		$finish;
	end

    // expected module outputs
    reg [31:0] exp_dataRegA, exp_dataRegB;

    // module outputs
    wire [31:0] data_readRegA, data_readRegB;
	wire [31:0] reg_1_x, reg_2_x, reg_3_x, reg_4_x, reg_5_x, reg_6_x, reg_7_x, reg_8_x;
	wire [31:0] reg_9_y, reg_10_y, reg_11_y, reg_12_y, reg_13_y, reg_14_y, reg_15_y, reg_16_y;
	wire [31:0] reg_29_rand;

    // instantiate the regfile
    regfile tester (~clock, ctrl_writeEn, ctrl_reset, ctrl_writeReg,
        ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB, screenEndVal, reg_1_x, reg_2_x, reg_3_x, reg_4_x, reg_5_x, reg_6_x, reg_7_x, reg_8_x,
		reg_9_y, reg_10_y, reg_11_y, reg_12_y, reg_13_y, reg_14_y, reg_15_y, reg_16_y, reg_29_rand);

	// Initialize our strings
	reg[127:0] testName;

	// Where to store file error codes
	integer 	paramFile, 	   expFile,		diffFile, 	  actFile,
				paramScan,	   expScan;

	// Metadata
	integer errors = 0,
			tests = 0;

	initial begin
		// Assign Command Line Arguments to the Inputs
		if(! $value$plusargs("test=%s", testName)) begin
			$display("Please specify the test");
			$finish;
		end

		// Output file name
        $dumpfile({testName, ".vcd"});
        // Module to capture and what level, 0 means all wires
        $dumpvars(0, regfile_tb);

		// Read the expected file
		expFile = $fopen({testName, "_exp.csv"}, "r");

		// Check for any errors in opening the file
		if(!expFile) begin
			$display("Couldn't read the output file.",
				"\nMake sure you are in the right directory and the %0s_exp.csv file exists.", testName);
			$finish;
		end

		// Create the files to store the output
		actFile   = $fopen({testName, "_actual.csv"},   "w");
		diffFile  = $fopen({testName, "_diff.csv"},  "w");

		// Add the headers to the Actual and Difference files
		$fdisplay(actFile, "WriteEnable, Reset, WriteReg, WriteData, ReadRegA, ReadRegB, DataRegA, DataRegB");
		$fdisplay(diffFile, "Test Number, WriteEnable, Reset, WriteReg, WriteData, ReadRegA, ReadRegB,DataRegA, DataRegB, ExpReadDataA, ExpReadDataB");

		// Ignore the header of the Expected file
		expScan = $fscanf(expFile, "%s,%s,%s,%s,%s,%s,%s,%s", ctrl_writeEn, ctrl_reset, ctrl_writeReg, data_writeReg, ctrl_readRegA, ctrl_readRegB, exp_dataRegA, exp_dataRegB);

		if(expScan == 0) begin
			$display("Error reading the %0s file.\nMake sure there are no spaces in your file.\nYou can check by opening it in a text editor.", {testName, "_exp.csv"});
		end

		// Get the input for the parameters from the input file
		expScan = $fscanf(expFile, "%d,%d,%d,%d,%d,%d,%d,%d",
			ctrl_writeEn, ctrl_reset, ctrl_writeReg, data_writeReg,
			ctrl_readRegA, ctrl_readRegB, exp_dataRegA, exp_dataRegB);

		// Iterate until reaching the end of the file
		while(expScan == 8) begin

			@(negedge clock);

			tests = tests + 1;
         
			// Write the actual module outputs to the actual file
			$fdisplay(actFile, "%d,%d,%d,%d,%d,%d,%d,%d",
				ctrl_writeEn, ctrl_reset, ctrl_writeReg, $signed(data_writeReg),
				ctrl_readRegA, ctrl_readRegB, $signed(data_readRegA), $signed(data_readRegB));
			
			// Check for any inaccuracies in the module output and the expected output
			if((data_readRegA !== exp_dataRegA) | (data_readRegB !== exp_dataRegB)) begin

				// Increment the Errors
				errors = errors + 1;

				// Output any differences to the difference file
				$fdisplay(diffFile, "%0d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
					tests, ctrl_writeEn, ctrl_reset, ctrl_writeReg, $signed(data_writeReg),
					ctrl_readRegA, ctrl_readRegB, $signed(data_readRegA), $signed(data_readRegB), $signed(exp_dataRegA), $signed(exp_dataRegB));

				$display("Test %3d: FAILED, ScreenEnd: %d, reg7: %d, reg3: %d, reg9: %d, reg2:%d, reg13:%d, reg29:%d", tests, screenEndVal, reg_7_x, reg_3_x, reg_9_y, reg_2_x, reg_13_y, reg_29_rand);
			end else begin
				$display("Test %3d: PASSED, ScreenEnd: %d", tests, screenEndVal);
			end

			// Get the input for the parameters from the input file
			expScan = $fscanf(expFile, "%d,%d,%d,%d,%d,%d,%d,%d",
				ctrl_writeEn, ctrl_reset, ctrl_writeReg, data_writeReg,
				ctrl_readRegA, ctrl_readRegB, exp_dataRegA, exp_dataRegB);


		end

		// Close the Files
		$fclose(expFile);
		$fclose(actFile);
		$fclose(diffFile);

		// Display the tests and errors
		$display("Finished %0d test%c with %0d error%c", tests, "s"*(tests != 1), errors, "s"*(errors != 1));

		#100;
		$finish;
	end

    always 
    	#5 clock = !clock;

endmodule