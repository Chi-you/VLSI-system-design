`include "defines.v"
// delete
module PC_Adder (in1, in2, out);
  input [`WORD_LEN-1:0] in1, in2;
  output [`WORD_LEN-1:0] out;

  assign out = in1 + in2;
endmodule // adder
