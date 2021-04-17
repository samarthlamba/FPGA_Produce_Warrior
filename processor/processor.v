
/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */


    wire [31:0] final_inst_in_fd, new_PC_addition, PC_out, nextPC_out, inst_in_fd, PC_in, pc_out_fd, oneHotEncodedopCodeFD, PC_addition, actual_inst_in_fd;

    //wires for MX Stage:
    wire [31:0] inst_out_mw, d_out_mw, o_out_mw, oneHotEncodedopCodeMW,temp_readRegB, JrTarget;
    
    //wire for XM Stage:
    wire [31:0] o_in_xm, jumpTarget, inst_out_xm, B_out_xm, o_out_xm, oneHotEncodedopCodeXM,PC_in_mux, bexTarget;

    wire reset, unusedOVF, isBranchJump, isJalFD_in, isJr, isBex, isJalorJ, futureBranch;
    wire [2:0] JumpType;
    wire [4:0] temp_ctrl_readRegA;
    wire [1:0] FDBranches, FDBranchesB;
    wire isBLT, isBNE, en, isJump, finalSign;
   
    //PC counter    
    or jumps(isJalorJ, isJalFD_in, isJump);
    encoder_8_bit typeOfJump(JumpType, 1'b1, isJalorJ, isJr, isBex, isBranchJump, 1'b0, 1'b0, 1'b0);
    mux_eight_one mux_for_pc(PC_in_mux, JumpType, PC_in, jumpTarget, JrTarget, bexTarget, new_PC_addition, PC_in, PC_in, PC_in);
    PC pc1(PC_out, PC_in_mux, clock, en, reset);    
    cla_32_bit_adder pcAdder(PC_in, PC_out, 32'd0, unusedOVF, 1'b1);

    //Fetch Decode
    assign address_imem = PC_out;
    or needToSendInnop(futureBranch, isBex, isJr, isBranchJump);
    assign inst_in_fd = q_imem;
   
    //check to see if is Jump instruction. Makes things faster. Happens in very first cycle
    and isJumpInstruction(isJump, ~actual_inst_in_fd[31], ~actual_inst_in_fd[30], ~actual_inst_in_fd[29], ~actual_inst_in_fd[28], actual_inst_in_fd[27]);
    
    //check to see is JAL instruction. Makes things faster.
    and isJalInstruction(isJalFD_in, ~actual_inst_in_fd[31], ~actual_inst_in_fd[30], ~actual_inst_in_fd[29], actual_inst_in_fd[28], actual_inst_in_fd[27]);
    
    //Create jump target in case it has to be used
    assign jumpTarget = inst_in_fd[26]?{{5{1'b1}}, inst_in_fd[26:0]} : {{5{1'b0}}, inst_in_fd[26:0]}; 

    //determine if nop needs to be inputted. Only for isBex, isJr, isBranchJump if things were branched. Makes things faster
    assign actual_inst_in_fd = futureBranch?32'b0: inst_in_fd;
    assign final_inst_in_fd = isJalFD_in?{actual_inst_in_fd[31:27], {5{1'b1}}, 22'b0}:actual_inst_in_fd;
    
    //---------------------------------------------------------------------------------------------------//
    //FD section
    wire [31:0] inst_out_fd;
    FD fd1(inst_out_fd, pc_out_fd, final_inst_in_fd, PC_in, clock, en, reset);

    //creates decoder
    decoder opCode0(1'b1, inst_out_fd[31:27], oneHotEncodedopCodeFD);
    wire [4:0] opcode, rs, rt, rd, shamt, alu_op;
    wire [16:0] immediate;
    wire [26:0] target;
    wire [31:0] updatedReadRegA, updatedReadRegB, mult_result, data_result_branch, LatestSetXValue, setXValueDX, setXValueXM, sign_extended_branch; //extended to fit into mux
    wire isSW_JAL, isBranch, isSetXDX, isSetXXM,isNotEqual_branch, isLessThan_branch, overflow_branch;
    wire PC_additionSignExtension;
    wire[1:0] indexLatestSetX;

    //check if it is a save word or jr since RD needs to be selected and also initialize Jr
    or checkSW(isSW_JAL, oneHotEncodedopCodeFD[7], oneHotEncodedopCodeFD[4]);
    assign isJr = oneHotEncodedopCodeFD[4];
    assign JrTarget = updatedReadRegA;
    
    //BEX initialization
    assign isBex = LatestSetXValue != 32'd0 && oneHotEncodedopCodeFD[22];
    assign bexTarget = inst_out_fd[26]?{{5{1'b1}}, inst_out_fd[26:0]} : {{5{1'b0}}, inst_out_fd[26:0]}; 

    // check if it is a branch instruction
    or checkAisRD(isBranch, oneHotEncodedopCodeFD[6], oneHotEncodedopCodeFD[2]); //A is RD for blt and bne
    //check to confirm what values we need
    assign temp_ctrl_readRegA = isBranch?inst_out_fd[26:22]:inst_out_fd[21:17]; //rd : rs
    assign ctrl_readRegA = oneHotEncodedopCodeFD[22]? 5'd30:temp_ctrl_readRegA;
    assign temp_readRegB = isBranch?inst_out_fd[21:17]:inst_out_fd[16:12]; //rs : rt
    assign ctrl_readRegB = isSW_JAL?inst_out_fd[26:22]:temp_readRegB; //choose if it should be rd
    
    //creates encoder to determine where the latest setX value is. A way to bypass
    encoder findLatestSetX(indexLatestSetX[1], indexLatestSetX[0], 1'b1, isSetXXM, isSetXDX, 1'b0);
    //based on encoded location, we can choose where the latest setX value is
    mux_four_one chooseLatestSetX(LatestSetXValue, indexLatestSetX, data_readRegA,setXValueXM,setXValueDX, data_readRegA); //bypass for setX
    
    //Bypass for the latest value of ReadRegA and ReadRegB
    mux_four_one updatedRDValue(updatedReadRegA, FDBranches, data_readRegA, data_writeReg, o_out_xm, o_in_xm);
    mux_four_one updatedRSValue(updatedReadRegB, FDBranchesB, data_readRegB, data_writeReg, o_out_xm, o_in_xm); //need to make fd branches do 1
    
    //Additional ALU used for branches to determine what to do.
    alu aluBranchComparator(updatedReadRegA, updatedReadRegB, 5'b0, 5'b0, data_result_branch, isNotEqual_branch, isLessThan_branch, overflow_branch);
    and checkIsBLT(isBLT, oneHotEncodedopCodeFD[6], isLessThan_branch); //TODO: need to fix this
    and checkIsBEQ(isBNE, oneHotEncodedopCodeFD[2], updatedReadRegA != updatedReadRegB);
    or checkJumps(isBranchJump, isBLT, isBNE);
    assign sign_extended_branch=inst_out_fd[16]?{{15{1'b1}}, inst_out_fd[16:0]} : {{15{1'b0}}, inst_out_fd[16:0]};
    wire [7:0] randomOut;
    
   // seed = final_inst_in_fd[31:27] == 5'd16?final_inst_in_fd[7:0]:8'd2;
    lfsr randomness(randomOut, clock, inst_out_fd[8], 8'd2, PC_out!= 32'd0, 1'b1);
    
    //determines next value for PC in case we branched
    cla_32_bit_adder adderAfterPC(new_PC_addition, sign_extended_branch, pc_out_fd, PC_additionSignExtension, 1'b0);
    
    //-------------------------------------------------------------------------------------------//
    // Decode Execute
    wire [31:0] inst_out_dx, pc_out_dx, A_out_dx, B_out_dx, sign_extended_immediate;
    wire [31:0] oneHotEncodedopCodeDX;
    wire[31:0] inst_in_xm, dx_xm_mux_result, PC_SX_Addition, finalDataResult, data_result_alu, chosenInputBALU, data_result_multiplication;
    wire isAddi_sw_lw;
    wire multCtrl, PC_SX_ovf, currentStatus, isStall, isMultDiv, isNotEqual, isLessThan, overflow, zeroOpcode, isMultiplication, isDivision, isMultiplicationOrDivision, data_exception, data_resultRDY;
    wire [4:0] actualALU_op, ctrl_shiftamt;
    wire [2:0] rStatus;

    DX DXLatch(inst_out_dx, pc_out_dx, A_out_dx, B_out_dx, inst_out_fd, pc_out_fd, data_readRegA, data_readRegB, clock, en, reset);
  
    decoder opCode(1'b1, inst_out_dx[31:27], oneHotEncodedopCodeDX);

    //adding setX to be checked in case setX value changed right before bex. A form of bypass. Helps increase speed in case for bex. No stall needed
    assign isSetXDX = oneHotEncodedopCodeDX[21];
    assign setXValueDX = inst_out_dx[26]?{{5{1'b1}}, inst_out_dx[26:0]} : {{5{1'b0}}, inst_out_dx[26:0]}; 

    //check for bypass
    wire [1:0] ALUinB, ALUinA;
    wire dataMem;

    //Bypass can be put in any place. Works all over
    bypass bypassChecker(ALUinB, ALUinA, FDBranches, FDBranchesB, dataMem, inst_out_fd, inst_out_dx, inst_out_xm, inst_out_mw, oneHotEncodedopCodeDX);
   
    // checks if it is addi/sw/lw since we need sign extended immediate
    or checkifIsAddiSWLW(isAddi_sw_lw, oneHotEncodedopCodeDX[5], oneHotEncodedopCodeDX[7], oneHotEncodedopCodeDX[8]);
    assign sign_extended_immediate=inst_out_dx[16]?{{15{1'b1}}, inst_out_dx[16:0]} : {{15{1'b0}}, inst_out_dx[16:0]};
    
    //Value from bypass used according to picture from the slides
    mux_four_one aluBottomMux(dx_xm_mux_result, ALUinB, data_writeReg, o_out_xm, q_dmem,B_out_dx);

    //Chosen inputB to put in ALU. Is determined based on type of operation.
    assign chosenInputBALU = isAddi_sw_lw?sign_extended_immediate:dx_xm_mux_result;
    
    //Confirms if the operation is RType.
    assign zeroOpcode = oneHotEncodedopCodeDX[0];
    assign actualALU_op = zeroOpcode?inst_out_dx[6:2] : 5'd0;
    assign ctrl_shiftamt = zeroOpcode ? inst_out_dx[11:7] :5'd0;

    //ALU logic and mux;
    wire [31:0] chosenInputAALU, o_in_xmSW,o_xm_setX, o_xm_multResult;
    wire [7:0] randValue;
    wire[31:0] o_xm_rand;
    wire overflow_multiplication, overflow_division;
    mux_four_one aluTopMux(chosenInputAALU, ALUinA, data_writeReg, o_out_xm, q_dmem, A_out_dx);
    alu aluCalculator(chosenInputAALU, chosenInputBALU, actualALU_op, ctrl_shiftamt, data_result_alu, isNotEqual, isLessThan, overflow);
    
    //Calculates multiplication/division and determines if we need to stall
    stall mulitiplicationDiv(isMultDiv, isStall, overflow_multiplication, overflow_division, inst_out_dx, inst_out_fd, chosenInputAALU,chosenInputBALU, mult_result, ~clock);
   
    //if multiplication/division then we choose multiplication/division
    assign finalDataResult = isMultDiv? data_result_multiplication:data_result_alu;
    //determines if we need to stall and sets the early latches to off if needed
    assign en = ~isStall; 
    assign o_in_xmSW = oneHotEncodedopCodeDX[3]?pc_out_dx: data_result_alu;
    assign o_xm_setX = oneHotEncodedopCodeDX[21]?setXValueDX : o_in_xmSW;//finalDataResult;

    assign o_xm_rand = oneHotEncodedopCodeDX[16]? {24'b0, randomOut}:o_xm_setX;
    assign o_xm_multResult = isMultDiv? mult_result:o_xm_rand;
    //8 bit encoder to determine the rStatus value absed on if there was an overflow in any of the operation
    encoder_8_bit rStatusEncoder(rStatus, 1'b1, overflow && actualALU_op == 5'd0, overflow && actualALU_op ==5'd1, overflow && actualALU_op == 5'd2, overflow_multiplication && actualALU_op == 5'd0,overflow_division && actualALU_op == 5'd0, 1'b0, 1'b0);
    mux_eight_one muxChooseOutputXM(o_in_xm, rStatus, o_xm_multResult, 32'd1, 32'd2, 32'd3, 32'd4, 32'd5, o_xm_multResult, o_xm_multResult);
    assign inst_in_xm = overflow? 32'b00000111100000000000000000000000: inst_out_dx;
 
 //----------------------------------------------------------------------------------------------//
    // XM Stage
    XM XMLatch(inst_out_xm, B_out_xm, o_out_xm, inst_in_xm, B_out_dx, o_in_xm, clock, en, reset);
    decoder opCode2(1'b1, inst_out_xm[31:27], oneHotEncodedopCodeXM);

    //determines data memory values. Only needs to be written in for sw
    assign wren = oneHotEncodedopCodeXM[7];
    assign address_dmem = o_out_xm;
    assign data = dataMem? B_out_xm: data_writeReg;

    //adding setX to be checked in case setX value changed right before bex
    assign isSetXXM = oneHotEncodedopCodeXM[21];
    assign setXValueXM = inst_out_xm[26]?{{5{1'b1}}, inst_out_xm[26:0]} : {{5{1'b0}}, inst_out_xm[26:0]}; 

    //---------------------------------------------------------------------------------------------------//
    
    //MW Stage
    wire [31:0] data_write_regTemp, setXValueMW;
    wire [5:0]ctrl_writeRegTemp;
    MW MWLatch(inst_out_mw, d_out_mw, o_out_mw, inst_out_xm, q_dmem, o_out_xm,  clock, en, reset);
    decoder opCode3(1'b1, inst_out_mw[31:27], oneHotEncodedopCodeMW);
    
    //adding setX to be checked in case setX value changed right before bex
    assign setXValueMW = inst_out_mw[26]?{{5{1'b1}}, inst_out_mw[26:0]} : {{5{1'b0}}, inst_out_mw[26:0]};

    //Determines what to write to register
    assign data_write_regTemp = oneHotEncodedopCodeMW[21]?setXValueMW:o_out_mw; 
    assign data_writeReg = oneHotEncodedopCodeMW[8]?d_out_mw:data_write_regTemp; 
    assign ctrl_writeRegTemp = oneHotEncodedopCodeMW[21]?5'd30: inst_out_mw[26:22];
    assign ctrl_writeReg = oneHotEncodedopCodeMW[3]?5'd31: ctrl_writeRegTemp;
    //determines if we need to write anything. Only need it for R types, jal, addi, lw
    or regFileCtrl(ctrl_writeEnable, oneHotEncodedopCodeMW[16], oneHotEncodedopCodeMW[0], oneHotEncodedopCodeMW[3], oneHotEncodedopCodeMW[5], oneHotEncodedopCodeMW[8], oneHotEncodedopCodeMW[21]);

endmodule