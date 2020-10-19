`include "./fulladder.v"

module Addsub_4bit(sum, cout, a, b, mode);
input [3:0] a, b;
input mode;
output [3:0] sum;
output cout;

wire [3:0] y;

// do 1's complement
xor x1(y[0], mode, b[0]);
xor x2(y[1], mode, b[1]);
xor x3(y[2], mode, b[2]);
xor x4(y[3], mode, b[3]);



Fulladder F1( .a(a[0]), .b(y[0]), .cin(mode), .sum(sum[0]), .cout(c1) );
Fulladder F2( .a(a[1]), .b(y[1]), .cin(c1), .sum(sum[1]), .cout(c2) );
Fulladder F3( .a(a[2]), .b(y[2]), .cin(c2), .sum(sum[2]), .cout(c3) );
Fulladder F4( .a(a[3]), .b(y[3]), .cin(c3), .sum(sum[3]), .cout(cout) );

endmodule