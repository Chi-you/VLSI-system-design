// combinational ckt will assign the value immediately
`include "./unsigned.v"
`timescale 1ns/10ps
module Signed_unsigned_arithmetic_tb;
reg [3:0] i_a, i_b, i_c;
reg i_mode;
wire [7:0] o_answer;
Signed_unsigned_arithmetic s1(
    .o_answer(o_answer),
    .i_a(i_a), 
    .i_b(i_b), 
    .i_c(i_c), 
    .i_mode(i_mode)
);

initial begin
    i_mode = 0;
    i_a = 4'b0010; // 2
    i_b = 4'b0011; // 3
    i_c = 4'b0100; // 4
    // combinational ckt will assign the value immediately
    #50;
    i_mode = 1;
    i_a = 4'b1111; // -1
    i_b = 4'b1110; // -2
    i_c = 4'b0011; // 3
    #100 $finish;
end

initial begin
    $dumpfile("unsigned.vcd");
    $dumpvars;
end

endmodule
