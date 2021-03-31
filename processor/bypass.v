module bypass(ALUinB, ALUinA, FDBranches, FDBranchesB, dataMem, inst_out_fd, DX_inst, XM_inst, MW_inst, oneHotEncodedopCodeDX, isSavingToRegister);
//describes all the red bypass on slide 32: http://people.ee.duke.edu/~jab/ece350/Protected/Lecture%2013.pdf. 
//From left to right
input [31:0] inst_out_fd, DX_inst, XM_inst, MW_inst, oneHotEncodedopCodeDX;
input isSavingToRegister;
output [1:0] ALUinB, ALUinA, FDBranches,FDBranchesB;
output dataMem;

//MUX that feeds for branches and finding updated values
wire Branch0,Branch1, Branch2, isUpdatingInstructionDX, isUpdatingInstructionXM, isUpdatingInstructionMW;
  //  xnor dxRSAndxmRD(ALUinAtemp, DX_inst, )
// assign ALUinAtemp = 
  assign isUpdatingInstructionDX = (DX_inst[31:27] == 5'b0 || DX_inst[31:27] == 5'b01000 || DX_inst[31:27] == 5'b00101 || DX_inst[31:27] == 5'b00011);
  assign Branch0 = inst_out_fd[26:22] == DX_inst[26:22] && DX_inst[26:22] != 5'b0 && isUpdatingInstructionDX; //add r0 check
  assign isUpdatingInstructionXM = (XM_inst[31:27] == 5'b0 || XM_inst[31:27] == 5'b01000 || XM_inst[31:27] == 5'b00101 || XM_inst[31:27] == 5'b00011);
  assign Branch1 = inst_out_fd[26:22] == XM_inst[26:22] && XM_inst[26:22] != 5'b0 && isUpdatingInstructionXM;
  assign isUpdatingInstructionMW = (MW_inst[31:27] == 5'b0 || MW_inst[31:27] == 5'b01000 || MW_inst[31:27] == 5'b00101 || MW_inst[31:27] == 5'b00011);
  assign Branch2 = inst_out_fd[26:22] == MW_inst[26:22] && MW_inst[26:22] != 5'b0 && isUpdatingInstructionMW;

  
  encoder BranchAencooder0(FDBranches[1],FDBranches[0], 1'b1, Branch2, Branch1, Branch0);

  //MUX that feeds for branches and finding updated values for RS
wire BranchB0,BranchB1, BranchB2;
  //  xnor dxRSAndxmRD(ALUinAtemp, DX_inst, )
// assign ALUinAtemp = 
  assign BranchB0 = inst_out_fd[21:17] == DX_inst[26:22] && DX_inst[26:22] != 5'b0 && isUpdatingInstructionDX; //add r0 check
  assign BranchB1 = inst_out_fd[21:17] == XM_inst[26:22] && XM_inst[26:22] != 5'b0 && isUpdatingInstructionXM;
  assign BranchB2 = inst_out_fd[26:22] == MW_inst[26:22] && MW_inst[26:22] != 5'b0 && isUpdatingInstructionMW;

  
  encoder BranchAencooder1(FDBranchesB[1],FDBranchesB[0], 1'b1, BranchB2, BranchB1, BranchB0);

//MUX that feeds into ALU A
wire ALUinA0,ALUinA1, ALUinA2, ALUinA3;
  //  xnor dxRSAndxmRD(ALUinAtemp, DX_inst, )
// assign ALUinAtemp = 

  assign ALUinA0 = DX_inst[21:17] == XM_inst[26:22] && XM_inst[26:22] != 5'b0 && isUpdatingInstructionXM; //add r0 check
  assign ALUinA1 = isSavingToRegister && DX_inst[21:17] == MW_inst[26:22] && MW_inst[26:22] != 5'b0 && isUpdatingInstructionMW;
  assign ALUinA3 = XM_inst[31:27] == 5'b01000 &&  ALUinA0 && isUpdatingInstructionXM;//output to data mem
  assign ALUinA2 = ~(ALUinA0 || ALUinA1 || ALUinA3);
  
  encoder ALUAencooder0(ALUinA[1],ALUinA[0], ALUinA1, ALUinA0, ALUinA3, ALUinA2);

//MUX that feeds into ALU B
wire ALUinB0,ALUinB1, ALUinB2, ALUinB3;
  assign ALUinB0 = DX_inst[16:12] == XM_inst[26:22] && XM_inst[26:22] != 5'b0 && isUpdatingInstructionXM;
  assign ALUinB1 = DX_inst[16:12] == MW_inst[26:22] && MW_inst[26:22] != 5'b0 && isUpdatingInstructionMW;
  assign ALUinB3 = XM_inst[31:27] == 5'b01000 &&  ALUinB0 && DX_inst == 5'b00111;//output to data mem
  assign ALUinB2 = ~(ALUinB0 || ALUinB1 || ALUinB3);
  
  encoder ALUAencooder1(ALUinB[1],ALUinB[0], ALUinB1, ALUinB0, ALUinB3, ALUinB2);

  wire dataMem0;
  assign dataMem0 = (XM_inst[26:22] == MW_inst[26:22]) && (MW_inst[26:22] != 5'b0);
  
  assign dataMem = ~dataMem0;


endmodule