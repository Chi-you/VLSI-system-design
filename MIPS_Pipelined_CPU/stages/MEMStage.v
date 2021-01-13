`include "defines.v"
`include "dataMem.v"

module MEMStage (clk, rst, Mem_Read_EN, Mem_Write_EN, ALU_Result, Store_Value, Data_memory_out);
  input clk, rst, Mem_Read_EN, Mem_Write_EN;
  input [`WORD_LEN-1:0] ALU_Result, Store_Value;
  output [`WORD_LEN-1:0] Data_memory_out;
  
  dataMEM dataMEM(
    .clk(clk),
	.rst(rst),
	.writeEN(Mem_Write_EN),
	.readEN(Mem_Read_EN),
	.address(ALU_Result),
	.dataIn(Store_Value),
	.dataOut(Data_memory_out)
  );
endmodule
