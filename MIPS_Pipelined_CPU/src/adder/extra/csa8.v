`include "cla4.v"
`include "cla4_nov.v"
module csa8(din1, din2, carry_in, dout, carry_out, overflow);

  input	[7:0]	din1,din2;
  input		carry_in;
  output[7:0]	dout;
  output	carry_out,overflow;

  wire	[3:0]	sum1, sum2;
  wire		sel, overflow1, overflow2, cout1, cout2;

  cla4_nov a0(.din1(din1[3:0]), .din2(din2[3:0]), .carry_in(carry_in), .dout(dout[3:0]), .carry_out(sel));
  cla4 a1(.din1(din1[7:4]), .din2(din2[7:4]), .carry_in(1'b0), .dout(sum1), .carry_out(cout1), .overflow(overflow1));
  cla4 a2(.din1(din1[7:4]), .din2(din2[7:4]), .carry_in(1'b1), .dout(sum2), .carry_out(cout2), .overflow(overflow2));

  assign carry_out = (sel == 1'b1) ? cout2 : cout1;
  assign dout[7:4] = (sel == 1'b1) ? sum2 : sum1;
  assign overflow = (sel == 1'b1) ? overflow2 : overflow1;

endmodule
