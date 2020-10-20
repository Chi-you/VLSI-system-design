// implement 4 bit carry look ahead adder
`include "./fulladder.v"
`timescale 1ns/10ps
module Carrylookahead(a, b, o);
input [3:0] a, b;
output o;

Fulladder F1( .a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1) );
Fulladder F2( .a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2) );
Fulladder F3( .a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3) );
Fulladder F4( .a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(cout) );

/*
  wire [4:0]    w_C;
  wire [3:0]    w_G, w_P, w_SUM;
   
  full_adder full_adder_bit_0
    ( 
      .i_bit1(i_add1[0]),
      .i_bit2(i_add2[0]),
      .i_carry(w_C[0]),
      .o_sum(w_SUM[0]),
      .o_carry()
      );
 
  full_adder full_adder_bit_1
    ( 
      .i_bit1(i_add1[1]),
      .i_bit2(i_add2[1]),
      .i_carry(w_C[1]),
      .o_sum(w_SUM[1]),
      .o_carry()
      );
 
  full_adder full_adder_bit_2
    ( 
      .i_bit1(i_add1[2]),
      .i_bit2(i_add2[2]),
      .i_carry(w_C[2]),
      .o_sum(w_SUM[2]),
      .o_carry()
      );
   
  full_adder full_adder_bit_3
    ( 
      .i_bit1(i_add1[3]),
      .i_bit2(i_add2[3]),
      .i_carry(w_C[3]),
      .o_sum(w_SUM[3]),
      .o_carry()
      );
   
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  assign w_G[0] = i_add1[0] & i_add2[0];
  assign w_G[1] = i_add1[1] & i_add2[1];
  assign w_G[2] = i_add1[2] & i_add2[2];
  assign w_G[3] = i_add1[3] & i_add2[3];
 
  // Create the Propagate Terms: Pi=Ai+Bi
  assign w_P[0] = i_add1[0] | i_add2[0];
  assign w_P[1] = i_add1[1] | i_add2[1];
  assign w_P[2] = i_add1[2] | i_add2[2];
  assign w_P[3] = i_add1[3] | i_add2[3];
 
  // Create the Carry Terms:
  assign w_C[0] = 1'b0; // no carry input
  assign w_C[1] = w_G[0] | (w_P[0] & w_C[0]);
  assign w_C[2] = w_G[1] | (w_P[1] & w_C[1]);
  assign w_C[3] = w_G[2] | (w_P[2] & w_C[2]);
  assign w_C[4] = w_G[3] | (w_P[3] & w_C[3]);
   
  assign o_result = {w_C[4], w_SUM};   // Verilog Concatenation
  */

endmodule