
//`include "csa16_nov.v"
//`include "csa16_nov_nco.v"
/*
`include "csa8_nov.v"
`include "csa8_nov_nco.v"
`include "cla4_nov.v"
`include "cla4_nov_nco.v"
*/

module csa32_nov_nco(din1, din2, carry_in, dout);

  input	[31:0]	din1,din2;
  input		carry_in;
  output[31:0]	dout;

  wire	[15:0]	sum1, sum2;
  wire		sel;

  csa16_nov a0(.din1(din1[15:0]), .din2(din2[15:0]), .carry_in(carry_in), .dout(dout[15:0]), .carry_out(sel));
  csa16_nov_nco a1(.din1(din1[31:16]), .din2(din2[31:16]), .carry_in(1'b0), .dout(sum1));
  csa16_nov_nco a2(.din1(din1[31:16]), .din2(din2[31:16]), .carry_in(1'b1), .dout(sum2));

  assign dout[31:16] = (sel == 1'b1) ? sum2 : sum1;

endmodule
