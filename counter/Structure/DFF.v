`timescale 1ns/10ps
module DFF(q, d, clk);
input d, clk;
output q, q';

not (d', d);
and (a1, clk, d');
and (a2, clk, d);

nor (q', a1, q);
nor (q, a2, q');





endmodule