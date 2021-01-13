`include "defines.v"

module mux #(parameter integer LENGTH) (in1, in2, sel, out);
  input sel;
  input [LENGTH-1:0] in1, in2;
  output [LENGTH-1:0] out;

  assign out = (sel == 0) ? in1 : in2;
endmodule // mxu

