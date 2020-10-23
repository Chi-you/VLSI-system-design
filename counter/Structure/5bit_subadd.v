`timescale 1ns/10ps
`include "./5bit_rca.v"

module Subadd_5bit(a, b, mode, sum, cout);

input [4:0] a, b;
input mode;
output [4:0] sum;
output cout;

wire [4:0] y;
// do 1's complement
xor x1(y[0], mode, b[0]);
xor x2(y[1], mode, b[1]);
xor x3(y[2], mode, b[2]);
xor x4(y[3], mode, b[3]);
xor x5(y[4], mode, b[4]);

RCA_5bit R1(
    .a(a),
    .b(y),
    .cin(mode),
    .sum(sum),
    .cout(cout)
);


endmodule