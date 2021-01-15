`include "csa16.v"
`include "csa16_nov.v"
module csa32(din1, din2, carry_in, dout, carry_out, overflow);

  input	[31:0]	din1,din2;
  input		carry_in;
  output[31:0]	dout;
  output	carry_out,overflow;

  wire	[15:0]	sum1, sum2;
  wire		sel, overflow1, overflow2, cout1, cout2;

  csa16_nov a0(.din1(din1[15:0]), .din2(din2[15:0]), .carry_in(carry_in), .dout(dout[15:0]), .carry_out(sel));
  csa16 a1(.din1(din1[31:16]), .din2(din2[31:16]), .carry_in(1'b0), .dout(sum1), .carry_out(cout1), .overflow(overflow1));
  csa16 a2(.din1(din1[31:16]), .din2(din2[31:16]), .carry_in(1'b1), .dout(sum2), .carry_out(cout2), .overflow(overflow2));

  assign carry_out = (sel == 1'b1) ? cout2 : cout1;
  assign dout[31:16] = (sel == 1'b1) ? sum2 : sum1;
  assign overflow = (sel == 1'b1) ? overflow2 : overflow1;

endmodule
