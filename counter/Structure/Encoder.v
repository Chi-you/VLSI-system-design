`timescale 1ns/10ps

module Encoder(a, b, c, o);
input a, b, c;
output [1:0] o;

nor (n1, a, b);
nor (n2, a, c);
nor (n2, n1, a);
nor (o[1], n1, 0);
nor (o[0], n2, n2);

endmodule