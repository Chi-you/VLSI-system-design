`timescale 1ns/10ps
// D type FF with asynchronous reset
// reset is negative edge trigger
module DFF_asyncReset(q, d, clk, rst_n);
input d, clk, rst_n;
output q;


nand n1(o0, o3, o1);
nand n2(o1, o0, clk, rst_n);
nand n3(o2, o1, clk, o3);
nand n4(o3, o2, d, rst_n);
nand n5(q, o1, q_);
nand n6(q_, q, o2, rst_n);




endmodule