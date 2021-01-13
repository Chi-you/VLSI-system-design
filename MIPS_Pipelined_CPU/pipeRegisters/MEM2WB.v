`include"defines.v"

module MEM2WB(clk, rst, WB_EN_in, Mem_Read_EN_in, ALU_Result_in, Data_memory_in, Dest_in,
                        WB_EN,    Mem_Read_EN,    ALU_Result,    Data_memory,    Dest);
		
	input clk, rst;
	input WB_EN_in, Mem_Read_EN_in;
	input [`WORD_LEN-1:0] ALU_Result_in, Data_memory_in;
	input [`REG_FILE_ADDR_LEN-1:0] Dest_in;
	
	output reg WB_EN, Mem_Read_EN;
	output reg[`WORD_LEN-1:0] ALU_Result, Data_memory;
	output reg[`REG_FILE_ADDR_LEN-1:0] Dest;
	
	always@(posedge clk)begin
	  if(rst)begin
		WB_EN <= 1'b0;
                Mem_Read_EN <= 1'b0;
		ALU_Result <= `WORD_LEN'b0;
		Data_memory <= `WORD_LEN'b0;
		Dest <= `REG_FILE_ADDR_LEN'b0;
	  end
	  else begin
		WB_EN <= WB_EN_in;
		Mem_Read_EN <= Mem_Read_EN_in;
		ALU_Result <= ALU_Result_in;
		Data_memory <= Data_memory_in;
		Dest <= Dest_in;
	  end
	end
endmodule
