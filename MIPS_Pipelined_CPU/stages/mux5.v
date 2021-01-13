module Mux5 (in1, in2, sel, out);
  input sel;
  input [4:0] in1, in2;
  output [4:0] out;

  assign out = (sel == 0) ? in1 : in2;
endmodule // mxu