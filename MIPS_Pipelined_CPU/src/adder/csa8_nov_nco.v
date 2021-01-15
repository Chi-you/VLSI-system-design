//`include "cla4_nov.v"
//`include "cla4_nov_nco.v"
module csa8_nov_nco(din1, din2, carry_in, dout);

  input	[7:0]	din1,din2;
  input		carry_in;
  output[7:0]	dout;

  wire	[3:0]	sum1, sum2;
  wire		sel;

  cla4_nov a0(.din1(din1[3:0]), .din2(din2[3:0]), .carry_in(carry_in), .dout(dout[3:0]), .carry_out(sel));
  cla4_nov_nco a1(.din1(din1[7:4]), .din2(din2[7:4]), .carry_in(1'b0), .dout(sum1));
  cla4_nov_nco a2(.din1(din1[7:4]), .din2(din2[7:4]), .carry_in(1'b1), .dout(sum2));

  assign dout[7:4] = (sel == 1'b1) ? sum2 : sum1;

endmodule
