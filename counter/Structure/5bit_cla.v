// implement 5 bit carry look ahead adder
// `include "./fulladder.v"
`timescale 1ns/10ps
module Carrylookahead(a, b, cin, sum, cout);
input [4:0] a, b;
input cin;
output [4:0]sum;
output cout;
wire [4:0] P, G;
wire [5:0] C;

// Fulladder F1( .a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1) );
// Fulladder F2( .a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2) );
// Fulladder F3( .a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3) );
// Fulladder F4( .a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(cout) );

// generate P, G
xor x1(P[0], a[0], b[0]);
and a1(G[0], a[0], b[0]);
xor x2(P[1], a[1], b[1]);
and a2(G[1], a[1], b[1]);
xor x3(P[2], a[2], b[2]);
and a3(G[2], a[2], b[2]);
xor x4(P[3], a[3], b[3]);
and a4(G[3], a[3], b[3]);
xor x4(P[4], a[4], b[4]);
and a4(G[4], a[4], b[4]);

// carry lookahead block
// C1
and an1(pc0, P[0], C[0]);
or o1(gpc0, G[0], pc0);
// C2
and an2(pc1, P[1], C[1]);
or o2(gpc1, G[1], pc1);
// C3
and an3(pc2, P[2], C[2]);
or o3(gpc2, G[2], pc2);
// C4
and an4(pc3, P[3], C[3]);
or o4(gpc3, G[3], pc3);
// C5
and an4(pc4, P[4], C[4]);
or o4(cout, G[4], pc4);

// generate sum, cout
xor xo1(sum[0], P[0], cin);
xor xo2(sum[1], P[1], gpc0);
xor xo3(sum[2], P[2], gpc1);
xor xo4(sum[3], P[3], gpc2);
xor xo5(sum[4], P[4], gpc3);

endmodule