`include "defines.v"

module(clk, rst, Dest_in, Rt_Value_in, ALU_Input1_in, ALU_Input2_in, /*PC_in*/ EXE_CMD_in, Mem_Read_EN_in, Mem_Write_EN_in, WB_EN_in, Branch_Taken_in, Rs_in, Rt_in, is_imm_in, Shamt_in, Shift_Derection_in, Result_sel_in,
				 Dest,    Store_Value,  ALU_Input1,    ALU_Input2,   /* PC,*/    EXE_CMD,    Mem_Read_EN,    Mem_Write_EN,    WB_EN,    Branch_Taken,    Rs,    Rt,   is_imm, Shamt, Shift_Derection, Result_sel);
				   
  input clk, rst;
  input Mem_Read_EN_in, Mem_Write_EN_in, WB_EN_in, Branch_Taken_in, is_imm_in;
  input [`EXE_CMD_LEN-1:0] EXE_CMD_in;
  input [`REG_FILE_ADDR_LEN-1:0] Dest_in, Rs_in, Rt_in;
  input [`WORD_LEN-1:0] Rt_Value_in, ALU_Input1_in, ALU_Input2_in;
  input [4:0] Shamt_in;
  input Shift_Derection_in, Result_sel_in;
  //input PC_in;
  
  output reg Mem_Read_EN, Mem_Write_EN, WB_EN, Branch_Taken, is_imm;
  output reg [`EXE_CMD_LEN-1:0] EXE_CMD;
  output reg [`REG_FILE_ADDR_LEN-1:0] Dest, Rs, Rt;
  output reg [`WORD_LEN-1:0] Store_Value, ALU_Input1, ALU_Input2;
  output reg [4:0] Shamt;
  output reg Shift_Derection, Result_sel;
  //output PC;
  
  always@(posedge clk)begin
    if(rst)begin
	  Mem_Read_EN <= 1'b0;
	  Mem_Write_EN <= 1'b0;
	  WB_EN <= 1'b0;
	  Branch_Taken <= 1'b0;
	  EXE_CMD <= `EXE_CMD_LEN'b0;
	  Dest <= `REG_FILE_ADDR_LEN'b0;
	  Rs <= `REG_FILE_ADDR_LEN'b0;
	  Rt <= `REG_FILE_ADDR_LEN'b0;
	  Store_Value <= `WORD_LEN'b0;
	  ALU_Input1 <= `WORD_LEN'b0;
	  ALU_Input2 <= `WORD_LEN'b0;
	  Shamt <= 5'b0;
	  Shift_Derection <= 1'b0;
	  Result_sel <= 1'b0;
	  //PC <= `WORD_LEN'b0;
	end
	else begin
	  Mem_Read_EN <= Mem_Read_EN_in;
	  Mem_Write_EN <= Mem_Write_EN_in;
	  WB_EN <= WB_EN_in;
	  Branch_Taken <= Branch_Taken_in;
	  EXE_CMD <= EXE_CMD_in;
	  Dest <= Dest_in;
	  Rs <= Rs_in;
	  Rt <= Rt_in;
	  Store_Value <= Rt_Value_in;
	  ALU_Input1 <= ALU_Input1_in;
	  ALU_Input2 <= ALU_Input2_in;
	  Shamt <= Shamt_in;
	  Shift_Derection <= Shift_Derection_in;
	  Result_sel <= Result_sel_in;
	  //PC <= PC_in;
	end
  end
endmodule