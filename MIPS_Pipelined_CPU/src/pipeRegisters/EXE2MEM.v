`include "defines.v"

module EXE2MEM (clk, rst, WB_EN_in, Mem_Read_EN_in, Mem_Write_EN_in, /*PC_in,*/ ALU_Result_in, Store_Value_in, Dest_in,
                          WB_EN,    Mem_Read_EN,    Mem_Write_EN,  /*  PC,*/    ALU_Result,    Store_Value,    Dest);
							
  input clk, rst;
  input WB_EN_in, Mem_Read_EN_in, Mem_Write_EN_in;
  input [`REG_FILE_ADDR_LEN-1:0] Dest_in;
  input [`WORD_LEN-1:0] ALU_Result_in, Store_Value_in;
  //input [`WORD_LEN-1:0] PC_in;
  
  output reg WB_EN, Mem_Read_EN, Mem_Write_EN;
  output reg [`REG_FILE_ADDR_LEN-1:0] Dest;
  output reg [`WORD_LEN-1:0] ALU_Result, Store_Value;
//output reg [`WORD_LEN-1:0] PC;
  
  always @ (posedge clk or posedge rst)begin
    if(rst)begin
	WB_EN <= 1'b0;
	Mem_Read_EN <= 1'b0;
	Mem_Write_EN <= 1'b0;
    //PC <= `WORD_LEN'b0;
	ALU_Result <= `WORD_LEN'b0;
	Store_Value <= `WORD_LEN'b0;
	Dest <= `REG_FILE_ADDR_LEN'b0;
	end
	else begin
	  WB_EN <= WB_EN_in;
	  Mem_Read_EN <= Mem_Read_EN_in;
	  Mem_Write_EN <= Mem_Write_EN_in;
	  //PC <= PC_in;
	  ALU_Result <= ALU_Result_in;
	  Store_Value <= Store_Value_in;
	  Dest <= Dest_in;
	end
  end
endmodule
