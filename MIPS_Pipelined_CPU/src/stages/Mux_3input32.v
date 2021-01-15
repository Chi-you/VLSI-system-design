module Mux_3input32 (in1, in2, in3, sel, out);
  input [31:0] in1, in2, in3;
  input [1:0] sel;
  output [31:0] out;

  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 : in3;
endmodule // mux