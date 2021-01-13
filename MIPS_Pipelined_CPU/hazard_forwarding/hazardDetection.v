`include "defines.v"

module hazard_detection( ID_Rs, ID_Rt, EXE_Dest, MEM_Dest, Branch_CMD, ID_is_imm, /*ST_or_BNE*/, EXE_WB_EN, MEM_WB_EN, EXE_Mem_Read_EN, hazard_detected );
  input [`REG_FILE_ADDR_LEN-1:0] ID_Rs, ID_Rt, EXE_Dest, MEM_Dest;
  input [1:0] Branch_CMD;
  input ID_is_imm, EXE_WB_EN, MEM_WB_EN, EXE_Mem_Read_EN;
  //input ST_or_BNE;
  output hazard_detected;

  wire /*src2_is_valid, exe_has_hazard, mem_has_hazard,*/ instr_is_branch, load_use_hazard, branch_hazard;

  //assign src2_is_valid = (~ID_is_imm) || ST_or_BNE;

  assign instr_is_branch = (Branch_CMD == `COND_BEZ | Branch_CMD == `COND_BNE);
  
  assign load_use_hazard = EXE_Mem_Read_EN & (ID_Rs == EXE_Dest | (~ID_is_imm & ID_Rt == EXE_Dest));
  assign branch_hazard = instr_is_branch & (EXE_WB_EN & (ID_Rs == EXE_Dest | (~ID_is_imm & ID_Rt == EXE_Dest)) | //1st preceding load or R_type
                                            (MEM_WB_EN & (ID_Rs == MEM_Dest | (~ID_is_imm & ID_Rt == MEM_Dest)) ) );//2nd preceding load or R_type

  assign hazard_detected = load_use_hazard | branch_hazard; 


  //assign exe_has_hazard = EXE_WB_EN && ( ID_Rs == EXE_Dest || (~ID_is_imm && ID_Rt == EXE_Dest));
  //assign mem_has_hazard = MEM_WB_EN && ( ID_Rs == MEM_Dest || (~ID_is_imm && ID_Rt == MEM_Dest));
  //assign hazard_detected = (instr_is_branch & (exe_has_hazard | mem_has_hazard)) | (EXE_Mem_Read_EN & mem_has_hazard);//branch_hazard or load_use_hazard

endmodule
