`timescale 1ns/10ps
`define CYCLE 20
`ifdef SYN
  `include "../syn/MIPS_CPU_syn.v"
  `include "../syn/tsmc18.v"
  `include "../memory/dataMem.v"
  `include "../memory/instructionMem.v"
`else
  `include "../MIPS_CPU.v"
  `include "../memory/dataMem.v"
  `include "../memory/instructionMem.v"
`endif
module MIPS_CPU_tb();
  reg clk,rst;
  //reg [`MEM_CELL_SIZE-1:0] Mem [0:`INSTR_MEM_SIZE-1];
  wire Mem_Write_EN, Mem_Read_EN;
  wire [`WORD_LEN-1:0]	ALU_Result, Store_Value, Data_memory_out;
//===============
   wire [`WORD_LEN-1:0] instruction, PC;
//=============
  MIPS_CPU DUT (.clk(clk), .rst(rst),
 .Data_memory_out(Data_memory_out), .Mem_Read_EN(Mem_Read_EN), .Mem_Write_EN(Mem_Write_EN), .ALU_Result(ALU_Result), .Store_Value(Store_Value),
  /*input:*/ .instruction(instruction), /*output*/.addr(PC));

  instructionMem instructions (
    .rst(rst),
    .addr(PC),
    .instruction(instruction)
  );
  
  dataMEM dataMEM(
    	.clk(clk),
	.rst(rst),
	.writeEN(Mem_Write_EN),
	.readEN(Mem_Read_EN),
	.address(ALU_Result),
	.dataIn(Store_Value),
	.dataOut(Data_memory_out)
  );
  `ifdef full
    initial clk = 0;
    always #(`CYCLE/2) clk = ~clk ;
    initial begin
      rst = 1;
      $readmemb("../sim/all_instructions_without_Branch_Jump.txt", instructions.instMem); //instructions.inst
      # 10  rst = 0;
      # 10000 $finish;
    end
  `endif
  initial begin
    `ifdef FSDB
      $fsdbDumpfile("CPU.fsdb");
      $fsdbDumpvars("+mda");
    `endif
  end
  `ifdef SYN
	  initial $sdf_annotate("../syn/MIPS_CPU_syn.sdf",DUT); 
  `endif
endmodule // test
