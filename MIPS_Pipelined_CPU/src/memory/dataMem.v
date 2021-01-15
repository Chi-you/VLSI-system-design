`include "defines.v"

module dataMEM (clk, rst, writeEN, readEN, address, dataIn, dataOut);
  input clk, rst, readEN, writeEN;
  input [`WORD_LEN-1:0] address, dataIn;
  output [`WORD_LEN-1:0] dataOut;

  integer i;
  reg [`MEM_CELL_SIZE-1:0] data_Mem [0:`DATA_MEM_SIZE-1];
  wire [`WORD_LEN-1:0] base_address;

  always @ (negedge clk) begin
    if (rst)
      for (i = 0; i < `DATA_MEM_SIZE; i = i + 1)
        data_Mem[i] <= `DATA_MEM_SIZE'b0;
    else if (writeEN)
      {data_Mem[base_address], data_Mem[base_address + 1], data_Mem[base_address + 2], data_Mem[base_address + 3]} <= dataIn;
  end

  assign base_address = (address >> 2) << 2;
  assign dataOut = readEN ? ( {data_Mem[base_address], data_Mem[base_address + 1], data_Mem[base_address + 2], data_Mem[base_address + 3]}) : 32'hzzzz_zzzz;
endmodule // data_Mem
