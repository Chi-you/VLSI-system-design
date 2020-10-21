`include "./fulladder.v"
`timescale 1ns/10ps

module RCA_5bit(a, b, cin, sum, cout);

input [4:0] a, b;
input cin;
output [4:0] sum;
output cout;





Fulladder F1( .a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1) );
Fulladder F2( .a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2) );
Fulladder F3( .a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3) );
Fulladder F4( .a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(c4) );
Fulladder F5( .a(a[4]), .b(b[4]), .cin(c4), .sum(sum[4]), .cout(cout) );



endmodule