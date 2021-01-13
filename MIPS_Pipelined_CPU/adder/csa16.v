
module csa16(din1, din2, carry_in, dout, carry_out, overflow);

  input	[15:0]	din1,din2;
  input		carry_in;
  output[15:0]	dout;
  output	carry_out,overflow;

  wire	[15:0]	sum1, sum2;
  wire		sel, overflow0, overflow1, overflow2, cout1, cout2;

  csa8 a0(.din1(din1[7:0]), .din2(din2[7:0]), .carry_in(carry_in), .dout(dout[7:0]), .carry_out(sel), .overflow(overflow0));//overflow0 isn't used;
  csa8 a1(.din1(din1[15:8]), .din2(din2[15:8]), .carry_in(1'b0), .dout(sum1), .carry_out(cout1), .overflow(overflow1));
  csa8 a2(.din1(din1[15:8]), .din2(din2[15:8]), .carry_in(1'b1), .dout(sum2), .carry_out(cout2), .overflow(overflow2));

  assign carry_out = (sel) ? cout2 : cout1;
  assign dout[15:8] = (sel) ? sum2 : sum1;
  assign overflow = (sel) ? overflow2 : overflow1;

endmodule
