`include "./IF.v"
`include "./Encoder.v"
`include "./DFF_5bit.v"
`include "./5bit_subadd.v"
`timescale 1ns/10ps

module Syncounter(mode, clk, rst_n, counter);
input mode, clk, rst_n; // mode = 0: count 0 -> 30, mode = 1: count 30 -> 0
output [4:0] counter;
wire [4:0] sum, O; 
wire [1:0] W;

IF I1(
    .a(counter),
    .mode(mode),
    .Y(W)
);

Encoder E1(
    .a(1'b0),
    .b(W[1]),
    .c(W[0]),
    .o(O)
);

DFF_5bit D1(
    .q(counter),
    .d(sum),
    .clk(clk),
    .rst_n(rst_n)
);

Subadd_5bit R1(
    .a(counter), 
    .b(O), 
    .mode(mode), 
    .sum(sum), 
    .cout()
);

endmodule