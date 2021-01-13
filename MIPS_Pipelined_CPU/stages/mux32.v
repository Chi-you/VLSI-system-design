module Mux32 (in1, in2, sel, out);
  input sel;
  input [31:0] in1, in2;
  output [31:0] out;

  assign out = (sel == 0) ? in1 : in2;
endmodule // mxu