`include "defines.v"

module WBStage (Mem_Read_EN, Data_memory, ALU_Result, Result_WB);
  input Mem_Read_EN;
  input [`WORD_LEN-1:0] Data_memory, ALU_Result;
  output [`WORD_LEN-1:0] Result_WB;

  assign Result_WB = (Mem_Read_EN) ? Data_memory : ALU_Result;
endmodule // WBStage
