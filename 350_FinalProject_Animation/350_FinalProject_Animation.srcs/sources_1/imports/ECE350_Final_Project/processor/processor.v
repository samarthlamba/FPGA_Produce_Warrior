
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
    data_readRegB,                   // I: Data from port B of RegFile
	randomOut
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;
	output [7:0] randomOut;

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
  
    //---------------------------------------------------------------------------------------------------//
    //FD section
    wire [31:0] inst_out_fd, inst_out_fd_final;
 
    wire [4:0] opcode, rs, rt, rd, shamt, alu_op;
    wire [16:0] immediate;
    wire [26:0] target;
    wire [31:0] updatedReadRegA, updatedReadRegB, mult_result, data_result_branch, LatestSetXValue, setXValueDX, setXValueXM, sign_extended_branch; //extended to fit into mux
    wire isSW_JAL, isBranch, isSetXDX, isSetXXM,isNotEqual_branch, isLessThan_branch, overflow_branch;
    wire PC_additionSignExtension;
    wire[1:0] indexLatestSetX;

    //check if it is a save word or jr since RD needs to be selected and also initialize Jr
  

    
   // seed = final_inst_in_fd[31:27] == 5'd16?final_inst_in_fd[7:0]:8'd2;
    lfsr randomness(randomOut, clock);
    
    //determines next value for PC in case we branched
  
    //-------------------------------------------------------------------------------------------//
    // Decode Execute
    wire [31:0] inst_out_dx, pc_out_dx, A_out_dx, B_out_dx, sign_extended_immediate;
    wire [31:0] oneHotEncodedopCodeDX;
    wire[31:0] inst_in_xm, dx_xm_mux_result, PC_SX_Addition, finalDataResult, data_result_alu, chosenInputBALU, data_result_multiplication;
    wire isAddi_sw_lw;
    wire multCtrl, PC_SX_ovf, currentStatus, isStall, isMultDiv, isNotEqual, isLessThan, overflow, zeroOpcode, isMultiplication, isDivision, isMultiplicationOrDivision, data_exception, data_resultRDY;
    wire [4:0] actualALU_op, ctrl_shiftamt;
    wire [2:0] rStatus;

 

    //check for bypass
    wire [1:0] ALUinB, ALUinA;
    wire dataMem;

    //Bypass can be put in any place. Works all over
   
    //ALU logic and mux;
    wire [31:0] chosenInputAALU, o_in_xmSW,o_xm_setX, o_xm_multResult;
    wire [7:0] randValue;
    wire[31:0] o_xm_rand;
    wire overflow_multiplication, overflow_division;
   
    //---------------------------------------------------------------------------------------------------//
    
    //MW Stage
    wire [31:0] data_write_regTemp, setXValueMW;
    wire [5:0]ctrl_writeRegTemp;
    //adding setX to be checked in case setX value changed right before bex
  
endmodule