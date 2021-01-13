`include "defines.v"

module Register (clk, rst, writeEn, regIn, regOut);
  input clk, rst, writeEn;
  input [`WORD_LEN-1:0] regIn;
  output [`WORD_LEN-1:0] regOut;

  reg [`WORD_LEN-1:0] regOut;

  always @ (posedge clk) begin
    if (rst == 1) regOut <= 0;
    else if (writeEn) regOut <= regIn;
  end
endmodule // register
