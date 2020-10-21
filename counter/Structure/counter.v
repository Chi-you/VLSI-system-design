`include "./DFF_5bit.v"
`include "./5bit_subadd.v"
`timescale 1ns/10ps

module Syncounter(mode, clk, rst_n, counter);
input mode, clk, rst_n; // mode = 0: count 0 -> 30, mode = 1: count 30 -> 0
output [4:0] counter;
wire [4:0] sum; 


DFF_5bit D1(
    .q(counter),
    .d(sum),
    .clk(clk),
    .rst_n(rst_n)
);

Subadd_5bit R1(
    .a(counter), 
    .b(5'b1), 
    .mode(mode), 
    .sum(sum), 
    .cout()
);

// Carrylookahead C1(
//     .a(counter),
//     .b(5'b1), // mode = 1: -1, mode = 0: +1
//     .cin(mode),
//     .sum(sum),
//     .cout()
// );


endmodule