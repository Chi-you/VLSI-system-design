`include "defines.v"

module regFile (clk, rst, readreg1, readreg2, writereg, writeData, writeEn, readdata1, readdata2);
  input clk, rst, writeEn;
  input [`REG_FILE_ADDR_LEN-1:0] readreg1, readreg2, writereg;
  input [`WORD_LEN-1:0] writeData;
  output [`WORD_LEN-1:0] readdata1, readdata2;

  reg [`WORD_LEN-1:0] regMem [0:`REG_FILE_SIZE-1]; // 32 x 32 
  integer i;

  always @ (negedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < `WORD_LEN; i = i + 1)
        regMem[i] <= 0;
	    end

    else if (writeEn) regMem[writereg] <= writeData;
    // regMem[0] <= 0;
  end

  assign readdata1 = regMem[readreg1];
  assign readdata2 = regMem[readreg2];
endmodule // regFile
