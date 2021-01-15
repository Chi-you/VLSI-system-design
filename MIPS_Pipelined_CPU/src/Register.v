`include "defines.v"

module Register (clk, rst, writeEn, regIn, regOut);
  input clk, rst, writeEn;
  input [`WORD_LEN-1:0] regIn;
  output [`WORD_LEN-1:0] regOut;

  reg [`WORD_LEN-1:0] regOut;

  always @ (posedge clk or posedge rst) begin
    if (rst) regOut <= `WORD_LEN'd0;
    else if (writeEn) regOut <= regIn;
  end
endmodule // register
