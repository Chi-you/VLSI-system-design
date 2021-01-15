//`include "cla4_nov.v"
module csa8_nov(din1, din2, carry_in, dout, carry_out);

  input	[7:0]	din1,din2;
  input		carry_in;
  output[7:0]	dout;
  output	carry_out;

  wire	[3:0]	sum1, sum2;
  wire		sel, cout1, cout2;

  cla4_nov a0(.din1(din1[3:0]), .din2(din2[3:0]), .carry_in(carry_in), .dout(dout[3:0]), .carry_out(sel));
  cla4_nov a1(.din1(din1[7:4]), .din2(din2[7:4]), .carry_in(1'b0), .dout(sum1), .carry_out(cout1));
  cla4_nov a2(.din1(din1[7:4]), .din2(din2[7:4]), .carry_in(1'b1), .dout(sum2), .carry_out(cout2));

  assign carry_out = (sel == 1'b1) ? cout2 : cout1;
  assign dout[7:4] = (sel == 1'b1) ? sum2 : sum1;

endmodule
