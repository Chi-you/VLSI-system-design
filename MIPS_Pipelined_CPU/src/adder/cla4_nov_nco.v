module cla4_nov_nco(din1, din2, carry_in, dout);

  input	[3:0]	din1,din2;
  input		carry_in;
  output[3:0]	dout;

  wire	[2:0]	din_and, din_or;
  wire	[3:0]	c;

  assign din_and[0] = din1[0] & din2[0];
  assign din_and[1] = din1[1] & din2[1];
  assign din_and[2] = din1[2] & din2[2];
  //assign din_and[3] = din1[3] & din2[3];

  assign din_or[0] = din1[0] | din2[0];
  assign din_or[1] = din1[1] | din2[1];
  assign din_or[2] = din1[2] | din2[2];
  //assign din_or[3] = din1[3] | din2[3];

  assign c[0] = carry_in;
  assign c[1] = din_and[0] | (din_or[0] & c[0]);
  assign c[2] = din_and[1] | (din_or[1] & din_and[0]) | (din_or[1] & din_or[0] & c[0]); // din_and[1] | (din_or[1] & c[1])
  assign c[3] = din_and[2] | (din_or[2] & din_and[1]) | (din_or[2] & din_or[1] & din_and[0]) | (din_or[2] & din_or[1] & din_or[0] & c[0]); // din_and[2] | (din_or[2] & c[2])

  assign dout[0] = din1[0] ^ din2[0] ^ c[0];
  assign dout[1] = din1[1] ^ din2[1] ^ c[1];
  assign dout[2] = din1[2] ^ din2[2] ^ c[2];
  assign dout[3] = din1[3] ^ din2[3] ^ c[3];


endmodule
