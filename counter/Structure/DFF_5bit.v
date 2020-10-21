`include "./DFF_asyncR.v"
`timescale 1ns/10ps

module DFF_5bit(q, d, clk, rst_n);

input [4:0] d;
input clk, rst_n;
output [4:0] q;

DFF_asyncReset D1(
    .q(q[0]),
    .d(d[0]),
    .clk(clk),
    .rst_n(rst_n)
);

DFF_asyncReset D2(
    .q(q[1]),
    .d(d[1]),
    .clk(clk),
    .rst_n(rst_n)
);

DFF_asyncReset D3(
    .q(q[2]),
    .d(d[2]),
    .clk(clk),
    .rst_n(rst_n)
);

DFF_asyncReset D4(
    .q(q[3]),
    .d(d[3]),
    .clk(clk),
    .rst_n(rst_n)
);

DFF_asyncReset D5(
    .q(q[4]),
    .d(d[4]),
    .clk(clk),
    .rst_n(rst_n)
);


endmodule