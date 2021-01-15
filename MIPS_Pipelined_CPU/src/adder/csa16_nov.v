//`include "csa8_nov.v"
module csa16_nov(din1, din2, carry_in, dout, carry_out);

  input	[15:0]	din1,din2;
  input		carry_in;
  output[15:0]	dout;
  output	carry_out;

  wire	[7:0]	sum1, sum2;
  wire		sel, cout1, cout2;

  csa8_nov a0(.din1(din1[7:0]), .din2(din2[7:0]), .carry_in(carry_in), .dout(dout[7:0]), .carry_out(sel));
  csa8_nov a1(.din1(din1[15:8]), .din2(din2[15:8]), .carry_in(1'b0), .dout(sum1), .carry_out(cout1));
  csa8_nov a2(.din1(din1[15:8]), .din2(din2[15:8]), .carry_in(1'b1), .dout(sum2), .carry_out(cout2));

  assign carry_out = (sel == 1'b1) ? cout2 : cout1;
  assign dout[15:8] = (sel == 1'b1) ? sum2 : sum1;

endmodule
