// implement a*b+c
`timescale 1ns/10ps
module Signed_unsigned_arithmetic(o_answer, i_a, i_b, i_c, i_mode);
input [3:0] i_a, i_b, i_c;
input i_mode;
output [7:0] o_answer;
wire [7:0] answer_unsigned, answer_signed;
assign answer_unsigned = i_a * i_b + {4'h0, i_c}; // as the output is 8 bits, needs sign extension(i_c)

// to do signed operation, need to sign extension first for all the number
assign answer_signed = {{4{i_a[3]}}, i_a} * {{4{i_b[3]}}, i_b} + {{4{i_c[3]}}, i_c};
assign o_answer = (i_mode == 1'b0) ? answer_unsigned : answer_signed;
endmodule